import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 200
    height: 40

    property bool checked: false
    property string labelText: "Checkbox"
    property color checkboxColor: checked ? "#a2d2ff" : "transparent"
    Row {
        spacing: 5

        Rectangle {
            width: 20
            height: 20
            radius: 2
            border.color: "black"
            color: checkboxColor

            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: -82
                onClicked: checked = !checked
            }
        }

        Label {
            text: labelText
            font.pixelSize: 16

        }
    }
    onCheckedChanged: {
        checkboxColor = checked ? "#a2d2ff" : "transparent"
    }

}
