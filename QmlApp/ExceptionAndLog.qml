import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QmlCore

ColumnLayout {
    property int exceptionCounter: 0
    property string exceptionStr: ""

    onExceptionCounterChanged: {
        isShowLog = Boolean(exceptionCounter)
    }

    visible: isShowLog
    width: parent.width
    height: parent.height
    Layout.fillWidth: true

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }

    CoreButton {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: {
            exceptionCounter = 0
            mainqmltype.filePath = ""
        }
    }
    CoreTextArea {
        Layout.fillWidth: true
        text: exceptionStr
        readOnly: true
    }
}
