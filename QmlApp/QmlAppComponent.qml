import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

ColumnLayout {
    width: parent.width
    height: parent.height

    property bool classInitialized: false
    property bool gpgPubKeysFolderExists: false

    property bool hasEffectiveGpgIdFile: false
    property bool isGpgFile: false
    property bool isBinaryFile: false
    property bool isPreviousShowPreview: false
    property int gitDiffReturnCode: 0

    property string nearestGpg: ""
    property string fullPathFolder: ""
    property string nearestGit: ""
    property var allPrivateKeys: []

    property bool isDarkTheme: false

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
        onButtonTextChanged: {
            isDarkTheme = !isDarkColor(systemPalette.text.toString())
            mainLayout.getMainqmltype().systemPlateChanged(isDarkTheme)
        }
    }

    Component.onCompleted: {
        mainLayout.getMainqmltype().initGpgIdManage()
        allPrivateKeys = mainLayout.getGpgIdManageType().allPrivateKeys

        getMainqmltype().setTreeViewSelected(QmlAppSt.passwordStorePathStr)
        QmlAppSt.passwordStorePathStr = mainLayout.getMainqmltype(
                    ).appSettingsType.passwordStorePath
    }

    Connections {
        target: QmlAppSt
        function onFilePathChanged(s) {
            initOnFileChanged()
        }

        function onMenubarCommStrChanged(s) {

            let action = QmlAppSt.menubarCommStr.split(" ")[0]
            if (action === "addItemAct") {
                QmlAppSt.isShowSettings = false
                QmlAppSt.isShowSearch = false
                QmlAppSt.isShowLog = false
                columnLayoutHomeId.toolbarId.currentIndex = 1
            }
            if (Boolean(nearestGpg)) {
                if (action === "uploadFileAct") {
                    mainLayout.getMainqmltype().mainUiDisable()
                    columnLayoutHomeId.addComponentId.fileDialogUpload.open()
                }
                if (action === "uploadFolderAct") {
                    mainLayout.getMainqmltype().mainUiDisable()
                    columnLayoutHomeId.addComponentId.folderDialogUpload.open()
                }
                if (action === "downloadFolderAct") {
                    mainLayout.getMainqmltype().mainUiDisable()
                    columnLayoutHomeId.editComponentId.folderDialogDownload.open()
                }
            }
            if (isGpgFile && action === "downloadFileAct") {
                mainLayout.getMainqmltype().mainUiDisable()
                columnLayoutHomeId.editComponentId.fileDialogDownload.open()
            }
        }
    }

    //console.log(isDarkColor("#d8000000"));
    function isDarkColor(hex) {
        // Convert hex color to RGB values
        let r = parseInt(hex.slice(1, 3), 16)
        let g = parseInt(hex.slice(3, 5), 16)
        let b = parseInt(hex.slice(5, 7), 16)

        // Calculate luminance
        let l = 0.2126 * r + 0.7152 * g + 0.0722 * b

        // Return true if luminance is less than 128, false otherwise
        return l < 128
    }

    function doUrlRedirect(link) {
        if (link.length === 0)
            return
        if (link.includes("://")) {
            Qt.openUrlExternally(link)
        } else if (link.startsWith("/")) {
            return
            //only relative path allowed
        } else {
            getMainqmltype().tryRedirectLocalLink(link)
        }
    }

    function decryptedSignedByFullId(idStr, allKeys) {
        if (!Boolean(idStr)) {
            return ""
        }
        let retStr = allKeys.filter(row => {
                                        return row.search(idStr) !== -1
                                    })[0]
        if (!retStr) {
            retStr = idStr
        }
        return retStr
    }

    function getIsBinary(fullPathToFile) {
        let file = fullPathToFile.substring(1, fullPathToFile.length - 4)
        let extensions = mainLayout.getMainqmltype(
                ).appSettingsType.binaryExts.toLowerCase()
        let initialValue = 0
        let ret = extensions.split("\n").reduce((accumulator, currentValue) => {
                                                    if (Boolean(currentValue)
                                                        && file.slice(
                                                            currentValue.length * -1)
                                                        === currentValue) {
                                                        return accumulator + 1
                                                    }
                                                    return accumulator
                                                }, initialValue)

        return Boolean(ret)
    }

    function setGitDiffReturnCode() {
        if (Boolean(nearestGit)) {
            gitDiffReturnCode = getMainqmltype().runCmd(
                        [mainLayout.getMainqmltype(
                             ).appSettingsType.gitExecPath, "-C", nearestGit, "status", "--porcelain"],
                        " 2>&1 ").length
        }
    }

    function populateDecryptedUiFields() {
        nearestGit = mainLayout.getNearestGit()
        setGitDiffReturnCode()

        columnLayoutHomeId.addComponentId.nearestTemplateGpg = mainLayout.getNearestTemplateGpg()
        nearestGpg = mainLayout.getNearestGpgId()
        fullPathFolder = getMainqmltype().getFullPathFolder()
        hasEffectiveGpgIdFile = Boolean(mainLayout.getNearestGpgId())
        isGpgFile = getMainqmltype().isGpgFile()
        let allKeys = mainLayout.getGpgIdManageType().allKeys
        columnLayoutHomeId.metaDataComponentId.decryptedSignedById = decryptedSignedByFullId(
                    mainLayout.getDecryptedSignedBy(), allKeys)
        columnLayoutHomeId.metaDataComponentId.gitResponseId = ""
        columnLayoutHomeId.manageGpgIdComponentId.badEntriesRepeater.model
                = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.allItems = allKeys
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.selectedItems
                = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
        classInitialized = mainLayout.getGpgIdManageType().classInitialized
        gpgPubKeysFolderExists = mainLayout.getGpgIdManageType(
                    ).gpgPubKeysFolderExists

        if (mainLayout.getMainqmltype().appSettingsType.preferYamlView) {
            columnLayoutHomeId.editComponentId.preferYamlIfYamlIsValidOnFileChange()
        } else {
            columnLayoutHomeId.editComponentId.setLoaderShowYamlEditComponent()
        }

        notifyStr("")
    }

    function initOnFileChanged() {
        clearSystemTrayIconEntries()
        isBinaryFile = getIsBinary(QmlAppSt.filePath)

        if (isBinaryFile || QmlAppSt.waitItems.indexOf(QmlAppSt.filePath) > -1
                || QmlAppSt.noneWaitItems.indexOf(QmlAppSt.filePath) > -1) {
            if (QmlAppSt.isShowPreview) {
                isPreviousShowPreview = true
            }

            QmlAppSt.isShowPreview = false
        } else if (isPreviousShowPreview) {
            QmlAppSt.isShowPreview = true
            isPreviousShowPreview = false
        }

        if (QmlAppSt.isShowPreview) {
            columnLayoutHomeId.editComponentId.loaderShowYamlEditComponent.active = false
            doMainUiDisable()
            columnLayoutHomeId.editComponentId.decryptedText = "status: Loading..."
            getMainqmltype().getDecryptedAsync(s => {
                                                   clearSystemTrayIconEntries()
                                                   columnLayoutHomeId.editComponentId.decryptedText = s
                                                   populateDecryptedUiFields()
                                                   doMainUiEnable()
                                                   columnLayoutHomeId.editComponentId.loaderShowYamlEditComponent.active = true
                                               })
        } else {
            populateDecryptedUiFields()
        }
    }

    function clearSystemTrayIconEntries() {
        mainLayout.getMainqmltype().trayMenuClear()
    }

    function addSystemTrayIconEntries(txt, passwd, fieldType) {
        mainLayout.getMainqmltype().trayMenuAdd(txt, passwd, fieldType)
    }

    SearchComponent {
        id: searchComponentID
    }

    SHowSettingsComponent {
        id: showSettingsComponentId
    }

    Component {
        id: delayCallerComponent
        Timer {}
    }

    function delaySetTimeOut(interval, callback) {
        var delayCaller = delayCallerComponent.createObject(null, {
                                                                "interval": interval,
                                                                "repeat": false
                                                            })
        delayCaller.triggered.connect(function () {
            callback()
            delayCaller.destroy()
        })
        delayCaller.start()
    }

    function notifyStr(str, withTimeout = false, callback = () => {}, clearString = "") {
    statusLabelId.text = str
    if (withTimeout) {
        delaySetTimeOut(1000, function () {
            callback()
            statusLabelId.text = clearString
        })
    }
}

function doSync(syncMsg) {
    var cllbackClearString = statusLabelId.text === "*" ? "*" : ""

    QmlAppSt.isSaving = true
    doMainUiDisable()
    notifyStr("* add all, commit, pull, putsh")
    getMainqmltype().runGitSyncCmdAsync(() => {
                                            doMainUiEnable()
                                            setGitDiffReturnCode()
                                            QmlAppSt.isSaving = false
                                            notifyStr(cllbackClearString)
                                        }, nearestGit, syncMsg)
}

ColumnLayout {
    width: parent.width
    height: parent.height
    Layout.fillWidth: true
    visible: !QmlAppSt.isShowSettings && !QmlAppSt.isShowSearch
    RowLayout {
        CoreButton {
            onClicked: {
                mainLayout.toggleFilepan()
            }
            icon.name: "Hide/Show treeview"
            icon.source: Qt.resolvedUrl(
                             "icons/account_tree_FILL0_wght400_GRAD0_opsz48.svg")
            hooverText: "Hide/Show treeview"
        }
        CoreButton {
            onClicked: {
                mainLayout.getMainqmltype().openStoreInFileBrowser(
                    fullPathFolder)
            }
            icon.name: "Open store in file browser"
            icon.source: Qt.resolvedUrl(
                             "icons/store_FILL0_wght400_GRAD0_opsz48.svg")
            hooverText: "Open store in file browser"
        }
        CoreButton {
            onClicked: {
                QmlAppSt.isShowSettings = true
            }
            icon.name: "Settings"
            icon.source: Qt.resolvedUrl(
                             "icons/settings_FILL0_wght400_GRAD0_opsz48.svg")
            hooverText: "Settings"
        }
        CoreButton {
            onClicked: {
                QmlAppSt.isShowSearch = true
            }

            icon.name: "search"
            icon.source: Qt.resolvedUrl(
                             "icons/search_FILL0_wght400_GRAD0_opsz48.svg")
            hooverText: "search"
        }
        Label {
            id: statusLabelId
            text: ""
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
        }
        Shortcut {
            sequence: "Ctrl+Y"
            onActivated: {
                if (QmlAppSt.isMainUiDisabled) {
                    return
                }
                if (syncBtn.enabled) {
                    doSync(mainLayout.getMainqmltype(
                               ).appSettingsType.commitMsg)
                }
            }
        }

        CoreButton {
            id: syncBtn
            MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton) {
                        columnLayoutHomeId.customCommitMsgSyncDialog.open()
                    } else if (mouse.button === Qt.LeftButton) {
                        doSync(mainLayout.getMainqmltype(
                                   ).appSettingsType.commitMsg)
                    }
                }
            }

            icon.name: "sync"

            text: Boolean(gitDiffReturnCode) ? "*" : ""
            icon.source: Qt.resolvedUrl(
                             "icons/sync_FILL0_wght400_GRAD0_opsz48.svg")
            hooverText: gitDiffReturnCode ? "<b>Pending changes</b><br/><b>Cmd Y</b> commit pull push <br/> R.Click for custom msg." : "<b>Cmd Y</b> commit pull push <br/> R.Click for custom msg."
            enabled: Boolean(nearestGit) && !QmlAppSt.isSaving
        }
    }
    RowLayout {
        CoreThinBar {}
        Item {
            width: 5
        }
    }
    ColumnLayoutHome {
        id: columnLayoutHomeId
    }
}
}
