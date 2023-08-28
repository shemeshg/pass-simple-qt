import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    property string textEditText: ""
    signal textChanged
    color: systemPalette.alternateBase
    height: parent.height
    width: parent.width
    TextEdit {
        id: textEditId
        text: textEditText
        width: parent.width
        height: parent.height
        onTextChanged: parent.textChanged()
        wrapMode: Text.WrapAnywhere
    }
}
