import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import InputType
import QmlApp

ColumnLayout {
    id: columnLayoutId
    property string inputType: "" //totp,url,text,textedit
    property string  inputText: ""
    signal textChangedSignal(s: string)



    RowLayout {


            TextArea {
                Layout.fillWidth: true
                id: textEditComponentId
                visible: inputType === "textedit"
                text: inputText
                wrapMode: TextEdit.WrapAnywhere
                onTextChanged: {
                    textChangedSignal(textEditComponentId.text)
                    inputText = textEditComponentId.text
                }

            }
            Item {
                height: 2
                width: 15
            }



    }
    RowLayout {

        visible: inputType === "text" ||
                 inputType === "url" ||
                 inputType === "totp" ||
                 inputType === "password"

        InputTypeType {
            id: inputTypeType
        }
        Timer {
            interval: 500; running: inputType === "totp"; repeat: true
            onTriggered: totpId.text = getMainqmltype().getTotp(textField.text)
        }

        TextField {
            id: textField
            text: inputText
            onTextChanged: {
                textChangedSignal(text)
                textEditComponentId.text = text
            }
            Layout.fillWidth: true
            echoMode: (inputType === "totp" || inputType === "password") ? TextInput.Password : TextInput.Normal
            rightPadding: 8
        }
        TextField {
            id: totpId
            text: ""
            readOnly: true
            visible: inputType === "totp"
        }
        Button {
            text: "@"
            visible: inputType === "url"
            onClicked: Qt.openUrlExternally(textField.text);
            enabled: textField.text.startsWith("file://") ||
                     textField.text.startsWith("http://") ||
                     textField.text.startsWith("https://")

        }
        Button {
            text: "*"
            visible: inputType === "totp" ||
                     inputType === "password"
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
