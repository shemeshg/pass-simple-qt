import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform

import DropdownWithList
import InputType

ScrollView {
    id: scrollViewId
    width: parent.width
    height : parent.height
    contentWidth: columnLayoutHomeId.width    // The important part
    contentHeight: columnLayoutHomeId.height + 90   // Same
    clip : true

    property int filePanSize: 0
    property int exceptionCounter: 0
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

    function initOnFileChanged(){
        clearSystemTrayIconEntries();
        if (isShowPreview){
            columnLayoutHomeId.editComponentId.decryptedTextId.textEdit.text = mainLayout.getDecrypted();
        }

        columnLayoutHomeId.metaDataComponentId.nearestGit = mainLayout.getNearestGit();
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
    }

    SHowSettingsComponent {
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
        }
        Row{
            Rectangle {
                color: "white"
                width: scrollViewId.width - 20
                height: 2
            }
        }
        ColumnLayoutHome {            
            id: columnLayoutHomeId
        }
    }

    ExceptionAndLog {
        id: exceptionAndLogId
    }




}

