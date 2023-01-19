import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import DropdownWithList

Item {


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







    ColumnLayout {
        anchors.fill: parent
        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
        }

        Text {
            text: "<h1>Manage .gpg-id<h1>"
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
