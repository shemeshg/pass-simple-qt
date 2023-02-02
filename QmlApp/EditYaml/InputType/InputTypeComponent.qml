import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import InputType

ColumnLayout {
    id: columnLayoutId
    property string inputType: ""
    property string  inputText: ""
    signal textChangedSignal()


    Component {
        id: textAreaComponent
        RowLayout {
            TextArea {
                id: textArea
                text: inputText
                onTextChanged: textChangedSignal()
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
                onTriggered: totpId.text = inputTypeType.getTotp(textField.text)
            }

            TextField {
                id: textField
                text: inputText
                onTextChanged: textChangedSignal()
                Layout.fillWidth: true
            }
            TextField {
                id: totpId
                text: ""
                readOnly: true
                visible: inputType === "totp"
            }
            Button {
                text: "QR"
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
        }

    }
    Loader {
        id: loader
        sourceComponent: inputType === "text" ? textAreaComponent : textFieldComponen
        Layout.fillWidth: true
        width: parent.width
    }

}
