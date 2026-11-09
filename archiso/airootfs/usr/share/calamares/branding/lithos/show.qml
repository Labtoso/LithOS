import QtQuick 2.15
import calamares.slideshow 1.0

Presentation {
    id: presentation
    function nextSlide() { presentation.goToNextSlide(); }
    Timer { interval: 8000; running: presentation.activatedInCalamares; repeat: true; onTriggered: nextSlide() }

    Rectangle { anchors.fill: parent; color: "#0d1117"; z: -1 }

    Slide {
        Column { anchors.centerIn: parent; spacing: 18; width: parent.width * 0.8
            Image { source: "logo.png"; width: 120; height: 120; anchors.horizontalCenter: parent.horizontalCenter; fillMode: Image.PreserveAspectFit }
            Text { text: qsTr("Willkommen bei LithOS"); color: "#E5E7EB"; font.pixelSize: 26; font.weight: Font.DemiBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: qsTr("LithOS wird jetzt installiert. Das dauert ein paar Minuten."); color: "#9CA3AF"; font.pixelSize: 16; wrapMode: Text.WordWrap; width: parent.width; horizontalAlignment: Text.AlignHCenter }
        }
    }
    Slide {
        Column { anchors.centerIn: parent; spacing: 14; width: parent.width * 0.8
            Text { text: qsTr("Schnell und sicher"); color: "#E5E7EB"; font.pixelSize: 24; font.weight: Font.DemiBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: qsTr("Eigener gehärteter LithOS-Kernel, Firewall ab Werk und btrfs-Snapshots, mit denen du jederzeit zurück kannst."); color: "#9CA3AF"; font.pixelSize: 16; wrapMode: Text.WordWrap; width: parent.width; horizontalAlignment: Text.AlignHCenter }
        }
    }
    Slide {
        Column { anchors.centerIn: parent; spacing: 14; width: parent.width * 0.8
            Text { text: qsTr("Alles an einem Ort"); color: "#E5E7EB"; font.pixelSize: 24; font.weight: Font.DemiBold; anchors.horizontalCenter: parent.horizontalCenter }
            Text { text: qsTr("Nach dem ersten Start hilft dir die Willkommens-App bei Treibern, Spielen und Programmen."); color: "#9CA3AF"; font.pixelSize: 16; wrapMode: Text.WordWrap; width: parent.width; horizontalAlignment: Text.AlignHCenter }
        }
    }
}
