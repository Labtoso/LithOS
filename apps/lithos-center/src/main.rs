mod backend;

use cxx_qt_lib::{QGuiApplication, QQmlApplicationEngine, QString, QUrl};

fn main() {
    let page = match std::env::args().nth(1).as_deref() {
        Some("settings") => "Settings",
        _ => "Welcome",
    };
    let desktop = if page == "Settings" { "lithos-settings" } else { "lithos-welcome" };
    QGuiApplication::set_desktop_file_name(&QString::from(desktop));
    let mut app = QGuiApplication::new();
    let mut engine = QQmlApplicationEngine::new();
    if let Some(engine) = engine.as_mut() {
        engine.load(&QUrl::from(&format!("qrc:/qt/qml/org/lithos/center/qml/{page}.qml")));
    }
    if let Some(app) = app.as_mut() {
        app.exec();
    }
}
