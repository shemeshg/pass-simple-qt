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
    signal textChangedSignal(s: string)


    RowLayout {
        visible: inputType === "datetime"
        DatetimeComponent {
            datetimeStr: inputText
            onDatetimeChanged: (text)=>{
                                   if(inputType === "datetime"){
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
            font.family: getMainqmltype().fixedFont
            Layout.fillWidth: true
            id: textEditComponentId
            visible: inputType === "textedit"
            text: inputText
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged:   {                
                textChangedSignal(textEditComponentId.text)
                inputText = textEditComponentId.text
            }
            onSelectedTextChanged: {
                getMainqmltype().selectedText = selectedText
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
            onTriggered: totpText = getMainqmltype().getTotp(inputText)
        }
        TextField {
            id: textField
            font.family: getMainqmltype().fixedFont
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
            font.family: getMainqmltype().fixedFont
            text: totpText
            readOnly: true
            visible: inputType === "totp"
        }
        Button {
            text: "@"
            visible: inputType === "url"
            onClicked: doUrlRedirect(inputText)
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
