import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    id: exceptionAndLogId;
    visible: isShowLog;

    Button {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: { exceptionCounter = 0 ;isShowLog = false;}

    }
    Row{
        Rectangle {
            color: "white"
            width: scrollViewId.width - 20
            height: logTextId.height

            TextEdit {
                id: logTextId
                text: showLogText
                width: parent.width
                textFormat: TextEdit.AutoText

            }
        }
    }

}
