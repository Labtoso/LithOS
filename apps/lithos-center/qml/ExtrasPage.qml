import QtQuick
import QtQuick.Controls

// Extras und weitere Desktops auswählen und installieren (beliebig viele gleichzeitig)
Item {
    id: page
    property var backend
    property color accent: "#3b82f6"
    property var picked: ({})
    property int count: 0

    readonly property var groups: [
        { title: "Desktops (mehrere möglich, Auswahl beim Login)", items: [
            { name: "GNOME", desc: "Modern und aufgeräumt", pkgs: "gnome gnome-tweaks" },
            { name: "XFCE", desc: "Leicht und klassisch", pkgs: "xfce4 xfce4-goodies" },
            { name: "Cinnamon", desc: "Vertraut wie Windows", pkgs: "cinnamon nemo-fileroller" },
            { name: "Hyprland", desc: "Kachel-Fenster mit Animationen", pkgs: "hyprland waybar wofi hyprpaper xdg-desktop-portal-hyprland" },
            { name: "COSMIC", desc: "Neuer Desktop von System76", pkgs: "cosmic" },
            { name: "i3", desc: "Kachel-Fenster, sehr schlank", pkgs: "i3-wm i3status i3lock dmenu" }
        ]},
        { title: "Gaming", items: [
            { name: "Steam", desc: "Spiele-Plattform mit Proton", pkgs: "steam" },
            { name: "Lutris", desc: "Spiele aus vielen Quellen", pkgs: "lutris wine-staging winetricks" },
            { name: "Heroic", desc: "Epic, GOG und Amazon", pkgs: "heroic-games-launcher-bin" },
            { name: "Leistung", desc: "GameMode und MangoHud", pkgs: "gamemode lib32-gamemode mangohud lib32-mangohud" },
            { name: "ProtonUp-Qt", desc: "Proton-GE verwalten", pkgs: "protonup-qt" }
        ]},
        { title: "Programmieren", items: [
            { name: "VS Code", desc: "Code-Editor (Open Source)", pkgs: "code" },
            { name: "Werkzeuge", desc: "git, base-devel, Rust, Python, Node.js", pkgs: "git base-devel rustup python nodejs npm" },
            { name: "Docker", desc: "Container", pkgs: "docker docker-compose" }
        ]},
        { title: "Büro und Medien", items: [
            { name: "LibreOffice", desc: "Office auf Deutsch", pkgs: "libreoffice-fresh libreoffice-fresh-de" },
            { name: "Okular", desc: "PDF-Betrachter", pkgs: "okular" },
            { name: "VLC", desc: "Videos und Musik", pkgs: "vlc" },
            { name: "OBS Studio", desc: "Aufnehmen und Streamen", pkgs: "obs-studio" },
            { name: "GIMP und Krita", desc: "Bildbearbeitung und Malen", pkgs: "gimp krita" },
            { name: "Kdenlive", desc: "Videoschnitt", pkgs: "kdenlive" }
        ]},
        { title: "Kommunikation und Nützliches", items: [
            { name: "Discord", desc: "Chat und Sprache", pkgs: "discord" },
            { name: "Thunderbird", desc: "E-Mail", pkgs: "thunderbird thunderbird-i18n-de" },
            { name: "KDE Connect", desc: "Handy verbinden", pkgs: "kdeconnect" },
            { name: "Systemwerkzeuge", desc: "Partitionen, Speicher, Rechner", pkgs: "partitionmanager filelight kcalc" },
            { name: "Btrfs Assistant", desc: "Snapshots grafisch verwalten", pkgs: "btrfs-assistant" }
        ]}
    ]

    function toggle(pkgs) {
        var p = picked
        if (p[pkgs]) delete p[pkgs]; else p[pkgs] = true
        picked = p
        count = Object.keys(p).length
    }

    Flickable {
        id: flick
        anchors.fill: parent
        anchors.bottomMargin: 64
        contentHeight: col.height
        clip: true
        ScrollBar.vertical: ScrollBar {}
        Column {
            id: col
            width: flick.width - 12
            spacing: 18
            Repeater {
                model: page.groups
                Column {
                    width: col.width
                    spacing: 8
                    Text { text: modelData.title; color: "#e6edf3"; font.pixelSize: 16; font.bold: true }
                    Flow {
                        width: parent.width
                        spacing: 10
                        Repeater {
                            model: modelData.items
                            Rectangle {
                                property bool on: page.picked[modelData.pkgs] === true
                                width: (col.width - 20) / 3
                                height: 62
                                radius: 8
                                color: on ? "#1c2533" : "#161b22"
                                border.color: on ? page.accent : "#30363d"
                                border.width: 1
                                Rectangle {
                                    id: box
                                    width: 18; height: 18; radius: 4
                                    anchors.left: parent.left; anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: parent.on ? page.accent : "transparent"
                                    border.color: parent.on ? page.accent : "#6e7681"
                                    Text { anchors.centerIn: parent; text: "✓"; color: "white"; visible: parent.parent.on; font.pixelSize: 12 }
                                }
                                Column {
                                    anchors.left: box.right; anchors.leftMargin: 12
                                    anchors.right: parent.right; anchors.rightMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text { text: modelData.name; color: "#e6edf3"; font.pixelSize: 14; elide: Text.ElideRight; width: parent.width }
                                    Text { text: modelData.desc; color: "#8b949e"; font.pixelSize: 12; elide: Text.ElideRight; width: parent.width }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: page.toggle(modelData.pkgs)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 10
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: page.count === 0 ? "Nichts ausgewählt" : page.count + " ausgewählt"
            color: "#8b949e"; font.pixelSize: 13
        }
        LButton {
            text: "Ausgewählte installieren"
            primary: true
            accent: page.accent
            enabled: page.count > 0
            onClicked: {
                page.backend.install(Object.keys(page.picked).join(" "))
                page.picked = ({}); page.count = 0
            }
        }
    }
}
