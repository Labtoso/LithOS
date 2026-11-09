import QtQuick

Row {
    id: picker
    property string current: "#3b82f6"
    signal picked(string color)
    spacing: 12
    Repeater {
        model: ["#3b82f6", "#06b6d4", "#10b981", "#84cc16", "#f59e0b", "#ef4444", "#ec4899", "#8b5cf6", "#94a3b8"]
        Rectangle {
            width: 32; height: 32; radius: 16
            color: modelData
            border.width: picker.current.toLowerCase() === modelData ? 3 : 0
            border.color: "#e6edf3"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: { picker.current = modelData; picker.picked(modelData) }
            }
        }
    }
}
