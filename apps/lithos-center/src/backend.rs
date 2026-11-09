// Verbindung zwischen der Oberfläche (QML) und dem System
#[cxx_qt::bridge]
pub mod qobject {
    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        type QString = cxx_qt_lib::QString;
    }

    extern "RustQt" {
        #[qobject]
        #[qml_element]
        type Backend = super::BackendRust;
    }

    extern "RustQt" {
        #[qinvokable]
        fn run_terminal(self: &Backend, title: &QString, cmd: &QString);
        #[qinvokable]
        fn run_detached(self: &Backend, cmd: &QString);
        #[qinvokable]
        fn output(self: &Backend, cmd: &QString) -> QString;
        #[qinvokable]
        fn install(self: &Backend, packages: &QString);
        #[qinvokable]
        fn accent(self: &Backend) -> QString;
        #[qinvokable]
        fn set_accent(self: &Backend, color: &QString);
        #[qinvokable]
        fn read_setting(self: &Backend, key: &QString, fallback: &QString) -> QString;
        #[qinvokable]
        fn write_setting(self: &Backend, key: &QString, value: &QString);
        #[qinvokable]
        fn set_welcome_autostart(self: &Backend, on: bool);
        #[qinvokable]
        fn welcome_autostart(self: &Backend) -> bool;
        #[qinvokable]
        fn set_update_notify(self: &Backend, on: bool);
        #[qinvokable]
        fn update_notify(self: &Backend) -> bool;
    }
}

use cxx_qt_lib::QString;
use std::path::PathBuf;
use std::process::{Command, Stdio};

#[derive(Default)]
pub struct BackendRust;

fn home() -> PathBuf {
    PathBuf::from(std::env::var("HOME").unwrap_or_else(|_| "/tmp".into()))
}

fn config_dir() -> PathBuf {
    let base = std::env::var("XDG_CONFIG_HOME")
        .map(PathBuf::from)
        .unwrap_or_else(|_| home().join(".config"));
    base.join("lithos")
}

fn spawn(cmd: &str) {
    let _ = Command::new("sh")
        .arg("-c")
        .arg(cmd)
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn();
}

fn shell_quote(s: &str) -> String {
    format!("'{}'", s.replace('\'', "'\\''"))
}

fn valid_packages(list: &str) -> Vec<String> {
    list.split_whitespace()
        .filter(|p| p.chars().all(|c| c.is_ascii_alphanumeric() || "-_.+@".contains(c)))
        .map(|p| p.to_string())
        .collect()
}

fn valid_color(c: &str) -> bool {
    c.len() == 7 && c.starts_with('#') && c[1..].chars().all(|x| x.is_ascii_hexdigit())
}

impl qobject::Backend {
    fn run_terminal(&self, title: &QString, cmd: &QString) {
        let script = format!(
            "{}; echo; read -rp 'Fertig. Enter zum Schließen.' _",
            cmd.to_string()
        );
        let full = format!(
            "kitty --title {} bash -c {}",
            shell_quote(&title.to_string()),
            shell_quote(&script)
        );
        spawn(&full);
    }

    fn run_detached(&self, cmd: &QString) {
        spawn(&cmd.to_string());
    }

    fn output(&self, cmd: &QString) -> QString {
        let out = Command::new("sh")
            .arg("-c")
            .arg(cmd.to_string())
            .stdin(Stdio::null())
            .output();
        match out {
            Ok(o) => QString::from(String::from_utf8_lossy(&o.stdout).trim_end()),
            Err(_) => QString::default(),
        }
    }

    fn install(&self, packages: &QString) {
        let pkgs = valid_packages(&packages.to_string());
        if pkgs.is_empty() {
            return;
        }
        let list = pkgs.join(" ");
        let cmd = format!(
            "echo 'Wird installiert: {list}'; echo; if command -v paru >/dev/null; then paru -S --needed {list}; else sudo pacman -S --needed {list}; fi"
        );
        self.run_terminal(&QString::from("LithOS: Installieren"), &QString::from(&cmd));
    }

    fn accent(&self) -> QString {
        let c = std::fs::read_to_string(config_dir().join("accent"))
            .unwrap_or_default()
            .trim()
            .to_string();
        if valid_color(&c) {
            QString::from(&c)
        } else {
            QString::from("#3b82f6")
        }
    }

    fn set_accent(&self, color: &QString) {
        let c = color.to_string();
        if !valid_color(&c) {
            return;
        }
        let _ = std::fs::create_dir_all(config_dir());
        let _ = std::fs::write(config_dir().join("accent"), &c);
        spawn(&format!("plasma-apply-colorscheme --accent-color {}", shell_quote(&c)));
    }

    fn read_setting(&self, key: &QString, fallback: &QString) -> QString {
        let k = key.to_string();
        let data = std::fs::read_to_string(config_dir().join("center.conf")).unwrap_or_default();
        for line in data.lines() {
            if let Some((a, b)) = line.split_once('=') {
                if a.trim() == k {
                    return QString::from(b.trim());
                }
            }
        }
        fallback.clone()
    }

    fn write_setting(&self, key: &QString, value: &QString) {
        let k = key.to_string();
        let v = value.to_string().replace('\n', " ");
        let path = config_dir().join("center.conf");
        let data = std::fs::read_to_string(&path).unwrap_or_default();
        let mut lines: Vec<String> = data
            .lines()
            .filter(|l| l.split_once('=').map(|(a, _)| a.trim() != k).unwrap_or(true))
            .map(|l| l.to_string())
            .collect();
        lines.push(format!("{k}={v}"));
        let _ = std::fs::create_dir_all(config_dir());
        let _ = std::fs::write(path, lines.join("\n") + "\n");
    }

    fn set_welcome_autostart(&self, on: bool) {
        let dir = home().join(".config/autostart");
        let file = dir.join("lithos-welcome.desktop");
        if on {
            let _ = std::fs::remove_file(&file);
        } else {
            let _ = std::fs::create_dir_all(&dir);
            let _ = std::fs::write(
                &file,
                "[Desktop Entry]\nType=Application\nName=LithOS Willkommen\nExec=lithos-welcome\nHidden=true\n",
            );
        }
    }

    fn welcome_autostart(&self) -> bool {
        !home().join(".config/autostart/lithos-welcome.desktop").exists()
    }

    fn set_update_notify(&self, on: bool) {
        let _ = std::fs::create_dir_all(config_dir());
        let _ = std::fs::write(
            config_dir().join("updates.conf"),
            format!("ENABLED={}\n", if on { 1 } else { 0 }),
        );
    }

    fn update_notify(&self) -> bool {
        let data = std::fs::read_to_string(config_dir().join("updates.conf")).unwrap_or_default();
        !data.lines().any(|l| l.trim() == "ENABLED=0")
    }
}
