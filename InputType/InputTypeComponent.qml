import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore
import Datetime
import InputType

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
        } else if (!getMainqmltype().fileExists(fullPathFolder, link)) {
            return false
        } else {
            return true
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
            visible: (inputType === "textedit" && !showMdId.checked)
                     || (inputType === "texteditMasked"
                         && isTexteditMasked === false && !showMdId.checked)
            text: inputText
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                textChangedSignal(textEditComponentId.text)
                inputText = textEditComponentId.text
                if (isKeyPressed) {
                    notifyStr("*")
                    isKeyPressed = false
                }
            }
            Keys.onPressed: event => {
                                isKeyPressed = true
                            }
            onSelectedTextChanged: {
                getMainqmltype().selectedText = selectedText
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
                notifyStr("*")
            }

            Layout.fillWidth: true
            echoMode: (inputType === "totp"
                       || inputType === "password") ? TextInput.Password : TextInput.Normal
            rightPadding: 8
        }
        CoreTextField {
            text: totpText
            readOnly: true
            visible: inputType === "totp"
        }
        CoreButton {
            text: "@"
            visible: inputType === "url" && textField.text !== ""
            onClicked: doUrlRedirect(inputText)
        }

        CoreButton {
            visible: inputType === "url" && isValidFileRedirect(textField.text)
            onClicked: () => {
                           editComponentId.fileUrlDialogDownload.downloadFrom = textField.text
                           editComponentId.fileUrlDialogDownload.open()
                       }
            icon.name: "Download file"
            hooverText: "Download file"
            icon.source: Qt.resolvedUrl(
                             "icons/outline_file_download_black_24dp.png")
        }
        CoreButton {
            visible: inputType === "url" && textField.text === ""
            onClicked: () => {
                           mainLayout.getMainqmltype().mainUiDisable()
                           urlfileDialogUrlField.inField = textField
                           urlfileDialogUrlField.open()
                       }
            icon.name: "Upload file"
            hooverText: "Upload file"
            icon.source: Qt.resolvedUrl(
                             "icons/outline_file_upload_black_24dp.png")
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
