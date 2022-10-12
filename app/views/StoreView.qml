import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGamepad 1.15
// import "../controls"

Item {
    id: storeView
    width: 400
    height: 400
    anchors.fill: parent
    clip: true

    property int selectedItem: 0

    focus: true

    Gamepad {
        id: gamepad
        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1

        onButtonAChanged: (val) => {
            if(val) {
                backend.getStoreGame(gamesStoreList.currentIndex)
            }
        }

        onButtonBChanged: (val) => {
            if(val) {
                viewContainer.pop()
            }
        }

        onButtonDownChanged: (val) => {
            if(val) {
                gamesStoreList.currentIndex = gamesStoreList.currentIndex + (gamesStoreList.currentIndex < backend.storeModel.rowCount() - 1 ? 1 : 0)
            }
        }

        onButtonUpChanged: (val) => {
            if(val) {
                gamesStoreList.currentIndex = gamesStoreList.currentIndex - (gamesStoreList.currentIndex > 0 ? 1 : 0)
            }
        }
    }

    Keys.onPressed: (event)=> {
        if(event.key == Qt.Key_Escape) {
            viewContainer.pop()
        }

        if(event.key == Qt.Key_W) {
            gamesStoreList.currentIndex = gamesStoreList.currentIndex - (gamesStoreList.currentIndex > 0 ? 1 : 0)
        }

        if(event.key == Qt.Key_S) {
            gamesStoreList.currentIndex = gamesStoreList.currentIndex + (gamesStoreList.currentIndex < backend.storeModel.rowCount() - 1 ? 1 : 0)
        }

        if(event.key == Qt.Key_Space) {
            backend.getStoreGame(gamesStoreList.currentIndex)
        }
    }

    Rectangle {
        color: "#1a1a1a"
        anchors.fill: parent

        Column {
            id: column
            anchors.fill: parent

            Text {
                id: storeLabel
                color: "#ffffff"
                text: qsTr("STORE")
                font.family: mainFont.name
                anchors.top: parent.top
                font.pixelSize: 36
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 0
            }

            ListView {
                id: gamesStoreList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: storeLabel.bottom
                anchors.bottom: parent.bottom
                clip: true
                anchors.topMargin: 10

                model: backend.storeModel

                keyNavigationWraps: true
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: gamesListItem
                    x: 0
                    height: gamesStoreList.currentIndex == listId ? 80 : 60
                    // height: 60
                    width: parent.width

                    Row {
                        id: gameRow
                        anchors.fill: parent
                        Rectangle {
                            id: rectangle
                            color: "#1a1a1a"
                            border.color: "#ffffff"
                            radius: 10
                            border.width: gamesStoreList.currentIndex == listId ? 2 : 1
                            // border.width: 1
                            anchors.fill: parent
                            anchors.rightMargin: gamesStoreList.currentIndex == listId ? 5 : 40
                            anchors.leftMargin: gamesStoreList.currentIndex == listId ? 5 : 40
                            // anchors.rightMargin: 5
                            // anchors.leftMargin: 5
                            anchors.bottomMargin: 5
                            anchors.topMargin: 5

                            Connections {
                                target: backend
                                function onDownloadProgress(total, progress, actualId) {
                                    if(actualId == gameId) {
                                        statusLabel.text = "Installed"
                                    }
                                }
                            }

                            Text {
                                id: nameLabel
                                color: "#ffffff"
                                text: name
                                anchors.left: parent.left
                                anchors.top: parent.top
                                font.pointSize: 16
                                font.family: mainFont.name
                                anchors.topMargin: 5
                                anchors.leftMargin: 5
                                font.bold: true
                            }

                            Text {
                                id: versionLabel
                                color: "#777777"
                                text: version
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                font.pointSize: 9
                                font.family: mainFont.name
                                anchors.bottomMargin: 5
                                anchors.leftMargin: 5
                                font.bold: false
                                font.italic: true
                            }

                            Text {
                                id: statusLabel
                                color: "#777777"
                                text: gameState
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                font.pointSize: 10
                                font.family: mainFont.name
                                anchors.bottomMargin: 5
                                anchors.leftMargin: 5
                                anchors.rightMargin: 15
                                font.italic: true
                            }
                        }

                        spacing: 5
                    }
                }                
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:3}D{i:4}D{i:2}D{i:1}
}
##^##*/
