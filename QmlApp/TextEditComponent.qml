import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs


Rectangle {
    property  alias textEdit: textEditId

    color: "white"    
    height: textEditId.height
    TextEdit {
        id: textEditId
        text: ""
        width: parent.width
    }
}
