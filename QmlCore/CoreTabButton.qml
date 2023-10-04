import QtQuick
import QtQuick.Controls

TabButton {
    required property int idx
    required property int cidx
    background: Rectangle {
        color: cidx === idx ? systemPalette.light : systemPalette.mid
    }
}
