use cxx_qt_build::{CxxQtBuilder, QmlModule};

fn main() {
    CxxQtBuilder::new()
        .qml_module(QmlModule {
            uri: "org.lithos.center",
            rust_files: &["src/backend.rs"],
            qml_files: &[
                "qml/Card.qml",
                "qml/LButton.qml",
                "qml/NavItem.qml",
                "qml/AccentPicker.qml",
                "qml/ExtrasPage.qml",
                "qml/Welcome.qml",
                "qml/Settings.qml",
            ],
            ..Default::default()
        })
        .build();
}
