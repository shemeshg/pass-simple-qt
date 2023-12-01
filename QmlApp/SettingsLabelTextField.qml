import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

ColumnLayout {
    property alias labelText: label.text
    property alias text: coreTextField.text
    Label {
        id: label
        text: ""
    }
    RowLayout {
        CoreTextField {
            id: coreTextField
            text: ""
            Layout.fillWidth: true
        }
    }
}
