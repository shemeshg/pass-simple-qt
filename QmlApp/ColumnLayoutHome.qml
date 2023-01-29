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

    id: columnLayoutHomeId
    width: parent.width
    Layout.fillWidth: true
    visible: !isShowLog;
    TabBar {
        id: bar
        Layout.fillWidth: true


        TabButton {
            text: qsTr("Edit")
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
