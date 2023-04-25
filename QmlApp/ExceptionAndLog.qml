import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property bool showLog: false;
    property string logText: ""

    Button {
        id: navigateBackFromLogId
        text: "Back"
        onClicked: { exceptionCounter = 0 ;isShowLog = false;isGpgFile=false;}

    }
    Row{
        Layout.fillWidth: true
        TextEditComponent {
            textEditText: logText
            visible: showLog
            width: parent.width
        }

    }

}
