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


    onFilePathChanged: {
        decryptedTextId.text = mainLayout.getDecrypted();
        nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
        getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
        badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
        dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
        dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
    }

    anchors.fill: parent
    width: parent.width
    height : parent.height
    contentWidth: column.width    // The important part
    contentHeight: column.height  // Same
    clip : true                   // Prevent drawing column outside the scrollview borders

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            console.log("Selected" + fileDialog.selectedFile )
            /*
             1. Import
             2.
            badEntriesRepeater.model = mainLayout.getGpgIdManageType().keysNotFoundInGpgIdFile
            dropdownWithListComponentId.allItems = mainLayout.getGpgIdManageType().allKeys
            dropdownWithListComponentId.selectedItems = mainLayout.getGpgIdManageType().keysFoundInGpgIdFile
             */
        }
        onRejected: {
        }
        //Component.onCompleted: visible = true
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
            text: "<h1>Manage .gpg-id<h1>"
        }

        Button {
            text: "Import and trust a new public key"
            onClicked: { fileDialog.open()}
        }
        Button {
            text: "Import all public keys in .gpg-pub-keys/"
        }
        Button {
            text: "Recreate.gpg-pub-keys/ \n Save changes to .gpg-id \n Re-encrypt all .gpg-id related files"
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
        Text {
            text: "<h1>Encrypted text<h1>"
        }
        Text {
            id: decryptedTextId
            text:""
        }
    }
}

