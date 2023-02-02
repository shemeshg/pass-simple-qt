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

        TextArea {
            id: textArea
            text: inputText
            onTextChanged: textChangedSignal()
        }
    }

    Component {
        id: textFieldComponen

        TextField {
            id: textField
            text: inputText
            onTextChanged: textChangedSignal()
        }
    }
    Loader {
        id: loader
        sourceComponent: inputType == "text" ? textAreaComponent : textFieldComponen
        Layout.fillWidth: true
    }

}
