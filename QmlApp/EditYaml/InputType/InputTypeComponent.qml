import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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
            TextField {
                id: textField
                text: inputText
                onTextChanged: textChangedSignal()
                Layout.fillWidth: true
            }
            TextField {
                id: totpId
                text: "897654"
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
