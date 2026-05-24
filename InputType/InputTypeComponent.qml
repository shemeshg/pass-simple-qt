import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore
import Datetime
import InputType
import QmlApp


ColumnLayout {
    id: columnLayoutId
    property string inputType: "" //totp,url,text,textedit
    property string inputText: ""
    property string totpText: ""
    signal textChangedSignal(string s)

    property bool isTexteditMasked: true

    function isValidFileRedirect(link) {
        if (link.length === 0) {
            return false
        } else if (link.includes("://")) {
            return false
        } else if (link.startsWith("/")) {
            return false
            //only relative path allowed
        } else if (!getIsBinary(link + ".gpg")) {
            return false
        } else if (!fileExists(QmlAppSt.fullPathFolder, link)) {
            return false
        } else {
            return true
        }
    }


    CoreDialogYesNo {
        id: renameYesNo
        title: "Set  name"
        implicitWidth: parent.width
        property string orgRefFullPath: "";
        property string refRelFolder: "";

        CoreTextField {
            id: fieldName
            text: ""
            width: parent.width
            focus: true
        }

        onOpened: {
            let orgRef = inputText;
            let orgRefAry = orgRef.split('/')
            let orgFileName = orgRefAry.pop()
            refRelFolder = orgRefAry.join('/')

            orgRefFullPath = QmlAppSt.fullPathFolder + '/' + orgRef + '.gpg';
            fieldName.text = orgFileName
        }
        onAccepted: {

            let moveFrom = orgRefFullPath
            let moveTo = orgRefFullPath.split('/').slice(0, -1).join('/') + '/' + fieldName.text + '.gpg'

            let newRefPath = refRelFolder + '/' + fieldName.text
            console.log("from: " + moveFrom)
            console.log("to: " + moveTo)
            console.log("inputText will be set to " + newRefPath)


        }
    }

    CoreDialogYesNo {
        id: deleteYesNo
        title: "Confirm"
        implicitWidth: parent.width
        implicitHeight: QmlAppSt.mainqmltype.appSettingsType.fontSize * 10

        CoreLabel{
            text: "Delete reference file, \n" + inputText + "\n and clear input field?"
            width: parent.width
        }

        onOpened: {
        }
        onAccepted: {
            let orgRefFullPath = QmlAppSt.fullPathFolder + '/' + inputText + '.gpg';
            console.log("delete:" + orgRefFullPath)
            console.log("set inputText to empty")
        }
    }



    InputTypeType {
        id: inputTypeType
    }

    RowLayout {

        visible: inputType === "datetime"
        DatetimeComponent {
            datetimeStr: inputText
            onDatetimeChanged: text => {
                                   if (inputType === "datetime") {
                                       textChangedSignal(text)
                                   }
                               }
        }
        Item {
            height: 2
            width: 15
        }
    }

    RowLayout {
        LayoutMirroring.enabled: textEditComponentId.horizontalAlignment === Text.AlignRight
        Item {
            height: 2
            width: 15
            visible: textEditComponentId.horizontalAlignment === Text.AlignRight
        }
        CoreTextArea {
            visible: (inputType === "textedit" || inputType === "texteditMasked"
                      && isTexteditMasked === false) && showMdId.checked
            readOnly: true
            text: inputText
            textFormat: TextEdit.MarkdownText
            wrapMode: TextEdit.WrapAnywhere
            Layout.fillWidth: true
        }

        CoreTextArea {
            property bool isKeyPressed: false
            Layout.fillWidth: true
            id: textEditComponentId
            useMonospaceFont: QmlAppSt.mainqmltype.appSettingsType.useMonospaceFont
            visible: (inputType === "textedit" && !showMdId.checked)
                     || (inputType === "texteditMasked"
                         && isTexteditMasked === false && !showMdId.checked)
            text: inputText
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                textChangedSignal(textEditComponentId.text)
                inputText = textEditComponentId.text
                if (isKeyPressed) {
                    setNotifyBodyContentModified(true)
                    isKeyPressed = false
                }
            }
            Keys.onPressed: event => {
                                isKeyPressed = true
                            }
            onSelectedTextChanged: {
                selectedTextSignal(selectedText)
            }
        }
        Label {
            padding: 8
            Layout.fillWidth: true
            text: "*********"
            horizontalAlignment: textEditComponentId.horizontalAlignment
                                 === Text.AlignRight ? Text.AlignRight : Text.AlignLeft
            visible: inputType === "texteditMasked" && isTexteditMasked
        }

        CoreButton {
            Layout.alignment: Qt.AlignTop
            text: "*"
            visible: inputType === "texteditMasked"
            onClicked: {
                isTexteditMasked = !isTexteditMasked
            }
        }
        Item {
            height: 2
            width: 15
            visible: textEditComponentId.horizontalAlignment !== Text.AlignRight
        }
    }

    RowLayout {
        visible: inputType === "text" || inputType === "url"
                 || inputType === "totp" || inputType === "password"
        LayoutMirroring.enabled: textField.horizontalAlignment === Text.AlignRight
        Timer {
            interval: 100
            running: inputType === "totp"
            repeat: true
            onTriggered: totpText = inputTypeType.getTotp(inputText)
        }
        Item {
            height: 2
            width: 15
            visible: textField.horizontalAlignment === Text.AlignRight
        }
        CoreTextField {
            id: textField
            text: inputText
            onTextChanged: {
                textChangedSignal(text)
                textEditComponentId.text = text
            }
            onTextEdited: {
                setNotifyBodyContentModified(true)
            }

            Layout.fillWidth: true
            echoMode: (inputType === "totp"
                       || inputType === "password") ? TextInput.Password : TextInput.Normal
            rightPadding: 8
            useMonospaceFont: QmlAppSt.mainqmltype.appSettingsType.useMonospaceFont
                              || (textField.echoMode === TextInput.Normal
                                  && (inputType === "totp"
                                      || inputType === "password"))
        }
        CoreTextField {
            text: totpText
            readOnly: true
            visible: inputType === "totp"
            useMonospaceFont: true
        }
        CoreButton {
            text: "@"
            visible: inputType === "url" && textField.text !== ""
            onClicked: doUrlRedirect(inputText)
        }

        CoreButton {
            visible: inputType === "url" && isValidFileRedirect(textField.text)
            MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                onClicked: mouse => {
                               if (mouse.button === Qt.RightButton) {
                                   menu.open()
                               } else if (mouse.button === Qt.LeftButton) {

                                   editComponentId.fileUrlDialogDownload.downloadFrom = textField.text
                                   editComponentId.fileUrlDialogDownload.open()
                               }
                           }
            }
            icon.name: "Download file"
            hooverText: "Download file <br/> R.Click for delelete or rename ref. file"
            icon.source: Qt.resolvedUrl(
                             "icons/outline_file_download_black_24dp.png")


            Menu {
                id: menu


                MenuItem {

                    onClicked: {
                        deleteYesNo.open()
                    }

                    text: "Delete"
                }
                MenuItem {
                    onClicked: {
                        renameYesNo.open()
                    }
                    text: "Rename"
                }
            }

        }
        CoreButton {
            visible: inputType === "url" && textField.text === ""
            onClicked: () => {
                           QmlAppSt.mainqmltype.mainUiDisable()
                           urlfileDialogUrlField.inField = textField
                           urlfileDialogUrlField.open()
                       }
            icon.name: "Upload file"
            hooverText: "Upload file"
            icon.source: Qt.resolvedUrl(
                             "icons/outline_file_upload_black_24dp.png")
            icon.color: CoreSystemPalette.buttonText
            palette.buttonText: CoreSystemPalette.buttonText
        }
        CoreButton {
            text: "*"
            visible: inputType === "totp" || inputType === "password"
            onClicked: {
                if (textField.echoMode === TextInput.Normal) {
                    textField.echoMode = TextInput.Password
                } else {
                    textField.echoMode = TextInput.Normal
                }
            }
        }
        Item {
            height: 2
            width: 15
            visible: textField.horizontalAlignment !== Text.AlignRight
        }
    }
}
