import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Datetime
import QmlCore

ColumnLayout {
    id: datetimeComponentId
    signal datetimeChanged(string text)

    property string datetimeFormatString: "yyyy-MM-dd HH:mm"
    property string datetimeInputMaskString: "9999-99-99 99:99"
    property string datetimeStr: ""

    width: parent.width
    height: parent.height

    DatetimeType {
        id: dateTime
        datetimeFormat: datetimeFormatString
    }

    RowLayout {
        Component.onCompleted: {
            dateTime.datetimeStr = datetimeStr
            input.text = dateTime.datetimeStr
            daysDiffId.text = dateTime.daysDiff
        }

        CoreTextField {
            property bool isKeyPressed: false
            Layout.fillWidth: true
            id: input
            inputMask: datetimeInputMaskString
            validator: DateTimeValidator {
                datetimeFormat: datetimeFormatString
            }
            onTextChanged: {
                acceptableInput ? statusId.text = "" : statusId.text = qsTr(
                                      "Input not acceptable")
                datetimeComponentId.datetimeChanged(text)
                if (isKeyPressed) {
                    setNotifyBodyContentModified(true)
                    isKeyPressed = false
                }
            }
            onTextEdited: {
                dateTime.datetimeStr = text
                daysDiffId.text = dateTime.daysDiff
            }
            Keys.onPressed: event => {
                                isKeyPressed = true
                            }
        }

        Label {
            text: "In"
        }
        CoreTextField {
            id: daysDiffId
            validator: IntValidator {}
            onTextEdited: {
                if (Number(text)) {
                    dateTime.daysDiff = text
                } else {
                    dateTime.daysDiff = 0
                }
                input.text = dateTime.datetimeStr
                setNotifyBodyContentModified(true)
            }
        }
        Label {
            text: "days"
        }
    }

    Label {
        id: statusId
        text: ""
    }
}
