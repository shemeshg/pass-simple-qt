import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs


Rectangle {
    property  alias textEdit: textEditId
    signal textChanged()
    color: "white"    
    height: textEditId.height
    TextEdit {
        id: textEditId
        text: ""
        width: parent.width
        onTextChanged: parent.textChanged()
    }
}
