import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform
import Qt.labs.folderlistmodel

import DropdownWithList
import InputType


ColumnLayout {
    width: parent.width
    height : parent.height
    //contentWidth: columnLayoutHomeId.width - 30   // The important part
    //contentHeight: columnLayoutHomeId.height + 90   // Same
    //clip : true

    property int filePanSize: 0
    property int exceptionCounter: 0
    property string menubarCommStr: ""
    property string exceptionStr: ""
    property string filePath: ""
    property string tmpShalom: ""
    property bool classInitialized: false
    property bool gpgPubKeysFolderExists: false
    property bool isShowPreview: true
    property bool hasEffectiveGpgIdFile: false
    property bool isGpgFile: false

    property var waitItems: []
    property var noneWaitItems: []

    property bool isShowLog: false
    property bool isShowSettings: false
    property bool isShowSearch: false

    property string showLogText: ""
    property string nearestGpg: ""
    property string fullPathFolder: ""
    property string passwordStorePathStr: mainLayout.getMainqmltype().appSettingsType.passwordStorePath
    property var allPrivateKeys: []


    Component.onCompleted:{
        mainLayout.getMainqmltype().initGpgIdManage();
        allPrivateKeys = mainLayout.getGpgIdManageType().allPrivateKeys;
        getMainqmltype().filePath = passwordStorePathStr;        
    }

    function doUrlRedirect(link){
        if (link.length === 0)
        return
        if (link.includes("://")){
            Qt.openUrlExternally(link)
        } else if (link.startsWith("/")){
           return; //only relative path allowed
        } else {
           getMainqmltype().tryRedirectLocalLink(link)
        }
    }

    function decryptedSignedByFullId(idStr, allKeys){
        if(!Boolean(idStr)){return "";}
        let retStr = allKeys.filter((row)=>{return row.search(idStr) !== -1})[0]
        if(!retStr){retStr=idStr}
        return retStr;
    }

    function initOnFileChanged(){
        clearSystemTrayIconEntries();
        if (isShowPreview){
            columnLayoutHomeId.editComponentId.decryptedText = mainLayout.getDecrypted();
        }

        columnLayoutHomeId.metaDataComponentId.nearestGit = mainLayout.getNearestGit();
        columnLayoutHomeId.addComponentId.nearestTemplateGpg = mainLayout.getNearestTemplateGpg();
        nearestGpg = mainLayout.getNearestGpgId();
        fullPathFolder = getMainqmltype().getFullPathFolder();
        hasEffectiveGpgIdFile = Boolean(mainLayout.getNearestGpgId());
        isGpgFile = filePath.slice(-4)===".gpg";
        let allKeys =  mainLayout.getGpgIdManageType().allKeys
        columnLayoutHomeId.metaDataComponentId.decryptedSignedById =  decryptedSignedByFullId(mainLayout.getDecryptedSignedBy(), allKeys)
        columnLayoutHomeId.metaDataComponentId.gitResponseId = ""
        columnLayoutHomeId.manageGpgIdComponentId.badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.allItems = allKeys
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
        classInitialized = mainLayout.getGpgIdManageType().classInitialized
        gpgPubKeysFolderExists = mainLayout.getGpgIdManageType().gpgPubKeysFolderExists

        if (showSettingsComponentId.isPreferYamlView){
            columnLayoutHomeId.editComponentId.preferYamlIfYamlIsValidOnFileChange()
        } else {
            columnLayoutHomeId.editComponentId.setLoaderShowYamlEditComponent();
        }

        notifyStr("")


    }

    InputTypeType {
        id: inputTypeTypeDecodeId
    }


    function clearSystemTrayIconEntries() {
        mainLayout.getMainqmltype().trayMenuClear();
    }

    function addSystemTrayIconEntries(txt, passwd, fieldType) {
        mainLayout.getMainqmltype().trayMenuAdd(txt, passwd, fieldType);
    }

    onMenubarCommStrChanged: {


        let action = menubarCommStr.split(" ")[0];
        if (action==="addItemAct"){
            isShowSettings = false
            isShowSearch = false
            isShowLog = false
            columnLayoutHomeId.toolbarId.currentIndex = 1            
        }
        if(Boolean(nearestGpg)){
            if (action==="uploadFileAct"){
                columnLayoutHomeId.addComponentId.fileDialogUpload.open()
            }
            if (action==="uploadFolderAct"){
                columnLayoutHomeId.addComponentId.folderDialogUpload.open()
            }
            if (action==="downloadFolderAct"){
                columnLayoutHomeId.editComponentId.folderDialogDownload.open();
            }
        }
        if (isGpgFile && action==="downloadFileAct"){
            columnLayoutHomeId.editComponentId.fileDialogDownload.open()
        }







    }

    onFilePathChanged: {
        initOnFileChanged();
    }

    onExceptionCounterChanged: {
        isShowLog = Boolean(exceptionCounter);
        if (isShowLog){
            showLogText = exceptionStr;
        } else {
            showLogText = ""
        }
    }


    SearchComponent {
        id: searchComponentID
    }

    SHowSettingsComponent {
        id: showSettingsComponentId
    }

    Component {
        id: delayCallerComponent
        Timer {
        }
    }

    function delaySetTimeOut( interval, callback ) {
        var delayCaller = delayCallerComponent.createObject( null,
                { "interval": interval, "repeat": false } );
        delayCaller.triggered.connect( function () {
            callback();
            delayCaller.destroy();
        } );
        delayCaller.start();
    }


    function refreshToolBar(){
        //walkaround "Qt Quick Layouts: Polish loop detected. Aborting after two iterations."
        delaySetTimeOut(100, function() {
            let i = columnLayoutHomeId.toolbarId.currentIndex
            columnLayoutHomeId.toolbarId.currentIndex = 4;
            columnLayoutHomeId.toolbarId.currentIndex = i;
        })


    }

    function notifyStr(str, withTimeout=false){
        statusLabelId.text = str
        if (withTimeout){
            delaySetTimeOut(1000, function() {
                statusLabelId.text = ""
            })
        }


    }

    ColumnLayout {
        width: parent.width
        height : parent.height
        Layout.fillWidth: true
        visible: !isShowLog && !isShowSettings && !isShowSearch;
        RowLayout{
            Button {
                onClicked: { mainLayout.toggleFilepan()}
                icon.name: "Hide/Show treeview"
                icon.source: Qt.resolvedUrl("icons/account_tree_FILL0_wght400_GRAD0_opsz48.svg")
                ToolTip.visible: hovered
                ToolTip.text: "Hide/Show treeview"
            }
            Button {
                onClicked: { mainLayout.getMainqmltype().openStoreInFileBrowser(fullPathFolder)}
                icon.name: "Open store in file browser"
                icon.source: Qt.resolvedUrl("icons/store_FILL0_wght400_GRAD0_opsz48.svg")
                ToolTip.visible: hovered
                ToolTip.text: "Open store in file browser"
            }
            Button {
                onClicked: {
                    isShowSettings = true

                }
                icon.name: "Settings"
                icon.source: Qt.resolvedUrl("icons/settings_FILL0_wght400_GRAD0_opsz48.svg")
                ToolTip.visible: hovered
                ToolTip.text: "Settings"
            }
            Button {
                onClicked: {
                    isShowSearch = true                    
                }

                icon.name: "search"
                icon.source: Qt.resolvedUrl("icons/search_FILL0_wght400_GRAD0_opsz48.svg")
                ToolTip.visible: hovered
                ToolTip.text: "search"

            }
            Label {
                id: statusLabelId
                text: ""
                Layout.alignment: Qt.AlignRight

            }
        }
        Row{
            Rectangle {
                color: "white"
                width: parent.parent.parent.parent.width - 20
                height: 2
            }
        }
        ColumnLayoutHome {
            id: columnLayoutHomeId
        }
    }
    ColumnLayout {
        width: parent.width
        ExceptionAndLog {
            showLog: isShowLog
            logText: showLogText

        }
    }




}

