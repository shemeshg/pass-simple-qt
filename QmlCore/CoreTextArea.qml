import QtQuick
import QmlCore
import QtQuick.Layouts
import QtQuick.Controls

TextArea {
    CoreToolTip {
        id: toolTip
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (!hovered)
                toolTip.hide()
        }
    }

    selectionColor: systemPalette.highlight
    selectedTextColor: systemPalette.highlightedText
    placeholderTextColor: systemPalette.highlightedText

    width: parent.width
    height: parent.height
    Layout.fillWidth: true
    Layout.fillHeight: true

    onLinkActivated: link => {
                         doUrlRedirect(link)
                     }
    onLinkHovered: link => {
                       if (link.length === 0)
                       return

                       // Show the ToolTip at the mouse cursor, plus some margins so the mouse doesn't get in the way.
                       toolTip.x = hoverHandler.point.position.x + 8
                       toolTip.y = hoverHandler.point.position.y + 8
                       toolTip.show(link, 3000)
                   }
}
