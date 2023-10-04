import QtQuick
import QtQuick.Controls

TextField {
    palette.buttonText: CoreSystemPalette.buttonText
    onActiveFocusChanged: {
        if (activeFocus) {
            selectAll()
        }
    }
}
