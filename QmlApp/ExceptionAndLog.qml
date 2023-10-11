import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QmlCore

ColumnLayout {

    Connections {
        target: QmlAppSt
        function onExceptionCounterChanged() {
            QmlAppSt.isShowLog = Boolean(QmlAppSt.exceptionCounter)
        }
    }

    visible: QmlAppSt.isShowLog
    width: parent.width
    height: parent.height
    Layout.fillWidth: true

    CoreButton {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: {
            QmlAppSt.exceptionCounter = 0

            getMainqmltype().setTreeViewSelected(
                        mainLayout.getMainqmltype(
                            ).appSettingsType.passwordStorePath)
        }
    }
    CoreTextArea {
        Layout.fillWidth: true
        text: QmlAppSt.exceptionStr
        readOnly: true
    }
}
