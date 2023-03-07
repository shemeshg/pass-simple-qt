import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias metaDataComponentId: metaDataComponentId
    property alias manageGpgIdComponentId: manageGpgIdComponentId
    property alias editComponentId: editComponentId
    property alias addComponentId: addComponentId
    property alias toolbarId: toolbarId

    id: columnLayoutHomeId



    visible: !isShowLog;
    TabBar {
        id: toolbarId
        Layout.fillWidth: true
        width: parent.width

        TabButton {
            text: qsTr("Edit")
        }
        TabButton {
            text: qsTr("Add")
        }
        TabButton {
            text: qsTr("Info Git")
        }
        TabButton {
            text: qsTr("Auth")
        }
    }

    StackLayout {
        width: parent.width

        currentIndex: toolbarId.currentIndex
        EditComponent {
            id: editComponentId
        }
        AddComponent {
            id: addComponentId
        }

        MetaDataComponent {
            id: metaDataComponentId
        }
        ManageGpgIdComponent {
            id: manageGpgIdComponentId
        }
    }

}
