import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    property string coreLabel: ""
    property string coreText: ""
    Label {
        padding: 8
        text: coreLabel + ": "
    }

    CoreLabel {
        text: coreText
    }
}
