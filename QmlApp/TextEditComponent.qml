import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Rectangle {
    property  alias textEdit: textEditId
    signal textChanged()
    color: "white"    
    height: parent.height
    width: parent.width
    TextEdit {
        id: textEditId
        text: ""
        width: parent.width
        height: parent.height
        onTextChanged: parent.textChanged()
        wrapMode: Text.WrapAnywhere
    }
}
