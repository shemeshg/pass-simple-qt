import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

ColumnLayout {
    property alias labelText: label.text
    property alias model: coreComboBox.model
    property alias textRole: coreComboBox.textRole
    property alias valueRole: coreComboBox.valueRole
    property alias currentIndex: coreComboBox.currentIndex
    property alias currentValue: coreComboBox.currentValue
    property alias currentText: coreComboBox.currentText


    signal activated1

    Label {
        id: label
        text: ""
        padding: 8
    }
    CoreComboBox {
        id: coreComboBox
        Layout.fillWidth: true
        onActivated: {
            activated1()
        }
    }
}
