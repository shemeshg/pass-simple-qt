import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ScrollView {

    width: parent.width
    height : parent.height
    contentWidth: column.width    // The important part
    contentHeight: column.height  // Same
    clip : true

    property int filePanSize: 0
    property string filePath: ""
    property string tmpShalom: ""
    property bool classInitialized: false
    property bool gpgPubKeysFolderExists: false
    property bool isShowPreview: false

    property var waitItems: []
    property var noneWaitItems: []

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

                 // Prevent drawing column outside the scrollview borders

    FileDialog {
        id: fileDialogImportAndTrustId
        title: "Please choose a .pub file to import and trust"
        onAccepted: {
            mainLayout.getGpgIdManageType().importPublicKeyAndTrust(fileDialogImportAndTrustId.selectedFile);
            initOnFileChanged();
        }
        onRejected: {
        }
    }




    ColumnLayout {
        id: column
        width: parent.width
        Button {
            onClicked: { mainLayout.toggleFilepan()}
            icon.name: "Hide/Show treeview"
            icon.source: "icons/icons8-tree-structure-80.png"
            ToolTip.visible: hovered
            ToolTip.text: "Hide/Show treeview"
        }
        EditComponent {
            id: editComponentId
        }

        ManageGpgIdComponent {
            id: manageGpgIdComponentId
        }

        MetaDataComponent {
            id: metaDataComponentId
        }
    }
}

