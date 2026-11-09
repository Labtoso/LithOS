import QtQuick

Rectangle {
    id: b
    property string text
    property bool primary: false
    property color accent: "#3b82f6"
    signal clicked()
    implicitWidth: label.implicitWidth + 32
    implicitHeight: 36
    radius: 8
    color: primary ? (area.containsMouse ? Qt.lighter(accent, 1.1) : accent)
                   : (area.containsMouse ? "#262c36" : "#21262d")
    border.color: primary ? "transparent" : "#30363d"
    opacity: enabled ? 1 : 0.5
    Text {
        id: label
        anchors.centerIn: parent
        text: b.text
        color: "#e6edf3"
        font.pixelSize: 14
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
    }
}
