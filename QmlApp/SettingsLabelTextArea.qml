import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

ColumnLayout {
    property alias labelText: label.text
    property alias text: coreTextField.text

    signal textEntered

    Label {
        id: label
        text: ""
    }
    RowLayout {
        CoreTextArea {
            property bool isKeyPressed: false
            id: coreTextField
            text: ""
            Layout.fillWidth: true
            onTextChanged: {
                if (isKeyPressed) {
                    textEntered()
                }
            }
            Keys.onPressed: event => {
                                isKeyPressed = true
                            }
        }
    }
}
