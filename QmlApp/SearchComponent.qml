import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSearch
    width: parent.width
    RowLayout {
        Button {
            text: "Back"
            onClicked: isShowSearch = false
        }
    }
    Row{
        Rectangle {
            color: "white"
            width: scrollViewId.width - 20
            height: 2
        }
    }
    RowLayout {
        TextField {
            text: ""
            Layout.fillWidth: true
        }
        Button {
            text: "find"
        }
    }
}
