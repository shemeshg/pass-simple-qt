import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import InputType
import QmlCore

ColumnLayout {
    property bool isEditFieldsType: false
    signal selectedTextSignal(string s)

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

    RowLayout {
        visible: editYamlType.isYamlValid

        Shortcut {
            sequence: "Ctrl+U"
            onActivated: {
                if (editYamlType.isYamlValid) {

                    let url = editYamlType.yamlModel.filter(row => {
                                                                return row.inputType === "url"
                                                            })[0]?.val
                    doUrlRedirect(url)
                }
            }
        }

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
            icon.color: CoreSystemPalette.buttonText
            palette.buttonText: CoreSystemPalette.buttonText
        }
        Item {
            height: addDialogButtonId.height + 5
            width: 1
        }
    }
    CoreThinBar {
        visible: editYamlType.isYamlValid
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
    CoreDialogYesNo {
        id: renameDialog
        title: "Set field name"
        CoreTextField {
            id: fieldName
            focus: true
            text: dialogRowIdx > -1 ? editYamlType.yamlModel[dialogRowIdx].key : ""
            width: parent.width
        }
        onAccepted: {
            let newArry = [...editYamlType.yamlModel]
            newArry[dialogRowIdx].key = fieldName.text
            editYamlType.yamlModel = newArry
            setNotifyBodyContentModified(true)
        }
        onClosed: {
            dialogRowIdx = -1
        }
    }

    CoreDialogYesNo {
        id: addDialog
        title: "Set new field name"        
        CoreTextField {
            id: newFieldName
            focus: true
            text: ""            
            width: parent.width
        }
        onAccepted: {
            let s = newFieldName.text.trim()
            if (!s) {
                return
            }
            let newArry = [...editYamlType.yamlModel]
            newArry.push({
                             "inputType": "textedit",
                             "key": s,
                             "val": ""
                         })
            editYamlType.yamlModel = newArry
            setNotifyBodyContentModified(true)
        }
        onClosed: {
            dialogRowIdx = -1
        }
    }

    function shouldCopyBeEnabled(key) {
        if (key.startsWith("OLD_")) {
            return false
        }
        let count = editYamlType.yamlModel.filter(row => {
                                                      return row.key.includes(
                                                          "OLD_" + key)
                                                  }).length
        return count === 0
    }

    ListView {
        id: yamlModelListViewId

        Component {
            id: myfooter
            CorePagePadFooter {}
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
                    Layout.fillWidth: !isEditFieldsType
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
                        color: CoreSystemPalette.text
                        visible: isEditFieldsType && markedRow === index
                    }
                }

                CoreButton {
                    id: moveUpId
                    visible: isEditFieldsType
                    onClicked: () => {
                                   setNotifyBodyContentModified(true)
                                   arrayMove(index, index - 1)
                               }
                    icon.name: "Up"
                    hooverText: "Up"
                    icon.source: Qt.resolvedUrl("icons/move_up_black_24dp.svg")
                    icon.color: CoreSystemPalette.buttonText
                    palette.buttonText: CoreSystemPalette.buttonText
                }
                CoreButton {
                    visible: isEditFieldsType
                    onClicked: {
                        setNotifyBodyContentModified(true)
                        arrayMove(index, index + 1)
                    }
                    icon.name: "Down"
                    hooverText: "Down"
                    icon.source: Qt.resolvedUrl(
                                     "icons/move_down_black_24dp.svg")
                    icon.color: CoreSystemPalette.buttonText
                    palette.buttonText: CoreSystemPalette.buttonText
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
                    icon.color: CoreSystemPalette.buttonText
                    palette.buttonText: CoreSystemPalette.buttonText
                }
                CoreButton {
                    visible: isEditFieldsType
                    onClicked: {
                        setNotifyBodyContentModified(true)
                        let newArry = [...editYamlType.yamlModel]
                        newArry.splice(index, 1)
                        editYamlType.yamlModel = newArry
                    }
                    icon.name: "Delete"
                    hooverText: "Delete"
                    icon.source: Qt.resolvedUrl(
                                     "icons/remove_circle_outline_black_24dp.svg")
                    icon.color: CoreSystemPalette.buttonText
                    palette.buttonText: CoreSystemPalette.buttonText
                }
                CoreButton {
                    enabled: shouldCopyBeEnabled(modelData.key)
                    visible: isEditFieldsType
                    onClicked: {
                        setNotifyBodyContentModified(true)
                        let newArry = [...editYamlType.yamlModel]

                        let rowNew = JSON.parse(
                                JSON.stringify(editYamlType.yamlModel[index]))
                        rowNew.key = "OLD_" + rowNew.key
                        newArry.splice(index, 0, rowNew)
                        editYamlType.yamlModel = newArry
                    }
                    icon.name: "Copy"
                    hooverText: shouldCopyBeEnabled(
                                    modelData.key) ? "Copy " + modelData.key + " to OLD_"
                                                     + modelData.key : "Copy already exists"
                    icon.source: Qt.resolvedUrl(
                                     "icons/content_copy_FILL0_wght400_GRAD0_opsz24.svg")
                    icon.color: CoreSystemPalette.buttonText
                    palette.buttonText: CoreSystemPalette.buttonText
                }
                Item {
                    width: 8
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
                color: CoreSystemPalette.text
            }
        }
    }
}
