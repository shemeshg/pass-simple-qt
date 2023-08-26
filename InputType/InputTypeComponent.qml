import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
        ToolTip {
            id: toolTip
            contentItem: Text {
                color: systemPalette.text
                text: toolTip.text
            }
        }
        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (hovered)
                    toolTip.hide()
            }
        }
        TextArea {
            visible: (inputType === "textedit" || inputType === "texteditMasked"
                      && isTexteditMasked === false) && showMdId.checked
            readOnly: true
            text: inputText
            textFormat: TextEdit.MarkdownText
            wrapMode: TextEdit.WrapAnywhere
            Layout.fillWidth: true
            onLinkActivated: link => {
                                 doUrlRedirect(link)
                             }
            onLinkHovered: link => {
                               if (link.length === 0)
                               return

                               // Show the ToolTip at the mouse cursor, plus some margins so the mouse doesn't get in the way.
                               toolTip.x = hoverHandler.point.position.x + 8
                               toolTip.y = hoverHandler.point.position.y + 8
                               toolTip.show(link, 3000)
                           }
        }

        TextArea {
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
            selectionColor: systemPalette.highlight
            selectedTextColor: systemPalette.highlightedText
        }
        Label {
            padding: 8
            Layout.fillWidth: true
            text: "*********"
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
        }
    }
}
