import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

import QmlCore

ColumnLayout {
    property alias fileDialogUpload: fileDialogUpload
    property alias folderDialogUpload: folderDialogUpload
    property string nearestTemplateGpg: ""

    onVisibleChanged: {
        if (visible) {
            createEmptyFileNameId.forceActiveFocus()
        }
    }

    FileDialog {
        id: fileDialogUpload
        title: "Choose file to upload"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            fileDialogUpload.currentFiles.forEach(f => {
                                                      getMainqmltype(
                                                          ).encryptUpload(
                                                          fullPathFolder, f)
                                                  })
            doMainUiEnable()
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    FolderDialog {
        id: folderDialogUpload
        title: "Choose folder to upload"
        onAccepted: {
            getMainqmltype().encryptFolderUpload(
                        folderDialogUpload.currentFolder, fullPathFolder)
            doMainUiEnable()
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    id: addComponentId

    ColumnLayout {
        Label {
            text: "Destination folder:" + fullPathFolder
        }
        Label {
            text: "Create new text file"
        }
        RowLayout {
            CoreTextField {
                id: createEmptyFileNameId
                text: ""
                placeholderText: "FileName.txt"
                Layout.fillWidth: true
                onTextChanged: {
                    var makeEnabled = Boolean(nearestGpg) && Boolean(
                                createEmptyFileNameId.text)
                    if (getMainqmltype().fileExists(
                                fullPathFolder, createEmptyFileNameId.text)) {
                        makeEnabled = false
                    }
                    addBtnId.enabled = makeEnabled
                }
            }
            CoreButton {
                id: addBtnId
                text: "add"
                enabled: Boolean(nearestGpg) && Boolean(
                             createEmptyFileNameId.text)
                onClicked: {
                    getMainqmltype().createEmptyEncryptedFile(
                                fullPathFolder, createEmptyFileNameId.text,
                                nearestTemplateGpg)
                    createEmptyFileNameId.text = ""
                }
            }
        }
        Label {
            text: "template.gpg: " + nearestTemplateGpg
        }

        RowLayout {
            Label {
                text: "Upload"
            }
            CoreButton {
                text: "Upload file"
                enabled: Boolean(nearestGpg)
                onClicked: {
                    fileDialogUpload.open()
                }
            }
            CoreButton {
                text: "Upload folder content"
                enabled: Boolean(nearestGpg)
                onClicked: {
                    folderDialogUpload.open()
                }
            }
        }
    }
}
