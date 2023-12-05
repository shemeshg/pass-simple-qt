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

    function isAddFileNotAlreadyExists(s) {
        var makeEnabled = Boolean(QmlAppSt.nearestGpg) && Boolean(s)
        if (fileExists(QmlAppSt.fullPathFolder, s)) {
            makeEnabled = false
        }
        return makeEnabled
    }

    FileDialog {
        id: fileDialogUpload
        title: "Choose file to upload"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            QmlAppSt.mainqmltype.encryptUploadAsync(() => {
                                                        QmlAppSt.doMainUiEnable(
                                                            )
                                                    }, QmlAppSt.fullPathFolder,
                                                    fileDialogUpload.currentFiles)
        }
        onRejected: {
            QmlAppSt.doMainUiEnable()
        }
    }

    FolderDialog {
        id: folderDialogUpload
        title: "Choose folder to upload"
        onAccepted: {
            QmlAppSt.mainqmltype.encryptFolderUploadAsync(() => {
                                                              QmlAppSt.doMainUiEnable()
                                                          },
                                                          folderDialogUpload.currentFolder,
                                                          QmlAppSt.fullPathFolder)
        }
        onRejected: {
            QmlAppSt.doMainUiEnable()
        }
    }

    id: addComponentId

    ColumnLayout {
        CoreLabelAndText {
            coreLabel: "Destination folder"
            coreText: QmlAppSt.fullPathFolder
        }
        Label {
            text: "Create new text file"
        }
        RowLayout {
            LayoutMirroring.enabled: createEmptyFileNameId.horizontalAlignment === Text.AlignRight
            CoreTextField {
                id: createEmptyFileNameId
                text: ""
                placeholderText: "FileName.txt"
                Layout.fillWidth: true
            }
            CoreButton {
                id: addBtnId
                text: "add"

                onClicked: {
                    QmlAppSt.mainqmltype.createEmptyEncryptedFile(
                                QmlAppSt.fullPathFolder,
                                createEmptyFileNameId.text, nearestTemplateGpg)
                    createEmptyFileNameId.text = ""
                }
                enabled: isAddFileNotAlreadyExists(createEmptyFileNameId.text)
            }
        }
        RowLayout {
            Label {
                text: "template.gpg: "
            }
            CoreLabel {
                text: nearestTemplateGpg
            }

            CoreButton {
                text: "+"
                visible: isAddFileNotAlreadyExists("template")
                onClicked: {
                    createEmptyFileNameId.text = "template"
                }
                hooverText: "Set template name"
            }
            CoreButton {
                visible: Boolean(nearestTemplateGpg)
                text: "←"
                onClicked: {
                    QmlAppSt.mainqmltype.setTreeViewSelected(
                                nearestTemplateGpg + "/template.gpg")
                }
                hooverText: "Select"
            }
        }
    }
}
