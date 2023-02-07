import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSettings
    width: parent.width

    property bool isUseClipboard: mainLayout.getMainqmltype().appSettingsType.useClipboard

    FileDialog {
        id: selectStorePathDialogId
        title: "Select folder"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            let path = selectStorePathDialogId.selectedFile.toString();
            path = path.replace(/^(file:\/{3})/,"");
                    // unescape html codes like '%23' for '#'
            path = decodeURIComponent(path);

            path =  path.substring(0, path.lastIndexOf("/")) ;
            passwordStorePathStr = "/" + path
        }
        onRejected: {
        }
    }

    function saveSettingsComponent(){
        mainLayout.getMainqmltype().submit_AppSettingsType(
                                   passwordStorePathStr,
                                   tmpFolderPath.text,
                                   gitExecPath.text,
                                   vscodeExecPath.text,
                                   autoTypeCmd.text,
                                   useClipboard.checked);
    }

    RowLayout {
        Button {
            text: "Back"
            onClicked: isShowSettings = false
        }
        Button {
            text: "Save"
            onClicked: saveSettingsComponent();
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
            text: "Password Store Path:"
        }
        Button {
            text:  "default"
            onClicked: passwordStorePathStr = ""
        }
        Button {
            text:  "select"
            onClicked: selectStorePathDialogId.open()
        }
    }

    RowLayout {

        TextField {
            text: passwordStorePathStr;
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
    RowLayout {
        Switch {
            id: useClipboard
            visible: isShowPreview
            text: qsTr("Use clipboard")
            checked: isUseClipboard;
            onCheckedChanged: {
                saveSettingsComponent();
            }
        }
    }


}
