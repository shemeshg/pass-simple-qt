import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts
import InputType
import QmlApp

ColumnLayout {
    property bool isEditFieldsType: false
    height: parent.height
    width: parent.width

    Component {
        id: menuItem
        MenuItem {}
    }

    RowLayout {
        Label {
            text: Error + ": " + editYamlType.yamlErrorMsg
        }
        visible: !editYamlType.isYamlValid
    }

    Rectangle {
        visible: editYamlType.isYamlValid
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: systemPalette.alternateBase
    }

    RowLayout {
        visible: editYamlType.isYamlValid

        CoreSwitch {
            id: idEditFieldsType
            text: qsTr("Edit fields type")
            checked: isEditFieldsType
            onToggled: {
                isEditFieldsType = !isEditFieldsType
            }
        }

        CoreButton {
            id: addDialogButtonId
            visible: isEditFieldsType
            onClicked: {
                addDialog.open()
            }
            icon.name: "Add"
            hooverText: "Add"
            icon.source: Qt.resolvedUrl("icons/control_point_black_24dp.svg")
        }
        Item {
            height: addDialogButtonId.height + 5
            width: 1
        }
    }

    property int markedRow: -1
    function arrayMove(oldIndex, newIndex) {
        let arr = editYamlType.yamlModel
        while (oldIndex < 0) {
            oldIndex += arr.length
        }
        while (newIndex < 0) {
            newIndex += arr.length
        }
        if (newIndex >= arr.length) {
            newIndex = 0
        }
        let newArry = [...arr]
        newArry.splice(newIndex, 0, newArry.splice(oldIndex, 1)[0])

        markedRow = newIndex
        editYamlType.yamlModel = newArry
    }

    property int dialogRowIdx: -1
    Dialog {
        id: renameDialog
        title: "Set field name"
        width: parent.width * 0.75
        palette.buttonText: systemPalette.buttonText

        standardButtons: Dialog.Ok | Dialog.Cancel
        TextField {
            id: fieldName
            focus: true
            text: dialogRowIdx > -1 ? editYamlType.yamlModel[dialogRowIdx].key : ""
            width: parent.width
        }
        onAccepted: {
            let newArry = [...editYamlType.yamlModel]
            newArry[dialogRowIdx].key = fieldName.text
            editYamlType.yamlModel = newArry
            notifyStr("*")
        }
        onClosed: {
            dialogRowIdx = -1
        }
    }

    Dialog {
        id: addDialog
        title: "Set new field name"
        width: parent.width * 0.75
        palette.buttonText: systemPalette.buttonText

        standardButtons: Dialog.Ok | Dialog.Cancel
        TextField {
            id: newFieldName
            focus: true
            text: ""
            width: parent.width
        }
        onAccepted: {
            if (!newFieldName.text) {
                return
            }
            let newArry = [...editYamlType.yamlModel]
            newArry.push({
                             "inputType": "textedit",
                             "key": newFieldName.text,
                             "val": ""
                         })
            editYamlType.yamlModel = newArry
            notifyStr("*")
        }
        onClosed: {
            dialogRowIdx = -1
        }
    }

    ListView {
        id: yamlModelListViewId

        Component {
            id: myfooter
            Item {
                width: parent.width
                height: 100
            }
        }
        footer: myfooter

        model: editYamlType.yamlModel
        visible: editYamlType.isYamlValid
        clip: true

        ScrollBar.vertical: ScrollBar {}
        Layout.fillWidth: true
        Layout.fillHeight: true

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        delegate: ColumnLayout {
            width: yamlModelListViewId.width

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: modelData.key + ": "
                    padding: 8
                }
                CoreComboBox {
                    id: selectedInputType
                    visible: isEditFieldsType
                    height: moveUpId.height
                    model: ["textedit", "texteditMasked", "text", "url", "password", "totp", "datetime"]
                    Component.onCompleted: {
                        currentIndex = find(modelData.inputType)
                    }

                    Layout.fillWidth: true
                    onActivated: {
                        let newArry = [...editYamlType.yamlModel]

                        for (var i = 0; i < newArry.length; i++) {

                            if (newArry[i].key === modelData.key) {
                                newArry[i].inputType = currentText
                            }
                        }
                        editYamlType.yamlModel = newArry
                        inputTypeComponentId.inputType = currentText
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignTop

                    width: 10
                    Rectangle {

                        width: parent.width
                        height: 10
                        color: systemPalette.text
                        visible: isEditFieldsType && markedRow === index
                    }
                }

                CoreButton {
                    id: moveUpId
                    visible: isEditFieldsType
                    onClicked: () => {
                                   notifyStr("*")
                                   arrayMove(index, index - 1)
                               }
                    icon.name: "Up"
                    hooverText: "Up"
                    icon.source: Qt.resolvedUrl("icons/move_up_black_24dp.svg")
                }
                CoreButton {
                    visible: isEditFieldsType
                    onClicked: {
                        notifyStr("*")
                        arrayMove(index, index + 1)
                    }
                    icon.name: "Down"
                    hooverText: "Down"
                    icon.source: Qt.resolvedUrl(
                                     "icons/move_down_black_24dp.svg")
                }
                CoreButton {
                    visible: isEditFieldsType
                    onClicked: () => {
                                   dialogRowIdx = index
                                   renameDialog.open()
                               }
                    icon.name: "Rename"
                    hooverText: "Rename"
                    icon.source: Qt.resolvedUrl(
                                     "icons/edit_FILL0_wght400_GRAD0_opsz48.svg")
                }
                CoreButton {
                    visible: isEditFieldsType
                    onClicked: {
                        notifyStr("*")
                        let newArry = [...editYamlType.yamlModel]
                        newArry.splice(index, 1)
                        editYamlType.yamlModel = newArry
                    }
                    icon.name: "Delete"
                    hooverText: "Delete"
                    icon.source: Qt.resolvedUrl(
                                     "icons/remove_circle_outline_black_24dp.svg")
                }
                Item {
                    width: 10
                }
            }
            RowLayout {
                Layout.fillWidth: true
                InputTypeComponent {
                    id: inputTypeComponentId
                    width: parent.width
                    inputText: modelData.val
                    inputType: modelData.inputType
                    onTextChangedSignal: function (s) {
                        editYamlType.sendChangeVal(modelData.key, s)
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: systemPalette.text
            }
        }
    }
}
