import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform

import DropdownWithList
import EditYaml

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
            getMainqmltype().dectyptFileNameToFileName(
                        fullPathFolder + "/" + downloadFrom + ".gpg",
                        folder + "/" + filename)
            doMainUiEnable()
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
            urlfileDialogUrlField.files.forEach(f => {
                                                    getMainqmltype(
                                                        ).encryptUpload(
                                                        fullPathFolder, f, true)
                                                    let filename = f.toString(
                                                        ).replace(/^.*[\\\/]/,
                                                                  '')
                                                    inField.text = "_files/" + filename
                                                })
            doMainUiEnable()
            notifyStr("*")
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
            var filename = filePath.replace(/^.*[\\\/]/, '')
            filename = filename.substr(0, filename.length - 4)
            getMainqmltype().decryptDownload(
                        fileDialogDownload.folder + "/" + filename)
            doMainUiEnable()
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    FolderDialog {
        id: folderDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptFolderDownload(fullPathFolder,
                                                   folderDialogDownload.folder)
            doMainUiEnable()
        }
        onRejected: {
            doMainUiEnable()
        }
    }

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }

    RowLayout {
        width: parent.width
        Label {
            visible: isGpgFile
            text: "<h1>Edit<h1>"
            Layout.fillWidth: true
        }
        Item {
            Layout.fillWidth: true
        }

        CoreButton {
            visible: isGpgFile
            text: "download file"
            onClicked: {
                fileDialogDownload.open()
            }
            rightPadding: 8
        }
        CoreButton {
            visible: Boolean(nearestGpg)
            text: "download folder content"
            onClicked: {
                onClicked: {
                    folderDialogDownload.open()
                }
            }
            rightPadding: 8
        }
    }
    RowLayout {
        Label {
            visible: isGpgFile
            text: "<h2>" + filePath.replace(fullPathFolder, "").substring(
                      1, filePath.replace(fullPathFolder,
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
        visible: waitItems.indexOf(filePath) > -1 || noneWaitItems.indexOf(
                     filePath) > -1
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

        Switch {
            id: isPreviewId
            text: qsTr("Pr<u>e</u>view")
            checked: isShowPreview
            onToggled: {
                isShowPreview = isPreviewId.checked
                reloadAfterPreviewChanged()
            }
            visible: waitItems.indexOf(filePath) === -1
                     && noneWaitItems.indexOf(filePath) === -1 && !isBinaryFile
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

        Switch {
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
                notifyStr("* Saved", true)
                mainLayout.encryptAsync(decryptedText, () => {
                                            isSaving = false
                                            doMainUiEnable()
                                        })
            }
            visible: isShowPreview
        }

        Shortcut {
            sequence: "Ctrl+O"
            onActivated: {
                if (editComponentId.visible && !isShowPreview
                        && waitItems.indexOf(filePath) === -1
                        && noneWaitItems.indexOf(filePath) === -1
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
            visible: !isShowPreview && waitItems.indexOf(filePath) === -1
                     && noneWaitItems.indexOf(filePath) === -1 && !isBinaryFile
        }
        CoreButton {
            text: "Close File browser item"
            onClicked: {
                mainLayout.closeExternalEncryptNoWait()
            }
            visible: !isShowPreview && noneWaitItems.indexOf(filePath) > -1
                     && !isBinaryFile
        }

        ComboBox {
            id: selectExternalEncryptDestinationId
            model: ["code --wait", "File browser"]
            width: 200
            visible: !isShowPreview && waitItems.indexOf(filePath) === -1
                     && noneWaitItems.indexOf(filePath) === -1 && !isBinaryFile
        }
        Item {
            height: 2
            width: 2
            Layout.fillWidth: true
            visible: isShowPreview
        }
        Switch {
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

        ScrollView {
            height: parent.height
            width: parent.width
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                height: parent.height
                width: parent.width

                Layout.fillWidth: true
                Layout.fillHeight: true

                ToolTip {
                    id: toolTip

                    contentItem: Text {
                        color: systemPalette.text
                        text: toolTip.text
                    }
                }

                HoverHandler {
                    id: hoverHandler
                    onHoveredChanged: {
                        if (hovered)
                            toolTip.hide()
                    }
                }

                Loader {
                    width: parent.width
                    height: parent.height
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    sourceComponent: showMdId.checked ? mdDecryptedTextIdComponent : decryptedTextIdComponent
                }

                Item {
                    Layout.fillWidth: true
                    height: 100
                }

                Component {
                    id: mdDecryptedTextIdComponent

                    TextArea {
                        id: mdDecryptedTextId

                        selectionColor: systemPalette.highlight
                        selectedTextColor: systemPalette.highlightedText

                        width: parent.width
                        height: parent.height
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        text: decryptedText
                        readOnly: true
                        visible: showMdId.checked
                        textFormat: TextEdit.MarkdownText
                        onLinkActivated: link => {
                                             doUrlRedirect(link)
                                         }
                        onLinkHovered: link => {
                                           if (link.length === 0)
                                           return

                                           // Show the ToolTip at the mouse cursor, plus some margins so the mouse doesn't get in the way.
                                           toolTip.x = hoverHandler.point.position.x + 8
                                           toolTip.y = hoverHandler.point.position.y + 8
                                           toolTip.show(link, 3000)
                                       }
                    }
                }

                Component {
                    id: decryptedTextIdComponent
                    TextArea {
                        property bool isKeyPressed: false
                        id: decryptedTextId
                        text: decryptedText
                        width: parent.width
                        height: parent.height
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "Enter text here, YAML can not start with '-' or '#'"
                        placeholderTextColor: "black"
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

                        selectionColor: systemPalette.highlight
                        selectedTextColor: systemPalette.highlightedText
                    }
                }
            }
        }
    }
}
