import QtQuick
import QtQuick.Controls
import QmlCore

TextField {
    property bool useMonospaceFont: false
    QmlCoreType {
        id: qmlCoreType
    }
    font.family: useMonospaceFont ? qmlCoreType.fixedFontSystemName : font.family
    palette.buttonText: CoreSystemPalette.buttonText
    onActiveFocusChanged: {
        if (activeFocus) {
            selectAll()
        }
    }
}
