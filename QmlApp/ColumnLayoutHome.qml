import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QmlCore

ColumnLayout {
    property alias metaDataComponentId: metaDataComponentId
    property alias manageGpgIdComponentId: manageGpgIdComponentId
    property alias editComponentId: editComponentId
    property alias addComponentId: addComponentId
    property alias toolbarId: toolbarId
    property alias customCommitMsgSyncDialog: customCommitMsgSyncDialog

    id: columnLayoutHomeId

    CoreDialogYesNo {
        id: coreDialogYesNo
    }

    CoreDialogYesNo {
        id: customCommitMsgSyncDialog
        title: "Custom commit msg"
        width: parent.width * 0.75

        CoreTextArea {
            id: fieldName
            focus: true
            width: parent.width
        }
        onOpened: fieldName.text = mainLayout.getMainqmltype(
                      ).appSettingsType.commitMsg
        onAccepted: {
            doSync(fieldName.text)
        }
    }

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
