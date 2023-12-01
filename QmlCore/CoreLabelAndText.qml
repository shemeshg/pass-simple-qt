import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    property string coreLabel: ""
    property string coreText: ""
    Label {
        text: coreLabel + ": "
    }

    CoreLabel {
        text: coreText
    }
}
