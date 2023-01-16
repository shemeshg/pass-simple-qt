import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import DropdownWithList

Item {
    property int filePanSize: 0
    property string filePath: ""


    onFilePathChanged: {
        decryptedTextId.text = mainLayout.getDecrypted();
        nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
        getDecryptedSignedById.text = "DecryptedSignedBy : " + mainLayout.getDecryptedSignedBy()
    }





    ColumnLayout {
        anchors.fill: parent

        DropdownWithListComponent {
            id: asdfasdf
        }


        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
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
            id: decryptedTextId
            text:""
        }


    }

}
