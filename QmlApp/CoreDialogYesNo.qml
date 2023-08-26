import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

Dialog {
    width: parent.width * 0.75
    palette.buttonText: systemPalette.buttonText
    standardButtons: Dialog.Ok | Dialog.Cancel
    onClosed: {
        return
    }
}
