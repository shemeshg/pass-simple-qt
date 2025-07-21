import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Dialog {

    popupType: Popup.Window
    modal: true
    anchors.centerIn: parent

    focus: true
    contentWidth: parent.width * 0.75
    contentHeight : parent.height * 0.5
    palette.buttonText: CoreSystemPalette.buttonText
    standardButtons: Dialog.Ok | Dialog.Cancel
    onClosed: {
        return
    }

}
