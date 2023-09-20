import QtQuick
import QtQuick.Controls

TextField {
    palette.buttonText: systemPalette.buttonText
    onActiveFocusChanged: {
        if (activeFocus) {
            selectAll()
        }
    }
}
