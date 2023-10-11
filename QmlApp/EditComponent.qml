import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

import EditYaml
import QmlCore

ColumnLayout {
    property bool showYamlEdit: true
    property alias folderDialogDownload: folderDialogDownload
    property alias fileDialogDownload: fileDialogDownload
    property alias loaderShowYamlEditComponent: loaderShowYamlEditComponent
    property string decryptedText: ""
    property alias fileUrlDialogDownload: fileUrlDialogDownload

    onDecryptedTextChanged: {
        loaderShowYamlEditComponent.editYamlType.text = decryptedText
    }

    function setLoaderShowYamlEditComponent() {
        if (isGpgFile && isShowPreview && showYamlEdit) {
            loaderShowYamlEditComponent.sourceComponent = doShowYamlEditComponent
        } else if (isGpgFile && isShowPreview && !showYamlEdit) {
            loaderShowYamlEditComponent.sourceComponent = dontShowYamlEditComponent
        } else {
            loaderShowYamlEditComponent.sourceComponent = undefined
        }
    }

    function preferYamlIfYamlIsValidOnFileChange() {
        var doLoaderShowYamlCreation = true
        if (isPreviewId && isPreviewId.checked) {
            if ((loaderShowYamlEditComponent.editYamlType.isYamlValid
                 && !isYamlShow.checked)
                    || (!loaderShowYamlEditComponent.editYamlType.isYamlValid
                        && isYamlShow.checked)) {

                isYamlShow.checked = !isYamlShow.checked
                doLoaderShowYamlCreation = false
            }
            showYamlEdit = isYamlShow.checked
            doShowYAML()
        }
        if (doLoaderShowYamlCreation) {
            setLoaderShowYamlEditComponent()
        }
    }

    function doShowYAML() {
        if (!showYamlEdit
                && loaderShowYamlEditComponent.editYamlType.isYamlValid) {
            decryptedText = loaderShowYamlEditComponent.editYamlType.getUpdatedText()
        }
        if (isGpgFile) {
            setLoaderShowYamlEditComponent()
        }
    }

    function doExternalOpen() {
        if (selectExternalEncryptDestinationId.currentValue === "code --wait") {
            mainLayout.openExternalEncryptWait()
        } else if (selectExternalEncryptDestinationId.editText === "File browser") {
            mainLayout.openExternalEncryptNoWait()
        }
    }

    function reloadAfterPreviewChanged() {
        if (classInitialized) {
            initOnFileChanged()
        }
        if (isGpgFile) {
            setLoaderShowYamlEditComponent()
        }
    }
    FolderDialog {
        id: fileUrlDialogDownload
        property string downloadFrom: ""
        title: "Choose folder to download input field file"
        onAccepted: {
            var filename = downloadFrom.replace(/^.*[\\\/]/, '')
            getMainqmltype().dectyptFileNameToFileNameAsync(() => {
                                                                doMainUiEnable()
                                                            },
                                                            fullPathFolder + "/"
                                                            + downloadFrom + ".gpg",
                                                            currentFolder + "/" + filename)
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    FileDialog {
        id: urlfileDialogUrlField
        property TextField inField
        title: "Choose file to upload"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            getMainqmltype().encryptUploadAsync(() => {
                                                    doMainUiEnable()
                                                    notifyStr("*")
                                                }, fullPathFolder,
                                                urlfileDialogUrlField.currentFiles,
                                                true)

            urlfileDialogUrlField.currentFiles.forEach(f => {
                                                           let filename = f.toString(
                                                               ).replace(
                                                               /^.*[\\\/]/, '')
                                                           inField.text = "_files/" + filename
                                                       })
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    RenameDialog {
        id: renameDialog
    }

    FolderDialog {
        id: fileDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            var filename = QmlAppSt.filePath.replace(/^.*[\\\/]/, '')
            filename = filename.substr(0, filename.length - 4)
            getMainqmltype().decryptDownloadAsync(() => {
                                                      doMainUiEnable()
                                                  },
                                                  fileDialogDownload.currentFolder + "/" + filename)
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    FolderDialog {
        id: folderDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptFolderDownloadAsync(() => {
                                                            doMainUiEnable()
                                                        }, fullPathFolder,
                                                        folderDialogDownload.currentFolder)
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    RowLayout {
        LayoutMirroring.enabled: titleForDisplay.horizontalAlignment === Text.AlignRight
        Item {
            width: 10
            visible: titleForDisplay.horizontalAlignment === Text.AlignRight
        }

        CoreLabel {
            id: titleForDisplay
            visible: isGpgFile
            text: "<h2>" + QmlAppSt.filePath.replace(fullPathFolder,
                                                     "").substring(
                      1, QmlAppSt.filePath.replace(fullPathFolder,
                                                   "").length - 4) + "</h2>"
            Layout.fillWidth: true
        }
        CoreButton {
            visible: isGpgFile
            onClicked: () => {
                           renameDialog.open()
                       }
            icon.name: "Save and Rename"
            hooverText: "Save and Rename"
            icon.source: Qt.resolvedUrl(
                             "icons/edit_FILL0_wght400_GRAD0_opsz48.svg")
        }
    }

    RowLayout {
        visible: waitItems.indexOf(QmlAppSt.filePath) > -1
                 || noneWaitItems.indexOf(QmlAppSt.filePath) > -1
        Label {
            text: "File opened externally"
        }
    }

    Label {
        text: "<h3>Binary file can upload/download only</h3>"
        visible: isGpgFile && isBinaryFile
    }

    RowLayout {
        visible: isGpgFile && !isBinaryFile

        Shortcut {
            sequence: "Ctrl+E"
            onActivated: {
                if (isMainUiDisabled) {
                    return
                }

                if (isPreviewId.visible && editComponentId.visible
                        && !isBinaryFile) {

                    isPreviewId.checked = !isPreviewId.checked
                    isShowPreview = isPreviewId.checked
                    reloadAfterPreviewChanged()
                }
            }
        }

        CoreSwitch {
            id: isPreviewId
            text: qsTr("Pr<u>e</u>view")
            checked: isShowPreview
            onToggled: {
                isShowPreview = isPreviewId.checked
                reloadAfterPreviewChanged()
            }
            visible: waitItems.indexOf(QmlAppSt.filePath) === -1
                     && noneWaitItems.indexOf(QmlAppSt.filePath) === -1
                     && !isBinaryFile
        }

        Shortcut {
            sequence: "Ctrl+M"
            onActivated: {
                if (isPreviewId.checked && editComponentId.visible
                        && !isBinaryFile) {
                    showMdId.checked = !showMdId.checked
                }
            }
        }

        Shortcut {
            sequence: "Ctrl+L"
            onActivated: {
                if (isPreviewId.checked && editComponentId.visible
                        && !isBinaryFile) {

                    isYamlShow.checked = !isYamlShow.checked
                    showYamlEdit = isYamlShow.checked
                    doShowYAML()
                }
            }
        }

        CoreSwitch {
            id: isYamlShow
            visible: isShowPreview
            text: qsTr("YAM<u>L</u>")
            checked: showYamlEdit
            onToggled: {
                showYamlEdit = checked
                doShowYAML()
            }
        }

        Shortcut {
            sequence: StandardKey.Save
            onActivated: {
                if (isMainUiDisabled) {
                    return
                }
                if (saveBtnId.visible && saveBtnId.enabled && !isBinaryFile) {
                    saveBtnId.clicked()
                }
            }
        }

        CoreButton {
            id: saveBtnId
            text: "&Save"
            enabled: hasEffectiveGpgIdFile
                     && (!showYamlEdit || showYamlEdit
                         && loaderShowYamlEditComponent.editYamlType.isYamlValid)
                     && !isSaving && !isBinaryFile
            onClicked: {
                if (showYamlEdit) {
                    decryptedText = loaderShowYamlEditComponent.editYamlType.getUpdatedText()
                }
                isSaving = true
                doMainUiDisable()
                notifyStr("* Saving")
                mainLayout.encryptAsync(decryptedText, () => {
                                            isSaving = false
                                            doMainUiEnable()
                                            setGitDiffReturnCode()
                                            notifyStr("")
                                        })
            }
            visible: isShowPreview
        }

        Shortcut {
            sequence: "Ctrl+O"
            onActivated: {
                if (editComponentId.visible && !isShowPreview
                        && waitItems.indexOf(QmlAppSt.filePath) === -1
                        && noneWaitItems.indexOf(QmlAppSt.filePath) === -1
                        && !isBinaryFile) {
                    doExternalOpen()
                }
            }
        }
        CoreButton {
            text: "&Open"
            enabled: hasEffectiveGpgIdFile
            onClicked: {
                doExternalOpen()
            }
            visible: !isShowPreview && waitItems.indexOf(
                         QmlAppSt.filePath) === -1 && noneWaitItems.indexOf(
                         QmlAppSt.filePath) === -1 && !isBinaryFile
        }
        CoreButton {
            text: "Close File browser item"
            onClicked: {
                mainLayout.closeExternalEncryptNoWait()
            }
            visible: !isShowPreview && noneWaitItems.indexOf(
                         QmlAppSt.filePath) > -1 && !isBinaryFile
        }

        CoreComboBox {
            id: selectExternalEncryptDestinationId

            model: ["code --wait", "File browser"]
            width: 200
            visible: !isShowPreview && waitItems.indexOf(
                         QmlAppSt.filePath) === -1 && noneWaitItems.indexOf(
                         QmlAppSt.filePath) === -1 && !isBinaryFile
        }
        Item {
            height: 2
            width: 2
            Layout.fillWidth: true
            visible: isShowPreview
        }
        CoreSwitch {
            id: showMdId
            checked: false
            text: qsTr("<u>M</u>↓")
            visible: isShowPreview && !isBinaryFile
        }
    }

    Loader {
        id: loaderShowYamlEditComponent
        active: false
        width: parent.width
        height: parent.height
        Layout.fillWidth: true
        Layout.fillHeight: true
        property alias editYamlType: editYamlType
        EditYamlType {
            id: editYamlType
            onYamlModelChanged: {
                clearSystemTrayIconEntries()
                for (var idx in yamlModel) {
                    addSystemTrayIconEntries(yamlModel[idx].key,
                                             yamlModel[idx].val,
                                             yamlModel[idx].inputType)
                }
            }
        }
    }

    Component {
        id: doShowYamlEditComponent

        Row {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: isGpgFile
            EditYamlComponent {
                id: editYamlComponentId
                visible: isGpgFile && isShowPreview && showYamlEdit
                width: parent.width
                height: parent.height
            }
        }
    }

    Component {
        id: dontShowYamlEditComponent

        ColumnLayout {
            height: parent.height
            width: parent.width

            Layout.fillWidth: true
            Layout.fillHeight: true
            Loader {
                // Explicitly set the size of the
                // Loader to the parent item's size
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: showMdId.checked ? componentMdDecryptedTextId : componentDecryptedTextId
            }

            Component {
                id: componentMdDecryptedTextId
                ScrollView {
                    visible: showMdId.checked
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: mdDecryptedTextId.height
                    CoreTextArea {
                        id: mdDecryptedTextId
                        text: decryptedText
                        readOnly: true
                        visible: showMdId.checked
                        textFormat: TextEdit.MarkdownText
                        Layout.fillWidth: true
                    }
                }
            }
            Component {
                id: componentDecryptedTextId
                ScrollView {
                    visible: !showMdId.checked
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: decryptedTextId.height
                    CoreTextArea {
                        property bool isKeyPressed: false
                        id: decryptedTextId
                        text: decryptedText
                        Layout.fillWidth: true
                        placeholderText: "Enter text here, YAML can not start with '-' or '#'"

                        onSelectedTextChanged: {
                            getMainqmltype().selectedText = selectedText
                        }
                        visible: !showMdId.checked
                        onTextChanged: {
                            decryptedText = text
                            if (isKeyPressed) {
                                notifyStr("*")
                                isKeyPressed = false
                            }
                        }
                        Keys.onPressed: event => {
                                            isKeyPressed = true
                                        }
                    }
                }
            }
        }
    }
}
