import QtQuick 2.15
import QtQuick.Controls 6.3
import "../objects"
Window {
    id: mapListWindow
    flags: Qt.Dialog
    width: 1002
    height: 500
    visible: true
    title: qsTr("Map List")

    property string var_chosenSource
    property string var_chosenMapID

    property int var_numOfCamsLength
    property var var_camIDNames: []
    property var dict_camPos: ({})


    GridView {
        id: gridView
        anchors.fill: parent
        anchors.rightMargin: 27
        anchors.leftMargin: 27
        rotation: 0
        anchors.bottomMargin: 33
        anchors.topMargin: 33
        cellWidth: width/2
        cellHeight: 270

        delegate: Item {
            Column {
                spacing: 10
                Rectangle {
                    id: rectangle
                    width: 450
                    height: 250
                    color: "#f5ebe0"
                    border.color: "#d6ccc2"
                    border.width: 2
                    radius: 10

                    Image {
                        id: mapImage
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: model.file
                        anchors.topMargin: 8
                        sourceSize.width: parent.width - 20
                        sourceSize.height: parent.height - 50
                        width: parent.width - 20
                        height: parent.height - 50
                        anchors.top: parent.top
                        fillMode: Image.PreserveAspectFit
                        property string id_map: mapID
                        cache: false

                        MouseArea {
                            id: mapArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.OpenHandCursor
                            onClicked: {
                                gridView.visible = false;
                                container.visible = true;
                                var_chosenSource = mapImage.source;
                                var_chosenMapID = mapImage.id_map
                                labelMap.text = "Map: "+mapImage.id_map
                                backend.getNumOfCams(var_chosenMapID);
                                backend.getCamPosition(var_chosenMapID);
                            }
                        }
                    }

                    Text {
                        anchors {
                            top: mapImage.top
                            left: rectangle.left
                            right: rectangle.right
                            margins: 10
                        }
                        text: name
                        font.bold: true
                        font.pixelSize: 16
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        anchors.rightMargin: 10
                        anchors.leftMargin: 10
                        anchors.topMargin: 210
                    }
                }
            }
        }
        model: ListModel {
            id: mapModel
        }


    }
    Rectangle {
        id: container
        x: 0
        y: 0
        width: 1000
        height: 500
        visible: false

        Label {
            id: labelMap
            height: 50
            text: qsTr("TEST")
            font.pointSize: 25
            y: 2
            font.bold: true
            font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: chosenMapImage
            anchors.fill: parent
            anchors.rightMargin: 23
            anchors.bottomMargin: 39
            anchors.leftMargin: 20
            anchors.topMargin: 43
            fillMode: Image.Stretch
            source: var_chosenSource
            visible: true

        }

        CustomBtn {
            id: backBtn
            width: 40
            height: 30
            text: "Back"
            anchors.left: chosenMapImage.left
            anchors.bottom: chosenMapImage.top
            anchors.leftMargin: 0
            anchors.bottomMargin: 5
            display: AbstractButton.IconOnly
            icon.source: "../assets/icon/black/angle-circle-left.png"
            onPressed: {
                mapListWindow.close();
                backend.load_mapListWindow();
                backend.getMapList();
            }
        }

        Repeater {
            id: repeater
            model: var_numOfCamsLength
            delegate:
                Column {
                x:20
                y:50
                    Button {
                        id: camIDBtn
                        width: 60
                        height: 30
                        text: var_camIDNames[index]
                        flat: true
                        display: AbstractButton.TextBesideIcon
                        icon.source: "../assets/icon/black/camera_symbol_1.png"
                        scale: 1.5
                        font.bold: true
                        MouseArea {
                            id: draggableArea
                            anchors.fill: parent
                            drag.target: camIDBtn
                            drag.axis: Drag.XAndYAxis
                            drag.minimumX: 0
                            drag.minimumY: 0
                            drag.maximumX: chosenMapImage.width - camIDBtn.width
                            drag.maximumY: chosenMapImage.height - camIDBtn.height

                            onPressed: {
                                camIDBtn.opacity = 0.7
                            }

                            onReleased: {
                                camIDBtn.opacity = 1
                                dict_camPos[camIDBtn.text]['camPos_x'] = camIDBtn.x
                                dict_camPos[camIDBtn.text]['camPos_y'] = camIDBtn.y
                            }
                        }
                }
            }

        }

        CustomBtn {
            id: confirmBtn
            x: 983
            y: 10
            width: 80
            height: 32
            text: "Confirm"
            anchors.right: chosenMapImage.right
            anchors.bottom: chosenMapImage.top
            anchors.bottomMargin: 5
            display: AbstractButton.TextBesideIcon
            icon.source: "../assets/icon/black/check.png"
            onPressed: {
                backend.transferMapID(mapListWindow.var_chosenMapID);
                mapListWindow.close()
                backend.transferCamPos(dict_camPos)
                backend.transferWH(container.width, container.height);
                backend.enableChooseCamBtn();
                backend.clearSettings();
            }
        }

    }
    Connections {
        target: backend
        function onSigNumOfCams(listOfCams){
            var_numOfCamsLength = listOfCams.length;
            var_camIDNames = listOfCams;
            for (var i=0; i < listOfCams.length; i++){
                dict_camPos[listOfCams[i]] = {'camPos_x': -1,
                                            'camPos_y': -1}
            }
        }

        function onSigMapList(listOfMap) {
            for (var i=0; i<listOfMap.length; i++) {
                mapModel.append({"file": "../assets/map/map_"+listOfMap[i]+".jpg",
                                 "name": listOfMap[i],
                                 "mapID": listOfMap[i]})
            }
        }

        function onSigCamPosition(backendDict_camPos){
            for (var i=0; i< repeater.count; i++) {
                var columnElement = repeater.itemAt(i);
                var cam = columnElement.children[0]
                var cam_name = cam.text

                cam.x = backendDict_camPos[cam_name]["camPos_x"]
                cam.y = backendDict_camPos[cam_name]["camPos_y"]

                mapListWindow.dict_camPos[cam_name]["camPos_x"] = cam.x
                mapListWindow.dict_camPos[cam_name]["camPos_y"] = cam.y
            }
        }
    }

}
