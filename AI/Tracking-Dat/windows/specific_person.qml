import QtQuick 2.15
import QtQuick.Controls 6.3
import "../objects"

Window  {
    id: specificPersonWindow
    visible: true
    flags: Qt.Dialog
    title: var_title
    width: 424
    height: 516

    property string var_title
    property string var_personID

    Frame {
        id: frame
        anchors.fill: parent
        anchors.bottomMargin: 67
        anchors.leftMargin: 50
        anchors.topMargin: 42
        anchors.rightMargin: 50
        Image {
            id: personImage
            width: 157
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            cache: false
            source: "../temp/0.jpg"
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit

        }
    }


    CustomBtn {
        id: button
        width: 81
        height: 42
        text: qsTr("Track")
        anchors.top: frame.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 12
        display: AbstractButton.TextBesideIcon
        icon.source: "../assets/icon/black/marker.png"
        onPressed: {
            backend.track_person(var_personID)
            backend.enableMapBtn()
            specificPersonWindow.close()
        }
    }

    Connections {
        target: backend
        function onSigTransferImageCamPersonFrameIDTimeStamp(imagePath, camID, personID, frameID, time_stamp) {
            var_personID = personID
            personImage.source = imagePath;
            specificPersonWindow.title = "Cam ID: " + camID + " | " + "Frame ID: " + frameID + " | " + "Person ID: " + personID
        }

    }




}
