import QtQuick
import DropdownWithList

import QtQuick.Controls
import QtQuick.Layouts




ColumnLayout {
    property alias selectedItems: dropdownWithListTypeId.selectedItems
    property alias notSelectedItems: dropdownWithListTypeId.notSelectedItems
    property alias allItems: dropdownWithListTypeId.allItems

    DropdownWithListType {
        id:   dropdownWithListTypeId
    }

    Label {
        text:  "<h2>Group members</h2>"
        visible: dropdownWithListTypeId.selectedItems.length > 0
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
        text:  "<h2>Select member to add</h2>"
        visible: dropdownWithListTypeId.notSelectedItems.length > 0
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



