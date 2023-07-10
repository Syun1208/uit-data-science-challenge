import QtQuick 2.15
import QtQuick.Controls 2.15


Window {
    width: 400
    height: 400
    visible: true
    Button {
        x: 10
        y: 10
        width: 50
        height: 30
        text: qsTr("Get")
        onPressed: {
            imageProvider.getImage();
        }
    }

    Image {
        id: feedImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        cache: false
        source: "image://MyImageProvider/img"
        property bool counter: false

        function reloadImage() {
            counter = !counter
            source = "image://MyImageProvider/img?id=" +counter
        }
    }

    Connections {
        target: imageProvider

        function onImageChanged(image) {
            feedImage.reloadImage()
        }
    }
}

