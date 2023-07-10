import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: button
    property color colorDefault: "#ECECEC"
    property color colorMouseOver: "#F5F5F5"
    property color colorClicked: "#FFFFFF"
    property color colorText: "#646868"
    width: 100
    height: 50
    visible: true
    font.pixelSize: 25
    font.family: "Arial"

    property alias colorBtn : bkg.color

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
}
/*##^##
Designer {
    D{i:0;formeditorZoom:2}
}
##^##*/
