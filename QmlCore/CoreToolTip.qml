import QtQuick
import QtQuick.Controls

ToolTip {
    id: toolTip
    contentItem: Text {
        color: systemPalette.text

        text: toolTip.text
    }
    background: Rectangle {
        color: systemPalette.base
    }
}
