import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSettings
    width: parent.width
    RowLayout {
        Button {
            text: "Back"
            onClicked: isShowSettings = false
        }
        Button {
            text: "Save"
            onClicked: mainLayout.getMainqmltype().submit_AppSettingsType(
                           passwordStorePath.text,
                           tmpFolderPath.text,
                           gitExecPath.text,
                           vscodeExecPath.text,
                           autoTypeCmd.text)
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
        Label {
            text: "Password Store Path"
        }
        TextField {
            id: passwordStorePath
            text: mainLayout.getMainqmltype().appSettingsType.passwordStorePath;
            Layout.fillWidth: true
        }
    }
    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Tmp Folder Path"
        }
        TextField {
            id: tmpFolderPath
            text: mainLayout.getMainqmltype().appSettingsType.tmpFolderPath
            Layout.fillWidth: true
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "git exec Path"
        }
        TextField {
            id: gitExecPath
            text: mainLayout.getMainqmltype().appSettingsType.gitExecPath
            Layout.fillWidth: true
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "vscode execr Path"
        }
        TextField {
            id: vscodeExecPath
            text: mainLayout.getMainqmltype().appSettingsType.vscodeExecPath
            Layout.fillWidth: true
        }
    }
    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "Linux only autotype cmd"
        }
        TextField {
            id: autoTypeCmd
            text: mainLayout.getMainqmltype().appSettingsType.autoTypeCmd
            Layout.fillWidth: true
        }
    }


}
