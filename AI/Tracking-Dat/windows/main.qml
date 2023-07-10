import QtQuick
import QtQuick.Window
import QtQuick.Controls 6.3
import "../objects"
Window {
    id: window
    flags: Qt.Dialog
    width: 1100
    height: 700
    visible: true
    title: qsTr("Cross Camera Tracking")

    property string var_assets_folder: "../assets/"
    Frame {
        id: frame
        anchors.fill: parent
        anchors.rightMargin: 13
        anchors.leftMargin: 13
        anchors.bottomMargin: 13
        anchors.topMargin: 82

    }
    GridView {
        id: gridView
        anchors.fill: frame
        anchors.rightMargin: 6
        anchors.bottomMargin: 20
        anchors.leftMargin: 34
        anchors.topMargin: 20
        clip: true
        cellHeight: 300
        cellWidth: width/8
        focus: true
        highlight: Rectangle {
            color: "red"
            z: 1
        }

        delegate: Item {
            x: 5
            height: 50
            Column {
                Image {
                    id: personImage
                    property string id_person: personID
                    property string id_frame: frameID
                    property string id_cam: cameraID
                    property string time_stamp: timeStamp
                    source: model.file
                    width: 100
                    height: 250
                    cache: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        id: imageArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.OpenHandCursor
                        onClicked: {
                            backend.load_specificPersonWindow()
                            backend.transferImageCamPersonFrameIDTimeStamp(personImage.source,
                                                                           personImage.id_cam,
                                                                           personImage.id_person,
                                                                           personImage.id_frame,
                                                                           personImage.time_stamp)
                        }
                    }
                }

                Text {
                    id: camID
                    x: 5
                    text: name
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }
                spacing: 10
            }
        }
        model: ListModel {
            id: personImageModel
        }



    }


    Row{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 9
        anchors.leftMargin: 13
        spacing: 5
        CustomBtn {
            id: camPositionSetterBtn
            width: 31
            height: 28
            text: qsTr("Pos")
            display: AbstractButton.IconOnly
            icon.source: var_assets_folder+"icon/black/app_2.png"
            onPressed: {
                backend.load_mapListWindow()
                backend.getMapList();
            }
        }

        CustomBtn {
            id: cameraBtn
            width: 31
            height: 28
            text: qsTr("Cam")
            display: AbstractButton.IconOnly
            icon.source: var_assets_folder+"icon/black/cam.png"
            enabled: false
            onPressed: {
                backend.load_camListWindow();
                backend.getCamList();
            }
        }
    }
    Row {
        id: row
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 13
        anchors.topMargin: 43
        spacing: 20
        Text {
            id: text1
            text: qsTr("Advance")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
        }

        CustomBtn {
            id: person_prop
            width: 31
            height: 28
            text: qsTr("Button")
            display: AbstractButton.IconOnly
            icon.source: var_assets_folder+"icon/black/user-add.png"
            onPressed: {
                backend.load_preconditionWindow()
            }
        }


    }

    CustomBtn {
        id: searchBtn
        x: 907
        width: 80
        height: 28
        text: qsTr("Search")
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/search.png"
        anchors.right: parent.right
        anchors.top: parent.top
        highlighted: false
        flat: false
        enabled: false
        anchors.topMargin: 43
        anchors.rightMargin: 13
        onPressed: {
            personImageModel.clear()
            backend.search()
            mapBtn.enabled = false

        }

    }

    CustomBtn {
        id: mapBtn
        x: 907
        y: 6
        width: 80
        height: 28
        text: qsTr("Map")
        display: AbstractButton.IconOnly
        icon.source: var_assets_folder+"icon/black/map.png"
        anchors.right: parent.right
        anchors.top: parent.top
        layer.enabled: true
        anchors.topMargin: 9
        anchors.rightMargin: 13
        enabled: false
        onPressed:  {
            backend.load_mapWindow();
            backend.transferModel(personImageModel);
            backend.transferMap();
        }
    }


    CustomBtn {
        id: clear
        x: 801
        y: 43
        width: 100
        height: 28
        text: qsTr("Clear all")
        anchors.right: searchBtn.left
        anchors.rightMargin: 8
        display: AbstractButton.TextBesideIcon
        icon.source: var_assets_folder+"icon/black/trash.png"
        onPressed: {
            personImageModel.clear()
            chosenColorModel.clear()
            backend.clearColors("all")
            modeLabel.text = "Default"
            noticeText.text = "Idle"
            mapBtn.enabled = false
        }
    }

    Row {
        id: row1
        x: 125
        y: 6
        width: 755
        height: 70
        spacing: 10
        GroupBox {
            id: preconditionBox
            width: chosenColorView.cellWidth*(chosenColorView.count + 2)
            height: 70
            title: qsTr("Precondition")
            visible: true
            anchors.top: informationBox.top
            anchors.topMargin: 0
            anchors.left: informationBox.right
            anchors.leftMargin: 20
            GridView {
                id: chosenColorView
                anchors.fill: parent
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                cellWidth: 35
                cellHeight: 30
                delegate: Item {
                    x: 5
                    height: 50
                    Column {
                        RoundButton {
                            id: chosenColor
                            property string color_name: colorName
                            palette {
                                button: colorName
                            }
                            onPressed: {
                                if (chosenColorView.count === 1){
                                    modeLabel.text = "Default"
                                }
                                for (var i=0; i<chosenColorView.count; i++){
                                    if (chosenColorView.model.get(i).colorName === color_name) {
                                        chosenColorModel.remove(i)
                                        backend.clearColors(color_name)
                                    }
                                }

                            }
                        }
                        spacing: 5
                    }
                }
                model: ListModel {
                    id: chosenColorModel
                }
            }
            Text {
                id: modeLabel
                x: 62
                y: 6
                width: 43
                height: 16
                text: "Default"
                anchors.right: parent.right
                anchors.rightMargin: 0
            }
        }
        GroupBox {
            id: informationBox
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            width: currCam.width
            title: qsTr("Information")

            Label {
                id: labelMap
                width: 40
                height: 16
                text: qsTr("Map:")
                anchors.left: parent.left
                anchors.top: parent.top
                font.pointSize: 10
                font.family: "Arial"
                anchors.topMargin: -3
                anchors.leftMargin: 3

            }
            Label {
                id: labelCam
                width: 40
                height: 16
                text: qsTr("Cam:")
                anchors.left: labelMap.left
                anchors.top: labelMap.bottom
                font.pointSize: 10
                font.family: "Arial"
                anchors.topMargin: 3
                anchors.leftMargin: 0
            }

            Label {
                id: currMap
                x: 6
                width: 40
                height: 16
                text: qsTr("None")
                anchors.left: labelMap.right
                anchors.top: labelMap.top
                anchors.topMargin: 0
                anchors.leftMargin: 3
                font.pointSize: 10
                font.family: "Arial"
            }

            Text {
                id: currCam
                height: 16
                width: implicitWidth
                text: "None"
                anchors.left: labelCam.right
                anchors.top: labelCam.top
                anchors.leftMargin: 3
                font.pointSize: 10
                anchors.topMargin: 0
                font.family: "Arial"

                onWidthChanged: {
                    if (text.length < 10){
                        width = 100
                    }
                    else {
                        width = 8*text.length + 20
                    }
                }
            }
        }

        GroupBox {
            id: noticeBox
            y: 28
            width: noticeText.width
            height: 70
            anchors.top: preconditionBox.top
            anchors.topMargin: 0
            anchors.left: preconditionBox.right
            anchors.leftMargin: 10
            title: qsTr("Notice")

            Text {
                id: noticeText
                width: implicitWidth
                height: 16
                text: "Idle"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 7
                font.pointSize: 10
                font.family: "Arial"

                onTextChanged: {
                    noticeText.text = text
                }
                onWidthChanged: {
                    if (text.length < 10){
                        width = 100
                    }
                    else {
                        width = 7*text.length
                    }
                }
            }
        }
    }
    Connections {
        target: backend

        function onSigAddImageByColor(listOfImages, listOfCams, listOfPersonIDs,listOfFrameIDs, listOfTimeStamps, prompt) {
            personImageModel.clear();
            noticeText.text = "Idle";
            noticeText.text = prompt;
            if (listOfImages.length === 0) {
                console.log("Not found person")
            }
            else {
                for (var i=0; i< listOfImages.length; i++) {
                    personImageModel.append({file: "../"+listOfImages[i],
                                             cameraID: listOfCams[i],
                                             name: "Camera: "+listOfCams[i],
                                             personID: listOfPersonIDs[i],
                                             frameID: listOfFrameIDs[i],
                                             timeStamp: listOfTimeStamps[i]})
                }
            }
        }

        function onSigAddImageDefault(listOfImages, listOfCams, listOfPersonIDs,listOfFrameIDs, listOfTimeStamps, prompt) {
            personImageModel.clear();
            noticeText.text = "Idle";
            noticeText.text = prompt;
            if (listOfImages.length === 0) {
                console.log("Not found person")
            }
            else {
                for (var i=0; i< listOfImages.length; i++) {
                    personImageModel.append({file: "../"+listOfImages[i],
                                             cameraID: listOfCams[i],
                                             name: "Camera: "+listOfCams[i],
                                             personID: listOfPersonIDs[i],
                                             frameID: listOfFrameIDs[i],
                                             timeStamp: listOfTimeStamps[i]})

                }
            }
        }

        function onSigTrackedPersonImage(listOfImages, listOfCams, listOfPersonIDs,listOfFrameIDs, listOfTimeStamps) {
            personImageModel.clear();
            noticeText.text = "Idle";
            for (var i=0; i< listOfImages.length; i++) {
                personImageModel.append({file: "../"+listOfImages[i],
                                         cameraID: listOfCams[i],
                                         name: "Camera: "+listOfCams[i],
                                         personID: listOfPersonIDs[i],
                                         frameID: listOfFrameIDs[i],
                                         timeStamp: listOfTimeStamps[i]})
            }
        }

        function onSigEnableMapBtn() {
            mapBtn.enabled = true
        }

        function onSigEnableChooseCamBtn() {
            cameraBtn.enabled = true
        }

        function onSigEnableSearchBtn(){
            searchBtn.enabled = true
        }

        function onSigClearSettings(){
            personImageModel.clear();
            currCam.text = "None";
            searchBtn.enabled = false
            mapBtn.enabled = false
            noticeText.text = "Idle"
        }

        function onSigUpdateMapLabel(mapID){
            currMap.text = mapID
        }


        function onSigUpdateCamLabel(listOfCam) {
            var camList = ""
            for (var i=0; i<listOfCam.length; i++) {
                camList += "["+listOfCam[i]+"] "
            }
            currCam.text = camList
        }

        function onSigAddColor(color) {
            modeLabel.text = "person"
            chosenColorModel.append({colorName: color})
        }

    }

}
