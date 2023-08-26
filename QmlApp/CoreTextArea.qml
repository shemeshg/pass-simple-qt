import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform

import DropdownWithList
import EditYaml

TextArea {

    selectionColor: systemPalette.highlight
    selectedTextColor: systemPalette.highlightedText

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
