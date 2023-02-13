import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    id: exceptionAndLogId;
    visible: isShowLog;
    property alias logTextId: logTextId

    Button {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: { exceptionCounter = 0 ;isShowLog = false;}

    }
    Row{
        Layout.fillWidth: true
        TextEditComponent {
            id: logTextId
            visible: isShowLog
            width: parent.width
        }

    }

}
