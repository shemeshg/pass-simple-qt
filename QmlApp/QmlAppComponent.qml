import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ScrollView {
    id: scrollViewId
    width: parent.width
    height : parent.height
    contentWidth: columnLayoutHomeId.width    // The important part
    contentHeight: columnLayoutHomeId.height  // Same
    clip : true

    property int filePanSize: 0
    property int exceptionCounter: 0
    property string exceptionStr: ""
    property string filePath: ""
    property string tmpShalom: ""
    property bool classInitialized: false
    property bool gpgPubKeysFolderExists: false
    property bool isShowPreview: false

    property var waitItems: []
    property var noneWaitItems: []

    property bool isShowLog: false
    property string showLogText: ""

    function initOnFileChanged(){
        if (isShowPreview){
            editComponentId.decryptedTextId.text = mainLayout.getDecrypted();
        }

        columnLayoutHomeId.metaDataComponentId.nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        columnLayoutHomeId.metaDataComponentId.nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
        columnLayoutHomeId.metaDataComponentId.getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
        columnLayoutHomeId.manageGpgIdComponentId.badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
        columnLayoutHomeId.manageGpgIdComponentId.dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
        classInitialized = mainLayout.getGpgIdManageType().classInitialized
        gpgPubKeysFolderExists = mainLayout.getGpgIdManageType().gpgPubKeysFolderExists
    }

    onFilePathChanged: {
        initOnFileChanged();
    }

    onExceptionCounterChanged: {
        isShowLog = Boolean(exceptionCounter);
        if (isShowLog){
            showLogText = exceptionStr;
        } else {
            showLogText = "";
        }
    }


    ColumnLayout {
        width: parent.width
        Layout.fillWidth: true
        visible: !isShowLog;
        RowLayout{
            Button {
                onClicked: { mainLayout.toggleFilepan()}
                icon.name: "Hide/Show treeview"
                icon.source: "icons/icons8-tree-structure-80.png"
                ToolTip.visible: hovered
                ToolTip.text: "Hide/Show treeview"
            }
            Button {
                onClicked: { mainLayout.openStoreInFileBrowser()}
                icon.name: "Open store in file browser"
                icon.source: "icons/icons8-shop-80.png"
                ToolTip.visible: hovered
                ToolTip.text: "Open store in file browser"
            }
            Button {
                onClicked: {}
                icon.name: "Settings"
                icon.source: "icons/icons8-automation-50.png"
                ToolTip.visible: hovered
                ToolTip.text: "Settings"
            }
        }
        Row{
            Rectangle {
                id: rectId
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

