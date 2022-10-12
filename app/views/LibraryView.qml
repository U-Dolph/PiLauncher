import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGamepad 1.15
import "../controls"

Item {
    id: libraryView
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
                backend.launchGame(gamesLibraryList.currentIndex)
            }
        }

        onButtonBChanged: (val) => {
            if(val) {
                viewContainer.pop()
            }
        }

        onButtonDownChanged: (val) => {
            if(val) {
                gamesLibraryList.currentIndex = gamesLibraryList.currentIndex + (gamesLibraryList.currentIndex < backend.libraryModel.rowCount() - 1 ? 1 : 0)
            }
        }

        onButtonUpChanged: (val) => {
            if(val) {
                gamesLibraryList.currentIndex = gamesLibraryList.currentIndex - (gamesLibraryList.currentIndex > 0 ? 1 : 0)
            }
        }
    }

    Keys.onPressed: (event)=> {
        if(event.key == Qt.Key_Escape) {
            viewContainer.pop()
        }

        if(event.key == Qt.Key_W) {
            gamesLibraryList.currentIndex = gamesLibraryList.currentIndex - (gamesLibraryList.currentIndex > 0 ? 1 : 0)
        }

        if(event.key == Qt.Key_S) {
            gamesLibraryList.currentIndex = gamesLibraryList.currentIndex + (gamesLibraryList.currentIndex < backend.libraryModel.rowCount() - 1 ? 1 : 0)
        }

        if(event.key == Qt.Key_Space) {
            // print(backend.storeModel.itemFromIndex(gamesStoreList.currentIndex))
            backend.launchGame(gamesLibraryList.currentIndex)
        }
    }

    Rectangle {
        color: "#1a1a1a"
        anchors.fill: parent

        Column {
            id: column
            anchors.fill: parent

            Text {
                id: libraryLabel
                color: "#ffffff"
                text: qsTr("LIBRARY")
                font.family: mainFont.name
                anchors.top: parent.top
                font.pixelSize: 36
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 0
            }

            ListView {
                id: gamesLibraryList
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: libraryLabel.bottom
                anchors.bottom: parent.bottom
                clip: true
                anchors.topMargin: 10

                model: backend.libraryModel

                keyNavigationWraps: true
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: gamesListItem
                    x: 0
                    height: gamesLibraryList.currentIndex == listId ? 80 : 60
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
                            border.width: gamesLibraryList.currentIndex == listId ? 2 : 1
                            // border.width: 1
                            anchors.fill: parent
                            anchors.rightMargin: gamesLibraryList.currentIndex == listId ? 5 : 40
                            anchors.leftMargin: gamesLibraryList.currentIndex == listId ? 5 : 40
                            // anchors.rightMargin: 5
                            // anchors.leftMargin: 5
                            anchors.bottomMargin: 5
                            anchors.topMargin: 5

                            Text {
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
                                color: "#ee3333"
                                text: needsUpdate ? "update available!" : ""
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                font.pointSize: 10
                                font.family: mainFont.name
                                anchors.bottomMargin: 5
                                anchors.leftMargin: 5
                                anchors.rightMargin: 15
                                font.bold: false
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
