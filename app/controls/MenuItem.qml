import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: customMenuItem

    property bool isActive: true

    property string primaryColor: "#1a1a1a"
    property string secondaryColor: "#ffffff"

    property int activeFontSize: 22
    property int inactiveFontSize: 18

    property string displayText: "TEXT"

    QtObject {
        id: internal

        property var dynamicFontSize: customMenuItem.isActive ? customMenuItem.activeFontSize : customMenuItem.inactiveFontSize
        property var dynamicFontColor: customMenuItem.isActive ? customMenuItem.primaryColor : customMenuItem.secondaryColor
        property var dynamicBackgroundColor: customMenuItem.isActive ? customMenuItem.secondaryColor : customMenuItem.primaryColor
    }

    implicitWidth: 200
    implicitHeight: 50

    color: internal.dynamicBackgroundColor

    Text {
        id: textField
        font.pointSize: internal.dynamicFontSize
        font.bold: customMenuItem.isActive
        color: internal.dynamicFontColor
        text: customMenuItem.displayText
        anchors.fill: parent
        font.letterSpacing: 7
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: mainFont.name
    }
}

/*##^##
Designer {
    D{i:0;height:50;width:200}D{i:1}D{i:2}
}
##^##*/
