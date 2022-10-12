import QtQuick 2.15
import QtQuick.Controls 2.15
// import QtGamepad 1.15
import "../controls"

Item {
    id: mainMenuView
    width: 400
    height: 400
    anchors.fill: parent
    clip: true

    property int selectedMenuItem: 0

    function navUp() {
        selectedMenuItem = selectedMenuItem - (selectedMenuItem > 0 ? 1 : 0)
        backend.navigationChanged(selectedMenuItem)
    }

    function navDown() {
        selectedMenuItem = selectedMenuItem + (selectedMenuItem < menuColumn.children.length - 1 ? 1 : 0)
        backend.navigationChanged(selectedMenuItem)
    }

    function confirm() {
        if(selectedMenuItem == 0) {
            backend.getLocalGames()
            viewContainer.push(Qt.resolvedUrl("LibraryView.qml"))
        }

        if(selectedMenuItem == 1) {
            backend.getOnlineGames()
            viewContainer.push(Qt.resolvedUrl("StoreView.qml"))
        }
    }

    function inputEvent(key, val)
    {
        if(key == "HY" && val == -1) {
            navUp()
        }

        if(key == "HY" && val == 1) {
            navDown()
        }

        if(key == "S" && val == 1) {
            confirm()
        }
    }

    Keys.onPressed: (event)=> {
        if(event.key == Qt.Key_W) {
            navUp()
        }
        
        if(event.key == Qt.Key_S) {
            navDown()
        }

        if(event.key == Qt.Key_Space) {
            confirm()
        }
    }

    Rectangle {
        color: "#1a1a1a"
        anchors.fill: parent

        Column {
            id: menuColumn
            clip: true

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: 5

            objectName: "menuColumn"

            MenuItem {
                id: libraryMenu
                displayText: "Library"
                isActive: true

                objectName: "libraryMenu"
            }

            MenuItem {
                id: storeMenu
                displayText: "Store"
                isActive: false
            }

            // MenuItem {
            //     id: onlineMenu
            //     displayText: "Online"
            //     isActive: false
            // }

            // MenuItem {
            //     id: settingsMenu
            //     displayText: "Settings"
            //     isActive: false
            // }
        }
    }
}
