import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    id: addComponentId
    RowLayout{
        Label {
            text: "<h1>Add</h1>"
        }
    }
    RowLayout{
        Label {
            text: "Destination folder: /asdfd/asdfasdf"
        }
    }
    RowLayout{
        Label {
            text: "<h2>Create empty encrypted text file</h1>"
        }
    }
    RowLayout {
        Label {
            text: "File name"
        }
        TextField {
            text: ""
            placeholderText: "FileName.txt"
            Layout.fillWidth: true
        }
        Button {
            text: "add"
        }
    }
    RowLayout{
        Label {
            text: "<h2>Upload existing file</h2>"
        }
    }
    RowLayout {
        Button {
            text: "upload"
        }
    }
}
