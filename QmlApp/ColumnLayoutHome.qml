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
        id: customCommitMsgSyncDialog
        title: "Custom commit msg"
        width: parent.width * 0.75

        CoreTextArea {
            id: fieldName
            focus: true
            width: parent.width
        }
        onOpened: fieldName.text = QmlAppSt.mainqmltype.appSettingsType.commitMsg
        onAccepted: {
            doSync(fieldName.text)
        }
    }

    TabBar {
        id: toolbarId
        Layout.fillWidth: true
        width: parent.width

        CoreTabButton {
            idx: 0
            cidx: toolbarId.currentIndex
            text: qsTr("Edit")
        }
        CoreTabButton {
            idx: 1
            cidx: toolbarId.currentIndex
            text: qsTr("Add")
        }
        CoreTabButton {
            idx: 2
            cidx: toolbarId.currentIndex
            text: qsTr("Info Git")
        }
        CoreTabButton {
            idx: 3
            cidx: toolbarId.currentIndex
            text: qsTr("Auth")
        }
    }

    StackLayout {
        width: parent.width

        currentIndex: toolbarId.currentIndex
        EditComponent {
            id: editComponentId
            onDoUrlRedirect: s => {
                                 QmlAppSt.doUrlRedirect(s)
                             }
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
