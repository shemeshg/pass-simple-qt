import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ScrollView {
    property int filePanSize: 0
    property string filePath: ""
    property string tmpShalom: ""
    property bool classInitialized: false
    property bool gpgPubKeysFolderExists: false
    property bool isShowPreview: false


    function initOnFileChanged(){
        if (isShowPreview){
            decryptedTextId.text = mainLayout.getDecrypted();
        }


        nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
        getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
        badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
        dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
        classInitialized = mainLayout.getGpgIdManageType().classInitialized
        gpgPubKeysFolderExists = mainLayout.getGpgIdManageType().gpgPubKeysFolderExists
    }

    onFilePathChanged: {
      initOnFileChanged();
    }

    anchors.fill: parent
    width: parent.width
    height : parent.height
    contentWidth: column.width    // The important part
    contentHeight: column.height  // Same
    clip : true                   // Prevent drawing column outside the scrollview borders

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

    Column {
        id: column
        //anchors.fill: parent
        width: parent.width
        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
        }

        Text {
            text: "<h1>Encrypted text<h1>"
        }
        Row{
            Switch {
                id: isPreviewId
                text: qsTr("Preview")
                checked: isShowPreview
                onCheckedChanged: {
                    isShowPreview = isPreviewId.checked
                    initOnFileChanged();
                }
            }
            Button {
                text: "Save"
                onClicked: {
                }
            }
            ComboBox {
                model: ["Internal", "External", "External No Wait"]
            }
        }
        TextArea {
            id: decryptedTextId
            text:""
            visible: isShowPreview


        }
        Text {
            text: "<h1>Manage .gpg-id<h1>"
        }

        Button {
            text: "Import and trust a new public key"
            enabled: classInitialized
            onClicked: { fileDialogImportAndTrustId.open()}
        }
        Button {
            text: "Import all public keys in .gpg-pub-keys/"
            enabled: classInitialized && gpgPubKeysFolderExists
            onClicked: {
                mainLayout.getGpgIdManageType().importAllGpgPubKeysFolder();
                initOnFileChanged();
            }
        }
        Button {
            enabled: classInitialized && gpgPubKeysFolderExists && badEntriesRepeater.model.length === 0
                        && dropdownWithListComponentId.selectedItems.length > 0
            text: "Save changes to .gpg-id \n Recreate.gpg-pub-keys/ \n Re-encrypt all .gpg-id related files"
            onClicked: {
                mainLayout.getGpgIdManageType().saveChanges(dropdownWithListComponentId.selectedItems);
                initOnFileChanged();
            }
        }
        Text {
            text: "<h2>Bad .gpg-id entries<h2>"
        }

        Repeater {
            id: badEntriesRepeater
            model: []
            RowLayout{
                Label {
                    text:  modelData
                }
            }
        }


        DropdownWithListComponent {
            id: dropdownWithListComponentId
        }


        Text {
            text: "<h1>Meta data<h1>"
        }

        Text {
            id: nameId
            text:"File : " + filePath
        }
        Text {
            id: nearestGitId
            text:"Git : "
        }
        Text {
            id: nearestGpgIdId
            text:"GpgId : "
        }
        Text {
            id: getDecryptedSignedById
            text:"DecryptedSignedBy : "
        }

    }
}

