import QtQuick
import QtQuick.Controls

TabButton {
    required property int idx
    required property int cidx
    property string hooverText: ""
    CoreToolTip {
        id: toolTip
    }
    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (!hovered)
                toolTip.hide();
        }
    }

    onHoveredChanged: {
        if (hooverText) {
            toolTip.show(hooverText, 3000);
        }
    }


    background: Rectangle {
        color: cidx === idx ? CoreSystemPalette.light : CoreSystemPalette.mid
    }

}
