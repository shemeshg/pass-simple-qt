import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property string nearestGit: ""
    property alias getDecryptedSignedById: getDecryptedSignedById
    property alias gitResponseId: gitResponseId

    Text {
        text: "<h1>Meta data<h1>"
    }

    Text {
        id: nameId
        text:"File : " + filePath
    }
    Text {
        text:"Git : " + nearestGit
    }
    RowLayout{
        Button{
            text: "status"
            enabled: nearestGit
            onClicked: {
                let s= getMainqmltype().runCmd([mainLayout.getMainqmltype().appSettingsType.gitExecPath,"-C",nearestGit,"status"]," 2>&1");
                gitResponseId.text = s;
            }
        }
        Button{
            text: "add commit all"
            enabled: nearestGit
            onClicked: {
                let addAll= getMainqmltype().runCmd([mainLayout.getMainqmltype().appSettingsType.gitExecPath,"-C",nearestGit,"add","."]," 2>&1");
                let commitAm= getMainqmltype().runCmd([mainLayout.getMainqmltype().appSettingsType.gitExecPath,"-C",nearestGit,"commit","-am","pass simple"]," 2>&1");
                gitResponseId.text = "Add:\n" + addAll + "\n" +"Commit:\n"+ commitAm;
            }
        }
        Button{
            text: "pull push"
            enabled: nearestGit
            onClicked: {

                let pull= getMainqmltype().runCmd([mainLayout.getMainqmltype().appSettingsType.gitExecPath,"-C",nearestGit,"pull"]," 2>&1");
                let push= getMainqmltype().runCmd([mainLayout.getMainqmltype().appSettingsType.gitExecPath,"-C",nearestGit,"push"]," 2>&1");
                gitResponseId.text = "Pull:\n"+ pull + "\nPush:\n" + push;
            }
        }

    }
    TextArea {
        id: gitResponseId
        Layout.fillWidth: true;
        readOnly: true
    }

    Text {
        id: nearestGpgIdId
        text:"GpgId : " + nearestGpg
    }
    Text {
        id: getDecryptedSignedById
        text:"DecryptedSignedBy : "
    }
    Text {
        text:"<h2>Wait Items</h2>" 
    }
    Repeater {
        model: waitItems
        RowLayout{
            Label {
                text:  modelData

            }
            Button {
                text: "select"
                onClicked: getMainqmltype().setTreeViewSelected(modelData)
            }

        }
    }

    Text {
        text:"<h2>None Wait Items</h2>" 
    }
    Repeater {
        model: noneWaitItems
        RowLayout{
            Label {
                text:  modelData

            }
            Button {
                text: "select"
                onClicked: getMainqmltype().setTreeViewSelected(modelData)
            }

        }
    }    
}
