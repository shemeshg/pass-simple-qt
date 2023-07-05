import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property int exceptionCounter: 0
    property string exceptionStr: ""

    onExceptionCounterChanged: {
        isShowLog = Boolean(exceptionCounter);
    }

    visible: isShowLog
    width: parent.width
    height : parent.height
    Layout.fillWidth: true


    Button {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: {
            exceptionCounter = 0 ;
            mainqmltype.filePath = ""
        }

    }
    TextEdit {
        Layout.fillWidth: true
        text: exceptionStr
        readOnly: true
    }


}
