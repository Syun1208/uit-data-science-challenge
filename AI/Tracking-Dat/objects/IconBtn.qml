import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button
    property int iconWidth: 95
    property int iconHeight: 95
    property color colorDefault: "#ECECEC"
    property color colorMouseOver: "#F5F5F5"
    property color colorClicked: "#FFFFFF"
    property color colorText: "#646868"
    width: 253
    height: 238
    visible: true

    property alias colorBtn : bkg.color
    property alias btnIconSource: iconBtn.source
    property alias btnText: textBtn.text

    QtObject{
        id: internal
        property var dynamicColor: if(button.down){
                                       button.down ? colorClicked : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }
    background: Rectangle{
        id: bkg
        color: internal.dynamicColor
        border.color: "#D5D7D7"
        border.width: 2.5
        radius: 6
    }
        Image {
            id: iconBtn
            source: ""
            anchors.verticalCenterOffset: -15
            anchors.horizontalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.width: iconWidth
            sourceSize.height: iconHeight
            width: iconWidth
            height: iconHeight
            fillMode: Image.PreserveAspectFit
            visible: true
            antialiasing: true

        }
        Text {
                id: textBtn
                text: "Windows Lock"
                font.family: "Arial"
                color: button.colorText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.styleName: "Bold"
                anchors.verticalCenterOffset: 52
                anchors.horizontalCenterOffset: -1
                font.bold: true
                font.pixelSize: 20
            }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
