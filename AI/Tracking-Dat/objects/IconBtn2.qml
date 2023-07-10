import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button
//    property url btnIconSource: "../../images/icons/windowslock.png"
    property int iconWidth: 60
    property int iconHeight: 60

    property color colorDefault: "#ECECEC"
    property color colorMouseOver: "#F5F5F5"
    property color colorClicked: "#FFFFFF"
    property color colorText: "#646868"
    width: 253
    height: 121
    visible: true
    font.pixelSize: 8

    property alias colorBtn : bkg.color
    property alias btnIconSource: iconBtn.source
    property alias btnText: textBtn.text
//    property alias btnColoroverlay: colorOver.color

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
//            source: btnIconSource
            source: "../assets/icon/color/find.png"
            anchors.verticalCenterOffset: -1
            anchors.horizontalCenterOffset: -45
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
                text: "Auto"
                font.family: "Arial"
                color: button.colorText
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.styleName: "Bold"
                anchors.verticalCenterOffset: 3
                anchors.horizontalCenterOffset: 28
                font.bold: true
            }

}


/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/
