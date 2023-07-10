import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button
    property int iconWidth: 45
    property int iconHeight: 45
    property color colorDefault: "#ECECEC"
    property color colorMouseOver: "#F5F5F5"
    property color colorClicked: "#FFFFFF"
    property color colorDisabled: "#CCCCCC"
    property alias colorBtn : bkg.color
    property alias colorborderBtn : bkg.border.color
    property alias btnIconSource: iconBtn.source
    property alias btnIconWidth: iconBtn.width
    property alias btnIconHeigh: iconBtn.height

    width: 100
    height: 50
    visible: true
    font.bold: true
    font.family: "Arial"
    palette.buttonText: "#646868"
    Text {
            id: textBtn
            width: 61
            height: 23
            text: ""
            font.family: "Arial"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 1
            font.bold: true
            font.pixelSize: 20
        }
    QtObject{
        id: internal
        property var dynamicColor: if(button.down){
                                       button.down ? colorClicked : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }

    onEnabledChanged: {
        if (enabled) {
            // Button is enabled
            bkg.color = colorDefault
            bkg.border.color = "#d5bdaf"
            // Add any other behavior or style changes for enabled state
        } else {
            // Button is disabled
            bkg.color = colorDisabled
            bkg.border.color = "#CCCCCC"
            // Add any other behavior or style changes for disabled state
        }
    }

    background: Rectangle{
        id: bkg
        color: internal.dynamicColor
        border.color: "#d5bdaf"
        border.width: 2.5
        radius: 6

        Image {
            id: iconBtn
            source: ""
            sourceSize.height: 100
            sourceSize.width: 100
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: iconWidth
            height: iconHeight
            fillMode: Image.PreserveAspectFit
            visible: true
            antialiasing: true

        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/
