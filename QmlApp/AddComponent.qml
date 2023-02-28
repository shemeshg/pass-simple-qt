import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform
import DropdownWithList

ColumnLayout {    
    property alias fileDialogUpload: fileDialogUpload
    property alias folderDialogUpload: folderDialogUpload

    onVisibleChanged: {
        if (visible) {
            createEmptyFileNameId.forceActiveFocus();
        }
    }


    FileDialog {
        id: fileDialogUpload
        title: "Choose file to upload"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            fileDialogUpload.files.forEach((f)=> {
                                               getMainqmltype().encryptUpload( fullPathFolder, f);
                                           })


        }
        onRejected: {
        }
    }

    FolderDialog {
        id: folderDialogUpload
        title: "Choose folder to upload"
        onAccepted: {
            getMainqmltype().encryptFolderUpload(folderDialogUpload.currentFolder, fullPathFolder)
        }
        onRejected: {
        }
    }

    id: addComponentId

    ColumnLayout{
        Label {
            text: "Destination folder:" + fullPathFolder
        }
        Label {
            text: "Create empty encrypted text file"
        }
        RowLayout {
            TextField {
                id: createEmptyFileNameId
                text: ""
                placeholderText: "FileName.txt"
                Layout.fillWidth: true
                onTextChanged: {
                    var makeEnabled = Boolean(nearestGpg) && Boolean( createEmptyFileNameId.text);
                    if (getMainqmltype().fileExists(fullPathFolder, createEmptyFileNameId.text)){
                        makeEnabled = false;
                    }
                    addBtnId.enabled = makeEnabled
                }
            }
            Button {
                id: addBtnId
                text: "add";
                enabled: Boolean(nearestGpg) && Boolean( createEmptyFileNameId.text)
                onClicked: {
                    getMainqmltype().createEmptyEncryptedFile(fullPathFolder, createEmptyFileNameId.text)
                    createEmptyFileNameId.text = ""
                }
            }
        }
        RowLayout{
            Label {
                text: "Upload"
            }
            Button {
                text: "Upload file"
                enabled: Boolean(nearestGpg)
                onClicked: {
                    fileDialogUpload.open()
                }
            }
            Button {
                text: "Upload folder content"
                enabled: Boolean(nearestGpg)
                onClicked: {
                    folderDialogUpload.open();
                }
            }
        }
    }

}
