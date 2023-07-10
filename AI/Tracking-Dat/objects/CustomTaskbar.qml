import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: taskbar
    width: parent.width
    height: 30
    anchors.bottom: parent.bottom

    Rectangle {
        id: closeButton
        width: parent.width
        height: 30
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: closeButton.color = "red" // Change to desired hover color
            onExited: closeButton.color = "transparent"

            onClicked: {
                // Close button action
                Qt.quit(); // Replace with your own logic
            }
        }
        Rectangle {
            width: 30
            height: closeButon.height
            color: "#F2EAD3"
            Image {
                id: image
                source: "../assets/icon/black/cam.png" // Replace with the path to your close icon
                width: 12
                height: 12
                horizontalAlignment: Image.AlignLeft
            }
        }

    }
}
