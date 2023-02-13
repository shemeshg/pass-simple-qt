import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias metaDataComponentId: metaDataComponentId
    property alias manageGpgIdComponentId: manageGpgIdComponentId
    property alias editComponentId: editComponentId
    property alias addComponentId: addComponentId


    id: columnLayoutHomeId



    visible: !isShowLog;
    TabBar {
        id: bar
        Layout.fillWidth: true
        width: parent.width

        TabButton {
            text: qsTr("Edit")
        }
        TabButton {
            text: qsTr("Add")
        }
        TabButton {
            text: qsTr("Info Git")
        }
        TabButton {
            text: qsTr("Auth")
        }
        TabButton {
            text: qsTr("About")
        }
    }

    StackLayout {
        width: parent.width

        currentIndex: bar.currentIndex
        EditComponent {
            id: editComponentId
        }
        AddComponent {
            id: addComponentId
        }

        MetaDataComponent {
            id: metaDataComponentId
        }
        ManageGpgIdComponent {
            id: manageGpgIdComponentId
        }
        ColumnLayout {

            TextEdit {
                readOnly: true
                text: `
Pass simple:
    https://github.com/shemeshg/pass-simple-qt
    https://sourceforge.net/projects/pass-simple/

Example template:
---
user name:
password:
home page:
totp:
description: ""
fields type:
  user name: text
  password: password
  home page: url
  totp: totp
  description: textedit
`

        }


        }
    }

}
