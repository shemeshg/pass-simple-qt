import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Dialog {
    width: parent.width * 0.75
    palette.buttonText: systemPalette.buttonText
    standardButtons: Dialog.Ok | Dialog.Cancel
    onClosed: {
        return
    }
}
