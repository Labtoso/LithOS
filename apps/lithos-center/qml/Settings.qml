import QtQuick
import QtQuick.Controls
import org.lithos.center

ApplicationWindow {
    id: win
    width: 1060; height: 700
    minimumWidth: 900; minimumHeight: 600
    visible: true
    title: "LithOS-Einstellungen"
    color: "#0d1117"
    property string accent: backend.accent()
    property int page: 0

    Backend { id: backend }

    component Heading: Text { color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
    component Info: Text { color: "#8b949e"; font.pixelSize: 13; wrapMode: Text.WordWrap }
    component Mono: Text { color: "#e6edf3"; font.family: "monospace"; font.pixelSize: 12; wrapMode: Text.WrapAnywhere }
    component Toggle: Rectangle {
        id: t
        property bool on
        signal toggled(bool on)
        width: 40; height: 22; radius: 11
        color: on ? win.accent : "#30363d"
        Rectangle { width: 16; height: 16; radius: 8; color: "white"; y: 3; x: t.on ? 21 : 3; Behavior on x { NumberAnimation { duration: 120 } } }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { t.on = !t.on; t.toggled(t.on) } }
    }

    Rectangle {
        id: side
        width: 220; anchors.top: parent.top; anchors.bottom: parent.bottom
        color: "#0b0f14"
        Column {
            anchors.fill: parent; anchors.margins: 16; spacing: 4
            Image { source: "file:///usr/share/icons/hicolor/64x64/apps/lithos-logo.png"; width: 48; height: 48; sourceSize.width: 48; sourceSize.height: 48 }
            Text { text: "Einstellungen"; color: "#e6edf3"; font.pixelSize: 20; font.bold: true }
            Item { width: 1; height: 18 }
            Repeater {
                model: ["Aussehen", "Updates", "Kernel", "Snapshots", "Treiber", "Extras und Desktops", "Über LithOS"]
                NavItem { text: modelData; accent: win.accent; active: win.page === index; onClicked: win.page = index }
            }
        }
    }

    Item {
        id: content
        anchors.left: side.right; anchors.right: parent.right
        anchors.top: parent.top; anchors.bottom: parent.bottom
        anchors.margins: 28

        // Aussehen
        Column {
            visible: win.page === 0; width: parent.width; spacing: 16
            Text { text: "Aussehen"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 12
                    Heading { text: "Akzentfarbe" }
                    AccentPicker { current: win.accent; onPicked: (c) => { win.accent = c; backend.set_accent(c) } }
                }
            }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Heading { text: "Design" }
                    Row {
                        spacing: 10
                        LButton { text: "LithOS Dunkel"; onClicked: backend.run_detached("plasma-apply-lookandfeel -a org.lithos.desktop && plasma-apply-colorscheme --accent-color '" + win.accent + "'") }
                        LButton { text: "Hell"; onClicked: backend.run_detached("plasma-apply-colorscheme BreezeLight && plasma-apply-colorscheme --accent-color '" + win.accent + "'") }
                        LButton { text: "Hintergrundbild"; onClicked: backend.run_detached("systemsettings kcm_wallpaper") }
                    }
                }
            }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Heading { text: "Startbildschirm (Plymouth)" }
                    Info { width: parent.width; text: "Aktiv: " + backend.output("plymouth-set-default-theme 2>/dev/null") + ". Weitere Designs gibt es im KDE Store." }
                    Row {
                        spacing: 10
                        LButton { text: "Designs aus dem KDE Store"; primary: true; accent: win.accent; onClicked: backend.run_detached("systemsettings kcm_plymouth") }
                        LButton { text: "Zurück zu LithOS"; onClicked: backend.run_terminal("LithOS: Startbildschirm", "sudo plymouth-set-default-theme -R lithos") }
                    }
                }
            }
        }

        // Updates
        Column {
            visible: win.page === 1; width: parent.width; spacing: 16
            Text { text: "Updates"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Row {
                    spacing: 14; width: parent.width
                    Toggle { on: backend.update_notify(); onToggled: (v) => backend.set_update_notify(v) }
                    Column {
                        width: parent.width - 60
                        Heading { text: "Über Updates benachrichtigen" }
                        Info { width: parent.width; text: "LithOS schaut alle 4 Stunden nach Updates und fragt dich. Es wird nie von selbst installiert. Vor jedem Update legt LithOS automatisch einen Snapshot an." }
                    }
                }
            }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Heading { text: "Verfügbar" }
                    Mono { id: avail; width: parent.width; text: "Noch nicht geprüft." }
                    Row {
                        spacing: 10
                        LButton { text: "Jetzt prüfen"; onClicked: { var o = backend.output("checkupdates 2>/dev/null | head -20"); avail.text = o === "" ? "Alles aktuell." : o } }
                        LButton { text: "Jetzt aktualisieren"; primary: true; accent: win.accent; onClicked: backend.run_detached("kitty --title 'LithOS Update' lithos-update") }
                    }
                }
            }
        }

        // Kernel
        Column {
            visible: win.page === 2; width: parent.width; spacing: 16
            Text { text: "Kernel"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Heading { text: "Läuft gerade" }
                    Mono { width: parent.width; text: backend.output("uname -r") }
                    Info { width: parent.width; text: "Installierte Kernel: " + backend.output("pacman -Qq | grep -E '^linux(-[a-z0-9-]+)?$' | grep -v -- '-headers$' | grep -v firmware | tr '\\n' ' '") }
                    Info { width: parent.width; text: "linux-lithos ist der LithOS-Kernel: CachyOS-Optimierungen mit BORE-Scheduler und zusätzlichem Schutz. Weitere Kernel erscheinen im Startmenü als Alternative." }
                    Row {
                        spacing: 10
                        LButton { text: "CachyOS-Kernel dazu"; onClicked: backend.install("linux-cachyos linux-cachyos-headers") }
                        LButton { text: "LTS-Kernel dazu"; onClicked: backend.install("linux-lts linux-lts-headers") }
                        LButton { text: "Startmenü neu erzeugen"; onClicked: backend.run_terminal("LithOS: GRUB", "sudo grub-mkconfig -o /boot/grub/grub.cfg") }
                    }
                }
            }
        }

        // Snapshots
        Column {
            visible: win.page === 3; width: parent.width; spacing: 16
            Text { text: "Snapshots"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Info { width: parent.width; text: "Snapshots sichern den Systemzustand. Vor und nach jedem Update entsteht automatisch einer. Ein alter Stand lässt sich im Startmenü unter \"LithOS snapshots\" starten." }
                    Row {
                        spacing: 10
                        LButton { text: "Snapshot jetzt anlegen"; primary: true; accent: win.accent; onClicked: backend.run_terminal("LithOS: Snapshot", "sudo snapper -c root create --description 'Manuell' && echo 'Snapshot angelegt.'") }
                        LButton { text: "Snapshots anzeigen"; onClicked: backend.run_terminal("LithOS: Snapshots", "sudo snapper -c root list") }
                        LButton { text: "Btrfs Assistant"; onClicked: backend.install("btrfs-assistant") }
                    }
                }
            }
        }

        // Treiber
        Column {
            visible: win.page === 4; width: parent.width; spacing: 16
            Text { text: "Treiber"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Heading { text: "Installierte Treiberprofile" }
                    Mono { width: parent.width; text: { var o = backend.output("chwd --list-installed 2>/dev/null | grep -v '^>' | sed '/^\\s*$/d' | head -14"); return o === "" ? "Keine." : o } }
                    Row {
                        spacing: 10
                        LButton { text: "Automatisch einrichten"; primary: true; accent: win.accent; onClicked: backend.run_terminal("LithOS: Treiber", "sudo pacman -Sy && sudo chwd -a") }
                        LButton { text: "Alle Profile"; onClicked: backend.run_terminal("LithOS: Treiber", "chwd --list-all") }
                    }
                }
            }
        }

        // Extras
        ExtrasPage {
            visible: win.page === 5
            anchors.fill: parent
            backend: backend
            accent: win.accent
        }

        // Über
        Column {
            visible: win.page === 6; width: parent.width; spacing: 16
            Text { text: "Über LithOS"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 6; width: parent.width
                    Mono { width: parent.width; text: backend.output(". /etc/os-release; echo \"$PRETTY_NAME\"; echo; echo \"Kernel:  $(uname -r)\"; echo \"Desktop: KDE Plasma $(plasmashell --version 2>/dev/null | awk '{print $2}')\"; echo \"CPU:     $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')\"; echo \"GPU:     $(lspci 2>/dev/null | grep -Ei 'vga|3d' | cut -d: -f3 | sed 's/^ //' | head -2 | tr '\\n' ' ')\"; echo \"RAM:     $(free -h | awk '/Mem/ {print $2}')\"") }
                    Row {
                        spacing: 10
                        LButton { text: "Willkommen-App öffnen"; onClicked: backend.run_detached("lithos-welcome") }
                        LButton { text: "Website"; onClicked: Qt.openUrlExternally("https://lithos.labtoso.de") }
                    }
                }
            }
        }
    }
}
