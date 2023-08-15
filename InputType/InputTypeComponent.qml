import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform
import InputType
import QmlApp
import Datetime

ColumnLayout {
    id: columnLayoutId
    property string inputType: "" //totp,url,text,textedit
    property string inputText: ""
    property string totpText: ""
    signal textChangedSignal(string s)
    property bool isTexteditMasked: true

    RowLayout {

        FileDialog {
            id: urlfileDialogUrlField

            title: "Choose file to upload"
            fileMode: FileDialog.OpenFile
            onAccepted: {
                urlfileDialogUrlField.files.forEach(f => {
                                                        getMainqmltype(
                                                            ).encryptUpload(
                                                            fullPathFolder, f,
                                                            true)
                                                        let filename = f.toString(
                                                            ).replace(
                                                            /^.*[\\\/]/, '')
                                                        textField.text = "_files/" + filename
                                                    })

                doMainUiEnable()
            }
            onRejected: {
                doMainUiEnable()
            }
        }

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

        TextArea {
            property bool isKeyPressed: false
            Layout.fillWidth: true
            id: textEditComponentId
            visible: inputType === "textedit" || (inputType === "texteditMasked"
                                                  && isTexteditMasked === false)
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
            selectionColor: systemPalette.highlight
            selectedTextColor: systemPalette.highlightedText
        }
        Label {
            padding: 8
            Layout.fillWidth: true
            text: "*********"
            visible: inputType === "texteditMasked" && isTexteditMasked
        }

        Button {
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
        }
    }

    RowLayout {
        visible: inputType === "text" || inputType === "url"
                 || inputType === "totp" || inputType === "password"
        Timer {
            interval: 500
            running: inputType === "totp"
            repeat: true
            onTriggered: totpText = getMainqmltype().getTotp(inputText)
        }
        TextField {
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
        TextField {
            text: totpText
            readOnly: true
            visible: inputType === "totp"
        }
        Button {
            text: "@"
            visible: inputType === "url" && textField.text !== ""
            onClicked: doUrlRedirect(inputText)
        }
        Button {
            visible: inputType === "url" && textField.text === ""
            onClicked: () => {
                           mainLayout.getMainqmltype().mainUiDisable()

                           urlfileDialogUrlField.open()
                       }
            icon.name: "Upload file"
            ToolTip.text: "Upload file"
            icon.source: Qt.resolvedUrl(
                             "icons/outline_file_upload_black_24dp.png")
            ToolTip.visible: hovered
        }
        Button {
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
        }
    }
}
