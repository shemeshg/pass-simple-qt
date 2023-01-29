import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias decryptedTextId: decryptedTextId


    Text {
        visible: isGpgFile
        text: "<h1>Edit<h1>"
    }
    Row{
        visible: isGpgFile
        Switch {
            id: isPreviewId
            text: qsTr("Preview")
            checked: isShowPreview
            onCheckedChanged: {
                isShowPreview = isPreviewId.checked
                if(classInitialized){
                    initOnFileChanged();
                }
            }
        }
        Button {
            text: "Save"
            enabled: hasEffectiveGpgIdFile;
            onClicked:{
                mainLayout.encrypt(decryptedTextId.textEdit.text)
            }
            visible: isShowPreview
        }
        Button {
            text: "Open"
            enabled: hasEffectiveGpgIdFile;
            onClicked: {
                if (selectExternalEncryptDestinationId.currentValue === "code --wait"){
                    mainLayout.openExternalEncryptWait();
                } else if (selectExternalEncryptDestinationId.editText === "File browser"){
                    mainLayout.openExternalEncryptNoWait();
                }


            }
            visible: !isShowPreview &&
                     waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }
        Button {
            text: "Close File browser item"
            onClicked: {
                mainLayout.closeExternalEncryptNoWait();
            }
            visible: !isShowPreview && noneWaitItems.indexOf(filePath) > -1
        }


        ComboBox {
            id: selectExternalEncryptDestinationId
            model: ["code --wait", "File browser"]
            width: 200
            visible: !isShowPreview &&
                     waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }
    }
    Row{
        visible: isGpgFile
        TextEditComponent {
            id: decryptedTextId
            visible: isShowPreview
             width: scrollViewId.width - 20
        }



    }


}
