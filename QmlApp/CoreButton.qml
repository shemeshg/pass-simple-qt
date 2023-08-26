import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Button {
    property string hooverText: ""

    ToolTip {
        id: toolTip
        contentItem: Text {
            color: systemPalette.text
            text: toolTip.text
        }
    }
    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (!hovered)
                toolTip.hide()
        }
    }

    onHoveredChanged: {
        if (hooverText) {
            toolTip.show(hooverText, 3000)
        }
    }
    palette.buttonText: systemPalette.buttonText
}
