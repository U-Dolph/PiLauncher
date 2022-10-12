import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGamepad 1.15
import "../controls"
// import "views"

Window {
    id: window
    width: 800
    height: 480

    property int selectedMenuItem: 0
    property string currentMode: "MainMenu"

    // onActiveFocusItemChanged: console.log(activeFocusItem)

    FontLoader {
        id: mainFont
        source: Qt.resolvedUrl("../assets/Instruction.otf")
    }

    Connections {
        target: backend
    }

    Connections {
        target: GamepadManager
        onGamepadConnected: gamepad.deviceId = deviceId
    }
    
    visible: true
    color: "#1a1a1a"
    
    title: qsTr("PiLauncher")

    objectName: "mainWindow"

    Rectangle {
        id: borderRectangle
        color: "#1a1a1a"
        radius: 3
        border.color: "#ffffff"
        border.width: 3
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        clip: true

        StackView {
            id: viewContainer
            anchors.fill: parent
            clip: true

            focus: true

            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            initialItem: Qt.resolvedUrl("MainMenuView.qml")

            pushEnter: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to:1
                        duration: 100
                    }
                }
                pushExit: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 1
                        to:0
                        duration: 100
                    }
                }
                popEnter: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to:1
                        duration: 100
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 1
                        to:0
                        duration: 100
                    }
                }
        }
    }
}
