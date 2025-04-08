import QtQuick
import QmlCore
import QtQuick.Layouts
import QtQuick.Controls

TextArea {
    ContextMenu.menu: null   
    property bool useMonospaceFont: false
    QmlCoreType {
        id: qmlCoreType
    }
    font.family: useMonospaceFont ? qmlCoreType.fixedFontSystemName : font.family
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

    selectionColor: CoreSystemPalette.highlight
    selectedTextColor: CoreSystemPalette.highlightedText
    placeholderTextColor: CoreSystemPalette.text

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
