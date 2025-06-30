import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Dialog {
    width: parent.width * 0.75
    height: parent.height * 0.5
    palette.buttonText: CoreSystemPalette.buttonText
    standardButtons: Dialog.Ok | Dialog.Cancel
    onClosed: {
        return
    }
}
