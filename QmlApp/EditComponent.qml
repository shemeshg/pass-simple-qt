import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform

import DropdownWithList
import EditYaml


ColumnLayout {
    property bool showYamlEdit: true
    property alias folderDialogDownload: folderDialogDownload
    property alias fileDialogDownload: fileDialogDownload
    property string decryptedText: ""
    property bool isSaving: false

    onDecryptedTextChanged: {
        loaderShowYamlEditComponent.editYamlType.text = decryptedText;
    }


    function setLoaderShowYamlEditComponent(){        
        if (isGpgFile && isShowPreview && showYamlEdit){
            loaderShowYamlEditComponent.sourceComponent = doShowYamlEditComponent;
        } else if (isGpgFile && isShowPreview && !showYamlEdit) {
            loaderShowYamlEditComponent.sourceComponent = dontShowYamlEditComponent;
        } else {
            loaderShowYamlEditComponent.sourceComponent = undefined
        }
    }

    function preferYamlIfYamlIsValidOnFileChange(){        
        var doLoaderShowYamlCreation = true;
        if ( isPreviewId && isPreviewId.checked) {
            if(
                    (loaderShowYamlEditComponent.editYamlType.isYamlValid &&
                     !isYamlShow.checked) ||
                    (!loaderShowYamlEditComponent.editYamlType.isYamlValid &&
                     isYamlShow.checked)){

                isYamlShow.checked = !isYamlShow.checked
                doLoaderShowYamlCreation = false
            }
        }
        if(doLoaderShowYamlCreation){
            setLoaderShowYamlEditComponent();
        }
    }

    function doShowYAML(){
        if (!showYamlEdit && loaderShowYamlEditComponent.editYamlType.isYamlValid){
            decryptedText = loaderShowYamlEditComponent.editYamlType.getUpdatedText()
        }
        if (isGpgFile){
            setLoaderShowYamlEditComponent();
        }
        refreshToolBar(); //Walk around Bug on linux only
    }

    function doExternalOpen(){
        if (selectExternalEncryptDestinationId.currentValue === "code --wait"){
            mainLayout.openExternalEncryptWait();
        } else if (selectExternalEncryptDestinationId.editText === "File browser"){
            mainLayout.openExternalEncryptNoWait();
        }
    }



    RenameDialog {
        id: renameDialog
    }


    FolderDialog {
        id: fileDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            var filename = filePath.replace(/^.*[\\\/]/, '')
            filename = filename.substr(0,filename.length-4)
            getMainqmltype().decryptDownload(fileDialogDownload.folder + "/" +  filename)
        }
        onRejected: {
        }
    }


    FolderDialog {
        id: folderDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptFolderDownload(fullPathFolder, folderDialogDownload.folder)
        }
        onRejected: {
        }
    }

    RowLayout {
        width: parent.width
        Text {
            visible: isGpgFile
            text: "<h1>Edit<h1>"
            Layout.fillWidth: true
        }
        Item {
            Layout.fillWidth: true
        }

        Button {
            visible: isGpgFile
            text: "download file"
            enabled: isGpgFile
            onClicked: {
                fileDialogDownload.open()
            }
            rightPadding: 8
        }
        Button {
            visible: Boolean(nearestGpg)
            text: "download folder content"
            onClicked: {
                onClicked: {
                    folderDialogDownload.open();
                }
            }
            rightPadding: 8
        }
    }
    RowLayout {
        Text {
            visible: isGpgFile
            text: "<h2>" +
                  filePath.replace(fullPathFolder,"").substring(1,filePath.replace(fullPathFolder,"").length-4) +
                  "</h2>"
            Layout.fillWidth: true
        }
        Button {
            visible: isGpgFile
            onClicked: ()=>{
                           renameDialog.open();
                       }
            icon.name: "Save and Rename"
            ToolTip.text: "Save and Rename"
            icon.source: Qt.resolvedUrl("icons/edit_FILL0_wght400_GRAD0_opsz48.svg")
            ToolTip.visible: hovered
        }

    }

    RowLayout {
        visible: waitItems.indexOf(filePath) > -1 ||
                 noneWaitItems.indexOf(filePath) > -1
        Text {
            text: "File opened externally"
        }
    }

    RowLayout{

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
                if (isGpgFile){
                    setLoaderShowYamlEditComponent();
                }


                refreshToolBar(); //Walk around Bug on linux only
            }
            visible: waitItems.indexOf(filePath) === -1 &&
                     noneWaitItems.indexOf(filePath) === -1
        }

        Shortcut {
            sequence: "Ctrl+M"
            onActivated: {
                if ( isPreviewId.checked && editComponentId.visible &&
                       !showYamlEdit ){
                    showMdId.checked = !showMdId.checked
                }
            }
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
            enabled: hasEffectiveGpgIdFile && (!showYamlEdit || showYamlEdit &&
                   loaderShowYamlEditComponent.editYamlType.isYamlValid) && !isSaving
            onClicked:{
                if (showYamlEdit){
                    decryptedText = loaderShowYamlEditComponent.editYamlType.getUpdatedText()
                }
                isSaving = true
                mainLayout.encrypt(decryptedText)
                notifyStr("* Saved", true,()=>{
                          isSaving=false;
                          })
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
        Item {
            height: 2
            width: 2
            Layout.fillWidth: true
            visible: !showYamlEdit && isShowPreview
        }
        Switch {
            id: showMdId
            checked: false
            text: qsTr("<u>M</u>↓")
            visible: !showYamlEdit && isShowPreview
        }


    }


    Loader {
        id: loaderShowYamlEditComponent
        width: parent.width
        height: parent.height
        Layout.fillWidth: true
        Layout.fillHeight: true
        property alias editYamlType: editYamlType
        EditYamlType {
            id: editYamlType
            onYamlModelChanged: {
                clearSystemTrayIconEntries()
                for(var idx in yamlModel){
                    addSystemTrayIconEntries(yamlModel[idx].key,
                                             yamlModel[idx].val,
                                             yamlModel[idx].inputType)
                }
            }
        }
    }

    Component {
        id: doShowYamlEditComponent

        Row {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: isGpgFile
            EditYamlComponent {
                id: editYamlComponentId
                visible: isGpgFile && isShowPreview && showYamlEdit
                width: parent.width
                height: parent.height
            }
        }
    }

    Component {
        id: dontShowYamlEditComponent

        ScrollView {
            ToolTip {
                id: toolTip
            }

            HoverHandler {
                id: hoverHandler
                onHoveredChanged: {
                    if (hovered)
                        toolTip.hide()
                }
            }

            height: parent.height
            width: parent.width
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                width: parent.width
                height: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: showMdId.checked ? mdDecryptedTextIdComponent : decryptedTextIdComponent

            }


            Component {
                id:mdDecryptedTextIdComponent

                TextEdit {
                    id: mdDecryptedTextId

                    width: parent.width
                    height: parent.height
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    text: decryptedText
                    readOnly: true
                    visible: showMdId.checked
                    textFormat: TextEdit.MarkdownText
                    onLinkActivated: (link)=>{
                                         doUrlRedirect(link);}
                    onLinkHovered: (link) => {
                                       if (link.length === 0)
                                       return

                                       // Show the ToolTip at the mouse cursor, plus some margins so the mouse doesn't get in the way.
                                       toolTip.x = hoverHandler.point.position.x + 8
                                       toolTip.y = hoverHandler.point.position.y + 8
                                       toolTip.show(link,3000)
                                   }
                }
            }

            Component {
                id: decryptedTextIdComponent
                TextArea {
                    id: decryptedTextId
                    text: decryptedText
                    font.family: getMainqmltype().fixedFont
                    width: parent.width
                    height: parent.height
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: "Enter text here, YAML can not start with '-' or '#'"
                    placeholderTextColor: "black"
                    onSelectedTextChanged: {
                        getMainqmltype().selectedText = selectedText
                    }
                    visible: !showMdId.checked
                    onTextChanged: {
                        decryptedText = text
                    }
                }
            }
        }
    }



}
