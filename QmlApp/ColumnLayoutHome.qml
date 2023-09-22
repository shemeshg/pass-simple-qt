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
            background: Rectangle {
                color: toolbarId.currentIndex === 0 ? systemPalette.light : systemPalette.mid
            }
        }
        TabButton {
            text: qsTr("Add")
            background: Rectangle {
                color: toolbarId.currentIndex === 1 ? systemPalette.light : systemPalette.mid
            }
        }
        TabButton {
            text: qsTr("Info Git")
            background: Rectangle {
                color: toolbarId.currentIndex === 2 ? systemPalette.light : systemPalette.mid
            }
        }
        TabButton {
            text: qsTr("Auth")
            background: Rectangle {
                color: toolbarId.currentIndex === 3 ? systemPalette.light : systemPalette.mid
            }
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
