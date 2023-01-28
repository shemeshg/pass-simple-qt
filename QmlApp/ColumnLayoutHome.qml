import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    id: columnLayoutHomeId
    width: parent.width
    Layout.fillWidth: true
    visible: !isShowLog;
    RowLayout{
        Button {
            onClicked: { mainLayout.toggleFilepan()}
            icon.name: "Hide/Show treeview"
            icon.source: "icons/icons8-tree-structure-80.png"
            ToolTip.visible: hovered
            ToolTip.text: "Hide/Show treeview"
        }
        Button {
            onClicked: { mainLayout.openStoreInFileBrowser()}
            icon.name: "Open store in file browser"
            icon.source: "icons/icons8-shop-80.png"
            ToolTip.visible: hovered
            ToolTip.text: "Open store in file browser"
        }
        Button {                
            onClicked: {}
            icon.name: "Settings"
            icon.source: "icons/icons8-automation-50.png"
            ToolTip.visible: hovered
            ToolTip.text: "Settings"
        }
    }
    Row{
        Rectangle {
            id: rectId
            color: "white"
            width: scrollViewId.width - 20
            height: 2
        }
    }
    TabBar {
        id: bar
        Layout.fillWidth: true


        TabButton {
            text: qsTr("Home")
        }
        TabButton {
            text: qsTr("Manage .gpg-id")
        }
        TabButton {
            text: qsTr("Meta")
        }
    }

    StackLayout {
        width: scrollViewId.width

        currentIndex: bar.currentIndex
        EditComponent {
            id: editComponentId
        }

        ManageGpgIdComponent {
            id: manageGpgIdComponentId
        }

        MetaDataComponent {
            id: metaDataComponentId
        }
    }

}
