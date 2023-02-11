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
         width: parent.width
        Row{
             width: parent.width
            TextEditComponent {
                id: textEditComponentId
                visible: inputType === "textedit"
                textEdit.text: inputText
                onTextChanged: {
                    textChangedSignal(textEdit.text)
                    inputText = textEdit.text
                }
                width: parent.width


            }
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
                textEditComponentId.textEdit.text = text
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
    }




}
