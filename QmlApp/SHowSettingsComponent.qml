import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform
import DropdownWithList


ColumnLayout {
    visible: isShowSettings
    width: parent.width

    property bool isUseClipboard: mainLayout.getMainqmltype().appSettingsType.useClipboard
    property bool isPreferYamlView: mainLayout.getMainqmltype().appSettingsType.preferYamlView

    FolderDialog {
        id: selectStorePathDialogId
        title: "Select folder"
        //fileMode: FileDialog.OpenFile
        onAccepted: {
            let path = selectStorePathDialogId.selectedFolder.toString();
            path = path.replace(/^(file:\/{3})/,"");
                    // unescape html codes like '%23' for '#'
            path = decodeURIComponent(path);

            //path =  path.substring(0, path.lastIndexOf("/")) ;
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
                                   useClipboard.checked,
                                    preferYamlView.checked,
                                   fontSize.text,
                                    ctxSigner.displayText);
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
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: "white"
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
            onTextChanged:
                passwordStorePathStr = text
        }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: "black"
    }


    ColumnLayout {
        spacing: 8

        Label {
            text: "Private personal Id: "
        }
        ComboBox {
            id: ctxSigner
            model: allPrivateKeys
            Component.onCompleted: {
                currentIndex = find(mainLayout.getMainqmltype().appSettingsType.ctxSigner);
            }
            Layout.fillWidth: true
        }
        Label {
            text: "Temporary directory"
        }
        TextField {
            id: tmpFolderPath
            text: mainLayout.getMainqmltype().appSettingsType.tmpFolderPath
            Layout.fillWidth: true
        }
        Label {
            text: "<b>git</b> executable full path"
        }
        TextField {
            id: gitExecPath
            text: mainLayout.getMainqmltype().appSettingsType.gitExecPath
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Visual Studio Code</b> executable full path"
        }
        TextField {
            id: vscodeExecPath
            text: mainLayout.getMainqmltype().appSettingsType.vscodeExecPath
            Layout.fillWidth: true
        }
        ColumnLayout {
            Layout.fillWidth: true
            visible: Qt.platform.os === "linux"
            Label {
                text: "Linux only autotype cmd"
            }
            TextField {
                id: autoTypeCmd
                text: mainLayout.getMainqmltype().appSettingsType.autoTypeCmd
                Layout.fillWidth: true
            }
        }
        ColumnLayout {
            visible: false
            Label {
                text: "Font size (reopen app required)"
            }
            TextField {
                id: fontSize
                text: mainLayout.getMainqmltype().appSettingsType.fontSize
                Layout.fillWidth: true
            }
        }
        Switch {
            id: preferYamlView
            visible: isShowPreview
            text: qsTr("Prefer Yaml view if Yaml valid")
            checked: isPreferYamlView;
        }
        Switch {
            id: useClipboard
            visible: isShowPreview
            text: qsTr("Use clipboard")
            checked: isUseClipboard;
        }
    }
}
