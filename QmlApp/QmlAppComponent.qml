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

        metaDataComponentId.nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        metaDataComponentId.nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
        metaDataComponentId.getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
        manageGpgIdComponentId.badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        manageGpgIdComponentId.dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
        manageGpgIdComponentId.dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
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




    ExceptionAndLog {
        id: exceptionAndLogId
    }

    ColumnLayoutHome {
        id: columnLayoutHomeId
    }
}

