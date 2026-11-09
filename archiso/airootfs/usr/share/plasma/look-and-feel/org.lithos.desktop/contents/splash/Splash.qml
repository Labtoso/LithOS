import QtQuick

Rectangle {
    id: root
    color: "#0d1117"
    property int stage
    Image {
        id: logo
        anchors.centerIn: parent
        source: "images/logo.png"
        sourceSize.width: 128
        sourceSize.height: 128
    }
    Row {
        anchors.top: logo.bottom
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        Repeater {
            model: 6
            Rectangle {
                width: 8; height: 8; radius: 4
                color: index < root.stage ? "#3b82f6" : "#30363d"
            }
        }
    }
}
