import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls

import Datetime

ColumnLayout {
    id: datetimeComponentId
    signal datetimeChanged(string text);

    property string  datetimeFormatString: "yyyy-MM-dd HH:mm"
    property string  datetimeInputMaskString: "9999-99-99 99:99"
    property string  datetimeStr: ""

    width: parent.width
    height: parent.height



    DatetimeType {
        id: dateTime
        datetimeFormat: datetimeFormatString

    }


    RowLayout {
        Component.onCompleted:{
            dateTime.datetimeStr = datetimeStr;
            input.text = dateTime.datetimeStr;
            daysDiffId.text = dateTime.daysDiff;

        }

        TextField {
            Layout.fillWidth: true
            id: input
            inputMask: datetimeInputMaskString
            validator: DateTimeValidator {
                datetimeFormat: datetimeFormatString
            }
            onTextChanged: {
                acceptableInput ? statusId.text = "" : statusId.text = qsTr("Input not acceptable");
                datetimeComponentId.datetimeChanged(text)
            }
            onTextEdited: {
                dateTime.datetimeStr = text
                daysDiffId.text = dateTime.daysDiff;
            }
        }


        Text {
            text: "In"
        }
        TextField {
            id: daysDiffId            
            validator: IntValidator {}
            onTextEdited: {
                if (Number(text)){
                    dateTime.daysDiff = text;
                } else {
                    dateTime.daysDiff = 0;
                }
                input.text = dateTime.datetimeStr
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
