import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

import Datetime

ColumnLayout {
    id: datetimeComponentId
    signal datetimeChanged(string text);

    property alias dateTime: dateTime

    width: parent.width
    height: parent.height

    DatetimeType {
        id: dateTime
        datetimeFormat: "dd/MM/yyyy HH:mm:ss"
    }


    RowLayout {

        TextField {
            Layout.fillWidth: true
            id: input
            text : dateTime.datetimeStr
            inputMask: "99/99/9999 99:99:99"
            validator: DateTimeValidator {
                datetimeFormat: "dd/MM/yyyy HH:mm:ss"
            }
            onTextChanged: {
                acceptableInput ? statusId.text = "" : statusId.text = qsTr("Input not acceptable");
                datetimeComponentId.datetimeChanged(text)
            }
            onTextEdited: {
                dateTime.datetimeStr = text
            }
        }


        Text {
            text: "In"
        }
        TextField {
            text: dateTime.daysDiff
            validator: IntValidator {}
            onTextEdited: {
                if (Number(text)){
                    dateTime.daysDiff = text;
                } else {
                    dateTime.daysDiff = 0;
                }
            }
        }
        Text {
            text: "days"

        }

    }

    Text {
        id: statusId
        text: ""
    }
}
