import QtQuick
import DropdownWithList

import QtQuick.Controls
import QtQuick.Layouts


    ColumnLayout {
        DropdownWithListType {
            id:   dropdownWithListTypeId
         }

        ComboBox {
            id: editableCombo
            editable: true

            //width: 200
            model: [ "Banana", "Apple", "Coconut" ]
            onActivated: console.log(currentValue)
            inputMethodHints: Qt.ImhNoAutoUppercase
            onAccepted: {
                if (find(editText) !== -1)
                           activated(find(editText))
            }

        }

        ComboBox {
            //width: 200
            model: [ "Banana", "Apple", "Coconut" ]

        }

    }



