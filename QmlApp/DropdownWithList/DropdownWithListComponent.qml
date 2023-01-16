import QtQuick
import DropdownWithList

import QtQuick.Controls
import QtQuick.Layouts


ColumnLayout {
    DropdownWithListType {
        id:   dropdownWithListTypeId
    }

    Label {
        text:  "<h1>Group members</h1>"
    }

    Repeater {
        model: dropdownWithListTypeId.selectedItems
        RowLayout{
            Label {
                text:  modelData
            }
            Button {
                text: "remove"
                onClicked: dropdownWithListTypeId.addNotSelectedItem(modelData)
            }
        }
    }


    Label {
        text:  "<h1>Select member to add</h1>"
    }

    Repeater {
        model: dropdownWithListTypeId.notSelectedItems
        RowLayout{
            Label {
                text:  modelData
            }
            Button {
                text: "add"
                onClicked: dropdownWithListTypeId.addSelectedItem(modelData)
            }
        }
    }

}



