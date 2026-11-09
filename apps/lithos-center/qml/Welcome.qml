import QtQuick
import QtQuick.Controls
import org.lithos.center

ApplicationWindow {
    id: win
    width: 1060; height: 700
    minimumWidth: 900; minimumHeight: 600
    visible: true
    title: "Willkommen bei LithOS"
    color: "#0d1117"
    property string accent: backend.accent()
    property int page: 0

    Backend { id: backend }

    Rectangle {
        id: side
        width: 220; anchors.top: parent.top; anchors.bottom: parent.bottom
        color: "#0b0f14"
        Column {
            anchors.fill: parent; anchors.margins: 16; spacing: 4
            Image { source: "file:///usr/share/icons/hicolor/64x64/apps/lithos-logo.png"; width: 48; height: 48; sourceSize.width: 48; sourceSize.height: 48 }
            Text { text: "LithOS"; color: "#e6edf3"; font.pixelSize: 20; font.bold: true }
            Text { text: "1.1 Granit"; color: "#6e7681"; font.pixelSize: 12 }
            Item { width: 1; height: 18 }
            NavItem { text: "Willkommen"; accent: win.accent; active: win.page === 0; onClicked: win.page = 0 }
            NavItem { text: "Extras und Desktops"; accent: win.accent; active: win.page === 1; onClicked: win.page = 1 }
            NavItem { text: "Treiber und System"; accent: win.accent; active: win.page === 2; onClicked: win.page = 2 }
            NavItem { text: "Hilfe"; accent: win.accent; active: win.page === 3; onClicked: win.page = 3 }
        }
        Row {
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 16; spacing: 8
            Rectangle {
                id: auto
                property bool on: backend.welcome_autostart()
                width: 18; height: 18; radius: 4
                color: on ? win.accent : "transparent"; border.color: on ? win.accent : "#6e7681"
                Text { anchors.centerIn: parent; text: "✓"; color: "white"; visible: parent.on; font.pixelSize: 12 }
                MouseArea { anchors.fill: parent; onClicked: { auto.on = !auto.on; backend.set_welcome_autostart(auto.on) } }
            }
            Text { text: "Beim Start anzeigen"; color: "#8b949e"; font.pixelSize: 13 }
        }
    }

    Item {
        anchors.left: side.right; anchors.right: parent.right
        anchors.top: parent.top; anchors.bottom: parent.bottom
        anchors.margins: 28

        // Seite 0: Willkommen
        Column {
            visible: win.page === 0
            width: parent.width; spacing: 18
            Text { text: "Willkommen bei LithOS"; color: "#e6edf3"; font.pixelSize: 28; font.bold: true }
            Text {
                width: parent.width; wrapMode: Text.WordWrap; color: "#8b949e"; font.pixelSize: 15
                text: "Schön, dass du da bist. Hier richtest du LithOS in ein paar Schritten ein: Farbe wählen, Programme und weitere Desktops installieren, Treiber prüfen. Alles kannst du später in den LithOS-Einstellungen wieder ändern."
            }
            Card {
                width: parent.width
                Column {
                    spacing: 12
                    Text { text: "Akzentfarbe"; color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
                    Text { text: "Wird sofort für Knöpfe, Auswahl und Hervorhebungen übernommen."; color: "#8b949e"; font.pixelSize: 13 }
                    AccentPicker { current: win.accent; onPicked: (c) => { win.accent = c; backend.set_accent(c) } }
                }
            }
            Card {
                width: parent.width
                Column {
                    spacing: 10
                    Text { text: "Nächste Schritte"; color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
                    Row {
                        spacing: 10
                        LButton { text: "Extras auswählen"; primary: true; accent: win.accent; onClicked: win.page = 1 }
                        LButton { text: "Treiber prüfen"; onClicked: win.page = 2 }
                        LButton { text: "LithOS-Einstellungen"; onClicked: backend.run_detached("lithos-settings") }
                    }
                }
            }
        }

        // Seite 1: Extras
        ExtrasPage {
            visible: win.page === 1
            anchors.fill: parent
            backend: backend
            accent: win.accent
        }

        // Seite 2: Treiber und System
        Column {
            visible: win.page === 2
            width: parent.width; spacing: 16
            Text { text: "Treiber und System"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Text { text: "Treiber"; color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
                    Text {
                        width: parent.width; wrapMode: Text.WordWrap; color: "#8b949e"; font.pixelSize: 13
                        text: "LithOS erkennt deine Hardware und richtet automatisch die besten Treiber ein, auch für Nvidia. Installiert:"
                    }
                    Text {
                        width: parent.width; wrapMode: Text.WordWrap; color: "#e6edf3"; font.family: "monospace"; font.pixelSize: 12
                        text: { var o = backend.output("chwd --list-installed 2>/dev/null | grep -v '^>' | sed '/^\\s*$/d' | head -12"); return o === "" ? "Noch keine Profile installiert." : o }
                    }
                    Row {
                        spacing: 10
                        LButton { text: "Treiber automatisch einrichten"; primary: true; accent: win.accent; onClicked: backend.run_terminal("LithOS: Treiber", "sudo pacman -Sy && sudo chwd -a") }
                        LButton { text: "Alle Profile anzeigen"; onClicked: backend.run_terminal("LithOS: Treiber", "chwd --list-all") }
                    }
                }
            }
            Card {
                width: parent.width
                Column {
                    spacing: 10
                    Text { text: "System"; color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
                    Row {
                        spacing: 10
                        LButton { text: "Jetzt aktualisieren"; onClicked: backend.run_detached("kitty --title 'LithOS Update' lithos-update") }
                        LButton { text: "Firewall"; onClicked: backend.run_detached("systemsettings kcm_firewall") }
                        LButton { text: "Bildschirme"; onClicked: backend.run_detached("systemsettings kcm_kscreen") }
                    }
                }
            }
        }

        // Seite 3: Hilfe
        Column {
            visible: win.page === 3
            width: parent.width; spacing: 16
            Text { text: "Hilfe"; color: "#e6edf3"; font.pixelSize: 24; font.bold: true }
            Card {
                width: parent.width
                Column {
                    spacing: 10; width: parent.width
                    Text { width: parent.width; wrapMode: Text.WordWrap; color: "#8b949e"; font.pixelSize: 14
                        text: "LithOS basiert auf Arch Linux. Programme installierst du hier, über Flatpak oder im Terminal mit paru. Vor jedem Update wird automatisch ein Snapshot angelegt, den du im Startmenü (GRUB) wieder starten kannst." }
                    Row {
                        spacing: 10
                        LButton { text: "Website"; onClicked: Qt.openUrlExternally("https://lithos.labtoso.de") }
                        LButton { text: "GitHub"; onClicked: Qt.openUrlExternally("https://github.com/Labtoso/LithOS") }
                        LButton { text: "Arch Wiki"; onClicked: Qt.openUrlExternally("https://wiki.archlinux.org/") }
                    }
                }
            }
        }
    }
}
