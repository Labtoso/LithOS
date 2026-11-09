import QtQuick

Rectangle {
    default property alias content: inner.data
    property int pad: 20
    color: "#161b22"
    radius: 10
    border.color: "#30363d"
    border.width: 1
    implicitHeight: inner.childrenRect.height + pad * 2
    Item {
        id: inner
        anchors.fill: parent
        anchors.margins: parent.pad
    }
}
