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
            getMainqmltype().encryptUploadAsync(() => {
                                                    doMainUiEnable()
                                                }, QmlAppSt.fullPathFolder,
                                                fileDialogUpload.currentFiles)
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
                        folderDialogUpload.currentFolder,
                        QmlAppSt.fullPathFolder)
            doMainUiEnable()
        }
        onRejected: {
            doMainUiEnable()
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
            Item {
                width: 10
                visible: createEmptyFileNameId.horizontalAlignment === Text.AlignRight
            }
            CoreTextField {
                id: createEmptyFileNameId
                text: ""
                placeholderText: "FileName.txt"
                Layout.fillWidth: true
                onTextChanged: {
                    var makeEnabled = Boolean(QmlAppSt.nearestGpg) && Boolean(
                                createEmptyFileNameId.text)
                    if (getMainqmltype().fileExists(
                                QmlAppSt.fullPathFolder,
                                createEmptyFileNameId.text)) {
                        makeEnabled = false
                    }
                    addBtnId.enabled = makeEnabled
                }
            }
            CoreButton {
                id: addBtnId
                text: "add"
                enabled: Boolean(QmlAppSt.nearestGpg) && Boolean(
                             createEmptyFileNameId.text)
                onClicked: {
                    getMainqmltype().createEmptyEncryptedFile(
                                QmlAppSt.fullPathFolder,
                                createEmptyFileNameId.text, nearestTemplateGpg)
                    createEmptyFileNameId.text = ""
                }
            }
        }
        CoreLabelAndText {
            coreLabel: "template.gpg"
            coreText: nearestTemplateGpg
        }
    }
}
