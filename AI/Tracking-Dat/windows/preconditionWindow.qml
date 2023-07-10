import QtQuick 2.15
import QtQuick.Controls 6.3

import "../objects"
Window {
    id: preconditionWindow
    flags: Qt.Window
    width: 330
    height: 600
    title: qsTr("Precondition")
    visible: true
    property string var_assets_folder: "../assets/"

    property var coloCatergory: ["white", "gray", "black", "red", "green", "blue", "yellow", "purple", "pink", "brown"]
    Row {
        id: colorRow
        width: 300
        height: 46
        anchors.left: parent.left
        anchors.top: label.bottom
        anchors.leftMargin: 22
        anchors.topMargin: 12
        spacing: 3
        Repeater {
            id: repeater
            model: coloCatergory
            RoundButton {
                id: roundButton
                width: 25
                height: 25
                text: ""
                display: AbstractButton.TextOnly
                palette {
                    button: modelData
                }
                onPressed: {
                    backend.addColor(modelData);
                }
            }
        }
    }

    CustomBtn {
        y: 712
        width: 94
        height: 34
        display: AbstractButton.TextBesideIcon
        icon.source: "../assets/icon/black/check.png"
        text: "Confirm"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        onPressed: {
            preconditionWindow.close()

        }

    }
    Connections {
        target: backend
    }

    Label {
        id: label
        x: 25
        y: 30
        text: qsTr("Color")
        font.pointSize: 12
        font.styleName: "Bold"
        font.family: "Arial"
    }

    Label {
        id: genderLabel
        x: 25
        text: qsTr("Gender")
        anchors.top: colorRow.bottom
        anchors.topMargin: 17
        font.styleName: "Bold"
        font.pointSize: 12
        font.family: "Arial"
    }



    Row {
        id: genderRow
        x: 30
        y: 156
        width: 285
        height: 51

        CustomRadio {
            id: radioButton
            width: 88
            height: 28
            text: qsTr("Female")
        }

        CustomRadio {
            id: radioButton1
            width: 88
            height: 28
            text: qsTr("Both")
            checked: true
        }

        CustomRadio {
            id: radioButton2
            width: 88
            height: 28
            text: qsTr("Male")
        }
    }

    Label {
        id: ageLabel
        x: 25
        text: qsTr("Age")
        anchors.top: genderRow.bottom
        font.styleName: "Bold"
        font.pointSize: 12
        anchors.topMargin: 14
        font.family: "Arial"
    }


    ComboBox {
        id: comboBox
        x: 22
        width: 273
        height: 36
        anchors.top: ageLabel.bottom
        font.pointSize: 13
        font.family: "Arial"
        displayText: "  Please Select"
        anchors.topMargin: 15
    }

    Label {
        id: emotionLabel
        x: 25
        text: qsTr("Emotion")
        anchors.top: comboBox.bottom
        font.styleName: "Bold"
        font.pointSize: 12
        anchors.topMargin: 38
        font.family: "Arial"
    }

    ComboBox {
        id: comboBox1
        x: 22
        width: 273
        height: 36
        anchors.top: emotionLabel.bottom
        font.pointSize: 13
        displayText: "  Please Select"
        anchors.topMargin: 18
        font.family: "Arial"
    }

    Label {
        id: maskLabel
        x: 22
        text: qsTr("Mask & PBE")
        anchors.top: comboBox1.bottom
        font.styleName: "Bold"
        font.pointSize: 12
        anchors.topMargin: 37
        font.family: "Arial"
    }

    CustomBtn {
        id: maskBtn
        x: 23
        y: 469
        width: 44
        height: 42
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/mask.png"
    }

    CustomBtn {
        id: unmaskBtn
        x: 99
        y: 469
        width: 44
        height: 42
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/unmask.png"
    }

    CustomBtn {
        id: pbeBtn
        x: 178
        y: 469
        width: 44
        height: 42
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/vest.png"
    }

    CustomBtn {
        id: unpbeBtn
        x: 251
        y: 469
        width: 44
        height: 42
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/unvest.png"
    }

}
