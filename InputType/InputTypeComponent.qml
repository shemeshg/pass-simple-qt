import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import InputType

ColumnLayout {
    id: columnLayoutId
    property string inputType: "" //totp,url,text,textedit
    property string  inputText: ""
    signal textChangedSignal(s: string)


    Component {
        id: textAreaComponent
        RowLayout {
            TextArea {
                id: textArea
                text: inputText
                onTextChanged: textChangedSignal(text)
                Layout.fillWidth: true
            }
        }
    }

    Component {
        id: textFieldComponen
        RowLayout {
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
                onTextChanged: textChangedSignal(text)
                Layout.fillWidth: true
                echoMode: (inputType === "totp" || inputType === "password") ? TextInput.Password : TextInput.Normal
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
    Loader {
        id: loader
        sourceComponent: ( inputType === "text" ||
                           inputType === "url" ||
                           inputType === "totp" ||
                           inputType === "password"
                          ) ?  textFieldComponen :  textAreaComponent
        Layout.fillWidth: true
        width: parent.width
    }

}
