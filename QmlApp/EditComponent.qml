import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList
import EditYaml

ColumnLayout {
    property alias decryptedTextId: decryptedTextId
    property bool showYamlEdit: false

    FileDialog {
        id: fileDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptDownload(fileDialogDownload.selectedFile)
        }
        onRejected: {
        }
        fileMode: FileDialog.SaveFile

    }

    Text {
        visible: isGpgFile
        text: "<h1>Edit<h1>"
    }
    Row{
        visible: isGpgFile
        Switch {
            id: isPreviewId
            text: qsTr("Preview")
            checked: isShowPreview
            onCheckedChanged: {
                isShowPreview = isPreviewId.checked
                if(classInitialized){
                    initOnFileChanged();
                }
            }
        }
        Switch {
            visible: isShowPreview
            text: qsTr("YAML")
            checked: showYamlEdit
            onCheckedChanged: {
                showYamlEdit = checked
            }
        }


        Button {
            text: "Save"
            enabled: hasEffectiveGpgIdFile;
            onClicked:{
                mainLayout.encrypt(decryptedTextId.textEdit.text)
            }
            visible: isShowPreview
        }
        Button {
            text: "Open"
            enabled: hasEffectiveGpgIdFile;
            onClicked: {
                if (selectExternalEncryptDestinationId.currentValue === "code --wait"){
                    mainLayout.openExternalEncryptWait();
                } else if (selectExternalEncryptDestinationId.editText === "File browser"){
                    mainLayout.openExternalEncryptNoWait();
                }


            }
            visible: !isShowPreview &&
                     waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }
        Button {
            text: "Close File browser item"
            onClicked: {
                mainLayout.closeExternalEncryptNoWait();
            }
            visible: !isShowPreview && noneWaitItems.indexOf(filePath) > -1
        }


        ComboBox {
            id: selectExternalEncryptDestinationId
            model: ["code --wait", "File browser"]
            width: 200
            visible: !isShowPreview &&
                     waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }
        Button {
            text: "download"
            enabled: isGpgFile
            onClicked: fileDialogDownload.open()
        }
    }
    Row{
        visible: isGpgFile
        TextEditComponent {
            id: decryptedTextId
            visible: isShowPreview && !showYamlEdit
            width: scrollViewId.width - 20
        }
    }
    Row {
        visible: isGpgFile
        EditYamlComponent {
            visible: isShowPreview && showYamlEdit
            text: decryptedTextId.textEdit.text
        }
    }

}
