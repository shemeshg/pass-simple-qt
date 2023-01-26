import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias decryptedTextId: decryptedTextId

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
                if(classInitialized){
                    initOnFileChanged();
                }
            }
        }
        Button {
            text: "Save"
            onClicked:{
                mainLayout.encrypt(decryptedTextId.text)
            }
            visible: isShowPreview
        }
        Button {
            text: "Open"
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
        Rectangle {
            visible: isShowPreview
            color: "white"
            width: scrollViewId.width - 20
            height: decryptedTextId.height
             TextEdit {
                 id: decryptedTextId
                 text:""
                 width: parent.width
             }
        }



    }


}
