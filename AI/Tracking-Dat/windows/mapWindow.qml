import QtQuick 2.15
import QtQuick.Controls 6.3

Window {

    id: mapWindow
    width: 966
    height: 538
    visible: true
    flags: Qt.Dialog
    title: qsTr("Map Window")


    property var colors: {
        "path": "#133133",
        "startingPoint":  "#ffff99",
        "locationCircle": "#805af2"
    }


    property int var_camSymbolWidth: 60
    property int var_camSymbolHeight: 30

    property var dict_camPos
    property var tracked_person_time_stamp
    property var var_scaleFactorWidth
    property var var_scaleFactorHeight
    property var arrowCoordinates: []
    property var chosenPersonCoordinates: []

    function getDictionaryKeys(dictionary) {
            var keys = [];
            for (var key in dictionary) {
                var cam = key;
                var timestamp = dictionary[cam]["timestamp"];
                var value = [cam, timestamp];
                keys.push(value);
            }
            return keys;
        }

    Frame {
        id: frame
        anchors.fill: parent
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 92
        Rectangle {
            id: container
            x: 32
            y: 46
            width: 579
            height: 355


            Image {
                id: mapImage
                anchors.fill: parent
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.rightMargin: 0
                fillMode: Image.Stretch

                Canvas {
                        id: canvas
                        anchors.fill: mapImage
                        anchors.rightMargin: 0
                        anchors.bottomMargin:0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0

                        function drawPoint(ctx, x, y, radius, color) {
                            ctx.save()
                            ctx.beginPath();
                            ctx.arc(x, y, radius, 0, 2 * Math.PI);
                            ctx.fillStyle = color;
                            ctx.fill();
                        }


                        function drawCircle(ctx, x, y, radius, color) {
                            ctx.save()
                            ctx.beginPath();
                            ctx.arc(x, y, radius, 0, 2 * Math.PI);
                            ctx.strokeStyle = color;
                            ctx.lineWidth = 5;
                            ctx.stroke();
                        }

                        function arrow(ctx, x1,y1,x2,y2) {
                            ctx.save()

                            // Set arrow properties
                            ctx.lineWidth = 3
                            ctx.strokeStyle = colors["path"]

                            // Start drawing the arrow
                            ctx.beginPath()

                            // Move to the starting point of the arrow
                            ctx.moveTo(x1, y1)

                            // Draw the arrow shaft
                            ctx.lineTo(x2, y2)

                            // Calculate the angle of the arrow
                            var angle = Math.atan2(y2 - y1, x2 - x1)

                            // Set the length of the arrowhead
                            var arrowLength = ctx.lineWidth * 4


                            // Draw the arrowhead
                            ctx.moveTo(x2, y2)
                            ctx.lineTo(x2 - arrowLength * Math.cos(angle - Math.PI / 6), y2 - arrowLength * Math.sin(angle - Math.PI / 6))
                            ctx.moveTo(x2, y2)
                            ctx.lineTo(x2 - arrowLength * Math.cos(angle + Math.PI / 6), y2 - arrowLength * Math.sin(angle + Math.PI / 6))

                            // Calculate the coordinates for the middle arrow
                            var middleX = (x1 + x2) / 2
                            var middleY = (y1 + y2) / 2

                            // Draw the middle arrow
                            ctx.moveTo(middleX, middleY)
                            ctx.lineTo(middleX - arrowLength * Math.cos(angle - Math.PI / 6), middleY - arrowLength * Math.sin(angle - Math.PI / 6))
                            ctx.moveTo(middleX, middleY)
                            ctx.lineTo(middleX - arrowLength * Math.cos(angle + Math.PI / 6), middleY - arrowLength * Math.sin(angle + Math.PI / 6))


                            // Calculate the coordinates for the low middle arrow
                            var middleLowX = (middleX + x2) / 2
                            var middleLowY = (middleY + y2) / 2

                            // Draw the middle arrow
                            ctx.moveTo(middleLowX, middleLowY)
                            ctx.lineTo(middleLowX - arrowLength * Math.cos(angle - Math.PI / 6), middleLowY - arrowLength * Math.sin(angle - Math.PI / 6))
                            ctx.moveTo(middleLowX, middleLowY)
                            ctx.lineTo(middleLowX - arrowLength * Math.cos(angle + Math.PI / 6), middleLowY - arrowLength * Math.sin(angle + Math.PI / 6))


                            // Calculate the coordinates for the high middle arrow
                            var middleHighX = (x1 + middleX) / 2
                            var middleHighY = (y1 + middleY) / 2

                            // Draw the middle arrow
                            ctx.moveTo(middleHighX, middleHighY)
                            ctx.lineTo(middleHighX - arrowLength * Math.cos(angle - Math.PI / 6), middleHighY - arrowLength * Math.sin(angle - Math.PI / 6))
                            ctx.moveTo(middleHighX, middleHighY)
                            ctx.lineTo(middleHighX - arrowLength * Math.cos(angle + Math.PI / 6), middleHighY - arrowLength * Math.sin(angle + Math.PI / 6))

                            // Stroke the arrow
                            ctx.stroke()

                            ctx.restore()
                        }
                        onPaint: {
                            var ctx = getContext("2d")
                            // Clear the canvas
                            ctx.clearRect(0, 0, canvas.width, canvas.height)
                            var widthAddition = var_camSymbolWidth/2
                            var heightAddition = var_camSymbolHeight

                            // Draw first point as start point
//                            console.log(arrowCoordinates)
//                            console.log(arrowCoordinates[0].x)
//                            console.log(arrowCoordinates[0].y)
                            drawPoint(ctx,arrowCoordinates[0].x+widthAddition,arrowCoordinates[0].y+heightAddition, 15, colors["startingPoint"]);


                            // Draw the circle on location of chosen person
                            drawCircle(ctx,chosenPersonCoordinates[0],chosenPersonCoordinates[1],15,colors["locationCircle"]);
                            // Draw each arrow from the array
                            for (var i = 0; i < arrowCoordinates.length; i++) {
                                if (i === arrowCoordinates.length - 1) {
                                    break
                                }
                                var startPoint = arrowCoordinates[i]
                                var endPoint = arrowCoordinates[i+1]

                                //Use to center the point in cam

                                arrow(ctx, startPoint.x + widthAddition,
                                          startPoint.y + heightAddition,
                                          endPoint.x + widthAddition,
                                          endPoint.y + heightAddition)
                            }
                        }
                }
                Repeater {
                    id: repeater
                    model: getDictionaryKeys(mapWindow.dict_camPos)
                    delegate:
                        Column {
                            Rectangle {
                                color: "#eeeee4"
                                height: 15
                                width: locationText.text.length * 6.5
                                x: camIDBtn.x - 55
                                y: camIDBtn.y - 20
                            }
                            Text {
                                id: locationText
                                height: 30
                                width: 50
                                text: "[" + modelData[0] + "] " + modelData[1]
                                horizontalAlignment: Text.AlignHCenter
                                font.bold: true
                                font.pointSize: 10
                                font.family: "Arial"
                                x: camIDBtn.x
                                y: camIDBtn.y - 20
                            }
                            Button {
                                id: camIDBtn
                                width: var_camSymbolWidth
                                height: var_camSymbolHeight
                                text: modelData[0]
                                scale: 1.5
                                flat: true
                                display: AbstractButton.IconOnly
                                icon.source: "../assets/icon/black/marker_big.png"
                                x: mapWindow.dict_camPos[modelData[0]]["camPos_x"]*var_scaleFactorWidth
                                y: mapWindow.dict_camPos[modelData[0]]["camPos_y"]*var_scaleFactorHeight
                            }
                        }
                }
            }
        }

        GridView {

            id: gridView
            anchors.fill: parent
            anchors.rightMargin: 24
            anchors.bottomMargin: 35
            anchors.leftMargin: 660
            anchors.topMargin: 30
            clip: true
            cellHeight: 300
            cellWidth: 120
            focus: true
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
                                camText.text = personImage.id_cam
                                personText.text = personImage.id_person
                                timeText.text = personImage.time_stamp
                                chosenPersonCoordinates[0] = dict_camPos[personImage.id_cam]["camPos_x"]*var_scaleFactorWidth + var_camSymbolWidth/2
                                chosenPersonCoordinates[1] = dict_camPos[personImage.id_cam]["camPos_y"]*var_scaleFactorHeight + var_camSymbolHeight
                                canvas.requestPaint();
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
                Component.onCompleted: {
                    arrowCoordinates.splice(0)

                    for (var i=0; i < gridView.count ; i++)
                    {
                        console.log("dict",dict_camPos)
                        var frame = gridView.model.get(i).frameID
                        var cam = gridView.model.get(i).cameraID
                        var data = mapWindow.dict_camPos[cam]
                        arrowCoordinates.push({"frame":frame,"x": data.camPos_x*var_scaleFactorWidth, "y": data.camPos_y*var_scaleFactorHeight})

                    }
                    arrowCoordinates.sort(function(a, b) {
                        return a.frame - b.frame
                    })
                    canvas.requestPaint()
                }
            }
        }

    }


    Connections {
        target: backend

        function onSigTransferModel(model) {
            gridView.model = model;
        }

        function onSigTransferMapID(mapPath) {
            mapImage.source = mapPath;
        }

        function onSigTransferCamPos(dict_camPos_sig) {
            for (var i=0; i < gridView.count ; i++)
            {
                var time_stamp = gridView.model.get(i).timeStamp
                var cam = gridView.model.get(i).cameraID
                dict_camPos_sig[cam]["timestamp"] = time_stamp
            }
            mapWindow.dict_camPos = dict_camPos_sig
        }

        function onSigTrackedPersonTimeStamp(tracked_person_time_stamp) {
            mapWindow.tracked_person_time_stamp = tracked_person_time_stamp;
        }

        function onSigTransferWH(sig_width, sig_height) {
            // 0.15 is the epsilon to adjust scale factor of width. This is the number from experiment
            mapWindow.var_scaleFactorWidth = mapImage.width/sig_width
            // 0.15 is the epsilon to adjust scale factor of height. This is the number from experiment
            mapWindow.var_scaleFactorHeight = mapImage.height/sig_height + 0.1
        }

    }

    GroupBox {
        id: groupBox
        x: 10
        y: 15
        width: 946
        height: 59
        title: qsTr("Information")

        Label {
            id: camLabel
            width: 61
            height: 16
            text: qsTr("Camera ID: ")
            font.bold: true
            font.family: "Arial"
            anchors.top: parent.top
            anchors.horizontalCenterOffset: -171
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 3
        }

        Label {
            id: personLabel
            y: camLabel.y
            text: qsTr("Person ID: ")
            font.bold: true
            font.family: "Arial"
            anchors.left: camText.right
            anchors.leftMargin: 50
        }

        Label {
            id: timeLabel
            y: camLabel.y
            text: qsTr("Time Stamp: ")
            anchors.left: personText.right
            font.bold: true
            font.family: "Arial"
            anchors.leftMargin: 50
        }

        Text {
            id: camText
            y: 1
            text: qsTr("None")
            anchors.left: camLabel.right
            font.pixelSize: 15
            font.bold: true
            font.family: "Arial"
            anchors.leftMargin: 6
        }

        Text {
            id: personText
            y: 1
            text: qsTr("None")
            anchors.left: personLabel.right
            font.pixelSize: 15
            font.bold: true
            font.family: "Arial"
            anchors.leftMargin: 6
        }



        Text {
            id: timeText
            y: 1
            text: qsTr("None")
            anchors.left: timeLabel.right
            font.pixelSize: 15
            font.bold: true
            font.family: "Arial"
            anchors.leftMargin: 6
        }
    }
}
