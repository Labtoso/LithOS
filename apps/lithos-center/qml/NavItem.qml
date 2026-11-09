import QtQuick

Rectangle {
    id: n
    property string text
    property bool active: false
    property color accent: "#3b82f6"
    signal clicked()
    width: parent ? parent.width : 180
    height: 38
    radius: 8
    color: active ? "#1f2630" : (area.containsMouse ? "#181e26" : "transparent")
    Rectangle {
        visible: n.active
        width: 3; height: 18; radius: 2
        color: n.accent
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        text: n.text
        color: n.active ? "#e6edf3" : "#8b949e"
        font.pixelSize: 14
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: n.clicked()
    }
}
