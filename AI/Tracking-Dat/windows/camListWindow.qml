import QtQuick 2.15
import QtQuick.Controls 6.3
import "../objects"
Window {
    id: camListWindow
    flags: Qt.Dialog
    width: 235
    height: 350
    title: qsTr("Camera List")
    visible: true

    CustomCheckBox {
        id: selectAll
        y: 49
        width: 99
        height: 25
        anchors.left: frame.left
        anchors.leftMargin: 0
        labelText: "Select All"
        onCheckedChanged: {
            for (var i = 0; i < listView.count; i++) {
                var item = listView.model.get(i)
                item.isCheck = selectAll.checked
            }
        }
    }

    Frame {
        id: frame
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 49
        anchors.topMargin: 80
        ListView {
            id: listView
            anchors.fill: parent
            anchors.rightMargin: 17
            anchors.bottomMargin: 10
            anchors.leftMargin: 33
            anchors.topMargin: 24
            clip : true

            ScrollBar.vertical: ScrollBar {
                opacity: 0.5
                wheelEnabled: true
                policy: ScrollBar.AsNeeded
            }

            model: ListModel {
                id: camListModel
            }
            delegate: Item {
                x: 5
                width: 80
                height: 40
                Row {
                    id: row1
                    spacing: 5
                    CustomCheckBox {
                        id: camId
                        labelText: camName
                        checked: isCheck
//                        Binding {
//                            target: model
//                            property: "checked"
//                            value: checked
//                        }

                        onCheckedChanged: {
                            model.isCheck = camId.checked;
                        }
                    }
                }
            }
        }
    }



    CustomBtn {
        id: okBtn
        text: qsTr("Confirm")
        display: AbstractButton.TextBesideIcon
        icon.source: "../assets/icon/black/check.png"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: frame.bottom
        anchors.bottom: parent.bottom
        anchors.rightMargin: 70
        anchors.bottomMargin: 12
        anchors.leftMargin: 82
        anchors.topMargin: 11
        onPressed: {

            var checkedIds = [];
            for (var i = 0; i < listView.model.count; i++) {
                var item = listView.model.get(i);
                if (item.isCheck ) {
                    checkedIds.push(item.camId);
                }
            }
            backend.getCamId(checkedIds)
            backend.enableSearchBtn()
            camListWindow.close()
        }
    }

    Label {
        id: label
        y: 11
        text: qsTr("CAM LIST")
        anchors.horizontalCenterOffset: -1
        font.pointSize: 22
        font.family: "Arial"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections {
        target: backend
        function onSigGetCamList(listOfCam) {
            for (var i=0; i<listOfCam.length; i++) {
                camListModel.append({"isCheck":false,
                                       "camId":listOfCam[i],
                                       "camName":"Camera " + listOfCam[i]})
            }
        }
    }




}
