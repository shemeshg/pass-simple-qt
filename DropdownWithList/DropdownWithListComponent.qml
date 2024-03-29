import QtQuick
import DropdownWithList

import QtQuick.Controls
import QtQuick.Layouts
import QmlCore

ColumnLayout {
    property alias selectedItems: dropdownWithListTypeId.selectedItems
    property alias notSelectedItems: dropdownWithListTypeId.notSelectedItems
    property alias allItems: dropdownWithListTypeId.allItems

    DropdownWithListType {
        id: dropdownWithListTypeId
    }

    ColumnLayout {
        RowLayout {
            CoreTextField {
                id: txtFilter
                placeholderText: "filter"
                Layout.fillWidth: true
            }
        }
        RowLayout {
            Label {
                text: "<h2>Groups membered</h2>"
                visible: dropdownWithListTypeId.selectedItems.length > 0
            }
        }
        Repeater {
            model: dropdownWithListTypeId.selectedItems
            RowLayout {
                visible: modelData.includes(txtFilter.text)
                CoreLabel {
                    text: modelData
                }
                CoreButton {
                    text: "remove"
                    onClicked: dropdownWithListTypeId.addNotSelectedItem(
                                   modelData)
                }
            }
        }
        Row {
            Label {
                text: "<h2>Select groups to add</h2>"
                visible: dropdownWithListTypeId.notSelectedItems.length > 0
            }
        }
        Column {
            Repeater {
                model: dropdownWithListTypeId.notSelectedItems
                RowLayout {
                    visible: modelData.includes(txtFilter.text)
                    CoreLabel {
                        text: modelData
                    }
                    CoreButton {
                        text: "add"
                        onClicked: dropdownWithListTypeId.addSelectedItem(
                                       modelData)
                    }
                }
            }
        }
    }
}
