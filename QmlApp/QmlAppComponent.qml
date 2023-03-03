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

    function refreshToolBar(){
        //walkaround "Qt Quick Layouts: Polish loop detected. Aborting after two iterations."
        delaySetTimeOut(100, function() {
            if (!columnLayoutHomeId){return;}
            let i = columnLayoutHomeId.toolbarId.currentIndex
            columnLayoutHomeId.toolbarId.currentIndex = 4;
            columnLayoutHomeId.toolbarId.currentIndex = i;
        })


    }

    Component.onCompleted:{
        mainLayout.getMainqmltype().initGpgIdManage();
        allPrivateKeys = mainLayout.getGpgIdManageType().allPrivateKeys;
        getMainqmltype().filePath = passwordStorePathStr;
        refreshToolBar();

    }

    function initOnFileChanged(){
        clearSystemTrayIconEntries();
        if (isShowPreview){
            columnLayoutHomeId.editComponentId.decryptedTextId.text = mainLayout.getDecrypted();
        }

        columnLayoutHomeId.metaDataComponentId.nearestGit = mainLayout.getNearestGit();
        columnLayoutHomeId.addComponentId.nearestTemplateGpg = mainLayout.getNearestTemplateGpg();
        nearestGpg = mainLayout.getNearestGpgId();
        fullPathFolder = getMainqmltype().getFullPathFolder();
        hasEffectiveGpgIdFile = Boolean(mainLayout.getNearestGpgId());
        isGpgFile = filePath.slice(-4)===".gpg";
        columnLayoutHomeId.metaDataComponentId.getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
        columnLayoutHomeId.metaDataComponentId.gitResponseId.text = ""
        columnLayoutHomeId.manageGpgIdComponentId.badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
        classInitialized = mainLayout.getGpgIdManageType().classInitialized
        gpgPubKeysFolderExists = mainLayout.getGpgIdManageType().gpgPubKeysFolderExists

        if (showSettingsComponentId.isPreferYamlView){
            columnLayoutHomeId.editComponentId.preferYamlIfYamlIsValidOnFileChange()
        }

        notifyStr("")
        refreshToolBar()

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
            exceptionAndLogId.logTextId.textEdit.text = exceptionStr;
        } else {
            exceptionAndLogId.logTextId.textEdit.text = "";
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
                icon.source: "icons/icons8-tree-structure-80.png"
                ToolTip.visible: hovered
                ToolTip.text: "Hide/Show treeview"
            }
            Button {
                onClicked: { mainLayout.getMainqmltype().openStoreInFileBrowser(fullPathFolder)}
                icon.name: "Open store in file browser"
                icon.source: "icons/icons8-shop-80.png"
                ToolTip.visible: hovered
                ToolTip.text: "Open store in file browser"
            }
            Button {
                onClicked: {
                    isShowSettings = true

                }
                icon.name: "Settings"
                icon.source: "icons/icons8-automation-50.png"
                ToolTip.visible: hovered
                ToolTip.text: "Settings"
            }
            Button {
                onClicked: {
                    isShowSearch = true                    
                }

                icon.name: "search"
                icon.source: "icons/icons8-search-more-50"
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
            id: exceptionAndLogId
        }
    }




}

