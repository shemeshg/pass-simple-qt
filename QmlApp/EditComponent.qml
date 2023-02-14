import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList
import EditYaml

ColumnLayout {
    property alias decryptedTextId: decryptedTextId
    property bool showYamlEdit: true

    function doShowYAML(){
        if (!showYamlEdit && editYamlComponentId.editYamlType.isYamlValid){
            decryptedTextId.text = editYamlComponentId.editYamlType.getUpdatedText()
        }
    }

    function doExternalOpen(){
        if (selectExternalEncryptDestinationId.currentValue === "code --wait"){
            mainLayout.openExternalEncryptWait();
        } else if (selectExternalEncryptDestinationId.editText === "File browser"){
            mainLayout.openExternalEncryptNoWait();
        }
    }

    FileDialog {
        id: fileDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptDownload(fileDialogDownload.selectedFile)
        }
        onRejected: {
        }
        fileMode: FileDialog.SaveFile

    }

    RowLayout {
        width: parent.width
        Text {
            visible: isGpgFile
            text: "<h1>Edit<h1>"
            Layout.fillWidth: true
        }
        Button {
            visible: isGpgFile
            text: "download"
            enabled: isGpgFile
            onClicked: fileDialogDownload.open()
            rightPadding: 8
        }
    }
    RowLayout {
        visible: waitItems.indexOf(filePath) > -1 ||
                 noneWaitItems.indexOf(filePath) > -1
        Text {
            text: "File opened externally"
        }
    }

    Row{
        Shortcut {
            sequence: "Ctrl+E"
            onActivated: {
                if ( isPreviewId.visible && editComponentId.visible
                        ){
                    isPreviewId.checked = !isPreviewId.checked
                    isShowPreview = isPreviewId.checked
                    if(classInitialized){
                        initOnFileChanged();
                    }

                }
            }
        }

        visible: isGpgFile
        Switch {
            id: isPreviewId
            text: qsTr("Pr<u>e</u>view")
            checked: isShowPreview
            onCheckedChanged: {
                isShowPreview = isPreviewId.checked
                if(classInitialized){
                    initOnFileChanged();
                }
            }
            visible: waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }



        Shortcut {
            sequence: "Ctrl+L"
            onActivated: {
                if ( isPreviewId.checked && editComponentId.visible
                        ){

                    isYamlShow.checked = !isYamlShow.checked
                    showYamlEdit = isYamlShow.checked;
                    doShowYAML()

                }
            }
        }

        Switch {
            id:isYamlShow
            visible: isShowPreview
            text: qsTr("YAM<u>L</u>")
            checked: showYamlEdit
            onCheckedChanged: {
                showYamlEdit = checked;
                doShowYAML();
            }
        }



        Shortcut {
            sequence: StandardKey.Save
            onActivated: {
                if (saveBtnId.visible && saveBtnId.enabled){
                    saveBtnId.clicked()
                }
            }
        }

        Button {
            id: saveBtnId
            text: "&Save"
            enabled: hasEffectiveGpgIdFile && (!showYamlEdit || showYamlEdit && editYamlComponentId.editYamlType.isYamlValid)
            onClicked:{
                if (showYamlEdit){
                    decryptedTextId.text = editYamlComponentId.editYamlType.getUpdatedText()
                }
                mainLayout.encrypt(decryptedTextId.text)
                notifyStr("* Saved")
            }
            visible: isShowPreview

        }



        Shortcut {
            sequence: "Ctrl+O"
            onActivated: {
                if ( editComponentId.visible && !isShowPreview &&
                        waitItems.indexOf(filePath) === -1 &&
                        noneWaitItems.indexOf(filePath) === -1){
                    doExternalOpen()
                }
            }
        }
        Button {
            text: "&Open"
            enabled: hasEffectiveGpgIdFile;
            onClicked: {
                doExternalOpen();
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



    ScrollView {

        visible: isGpgFile && isShowPreview && !showYamlEdit
        height: parent.height
        width: parent.width
        clip: true
        Layout.fillWidth: true
        Layout.fillHeight: true

        TextArea {
            id: decryptedTextId
            width: parent.width
            height: parent.height
            Layout.fillWidth: true
            Layout.fillHeight: true
        }


    }

    Row {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: isGpgFile
        EditYamlComponent {
            id: editYamlComponentId
            visible: isShowPreview && showYamlEdit
            text: decryptedTextId.text
            width: parent.width
            height: parent.height
        }
    }

}
