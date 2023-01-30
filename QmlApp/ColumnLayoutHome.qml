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

    id: columnLayoutHomeId

    width: scrollViewId.width
    visible: !isShowLog;
    TabBar {
        id: bar
        Layout.fillWidth: true
        width: scrollViewId.width

        TabButton {
            text: qsTr("Edit")
        }
        TabButton {
            text: qsTr("Add")
        }
        TabButton {
            text: qsTr("Manage")
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
        AddComponent {
            id: addComponentId
        }

        ManageGpgIdComponent {
            id: manageGpgIdComponentId
        }

        MetaDataComponent {
            id: metaDataComponentId
        }
    }

}
