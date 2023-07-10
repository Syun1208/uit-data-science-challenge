import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true

    palette.button: "red"
    palette.buttonText: "yellow"
    palette.disabled.buttonText: "lavender"

    Column {
        Button {
            text: qsTr("Disabled button")
            enabled: false
        }

        Button {
            text: qsTr("Enabled button")
        }
    }
}
