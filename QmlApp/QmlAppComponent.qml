import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls

Item {
    property int filePanSize: 0
    property string filePath: ""
    property string decryptedText: ""
    property string nearestGit: ""
    property string nearestGpgId: ""

    onFilePathChanged: {
        decryptedTextId.text = mainLayout.getDecrypted();
        nearestGitId.text = "Git : " + mainLayout.getNearestGit();
        nearestGpgIdId.text = "GpgId : " + mainLayout.getNearestGpgId();
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: nameId
            text:"File : " + filePath
        }
        Text {
            id: nearestGitId
            text:"Git : " + nearestGit
        }
        Text {
            id: nearestGpgIdId
            text:"GpgId : " + nearestGpgId
        }
        Text {
            id: decryptedTextId
            text:""
        }


        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
        }
    }
}
