import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSearch
    width: parent.width
    height: parent.height

    property string currentSearchFolder: passwordStorePathStr
    property var searchResultModel: []
    property bool regexVisible: false

    onVisibleChanged: {
        if (visible) {
            findTextId.forceActiveFocus()
        }
    }

    function doSearchAction() {
        doMainUiDisable()
        btnRunSearchId.enabled = false
        searchStatusLabelId.visible = true
        searchResultModel = []

        getMainqmltype().doSearchAsync(currentSearchFolder,
                                       textFieldFileSearch.text,
                                       textFieldContentSearch.text,
                                       isMemCash.checked, () => {
                                           searchResultModel = getMainqmltype(
                                               ).searchResult
                                           btnRunSearchId.enabled = true
                                           searchStatusLabelId.visible = false
                                           doMainUiEnable()
                                       })
    }

    RowLayout {
        Button {
            text: "Back"
            onClicked: isShowSearch = false
            palette.buttonText: systemPalette.buttonText
        }
        Button {
            text: "regex"
            onClicked: {
                regexVisible = !regexVisible
            }
            palette.buttonText: systemPalette.buttonText
        }
        Button {

            id: btnRunSearchId
            text: "find"
            onClicked: {

                doSearchAction()
            }
            palette.buttonText: systemPalette.buttonText
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: systemPalette.alternateBase
    }

    ColumnLayout {
        spacing: 8

        Label {
            text: "File name"
        }
        TextField {
            id: findTextId
            text: ""
            Layout.fillWidth: true
            onAccepted: {
                doSearchAction()
            }
        }
        ColumnLayout {
            visible: regexVisible
            Label {
                text: "std::regex"
            }
            TextField {
                id: textFieldFileSearch
                text: ".*" + findTextId.text.replace(
                          /[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + ".*"
                Layout.fillWidth: true
                onAccepted: {
                    doSearchAction()
                }
            }
        }
        RowLayout {
            Label {
                text: "Contain"
            }
            Item {
                height: 2
                width: 2
                Layout.fillWidth: true
            }
            Switch {
                id: isMemCash
                checked: false
                text: qsTr("mem.cash")
            }
        }
        TextField {
            id: searchTextId
            text: ""
            Layout.fillWidth: true
            onAccepted: {
                doSearchAction()
            }
        }

        ColumnLayout {
            visible: regexVisible
            Label {
                text: "std::regex"
            }
            TextField {
                id: textFieldContentSearch
                text: ".*" + searchTextId.text.replace(
                          /[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + ".*"
                Layout.fillWidth: true
                onAccepted: {
                    doSearchAction()
                }
            }
        }

        RowLayout {
            Button {
                text: "."
                onClicked: {
                    if (fullPathFolder) {
                        currentSearchFolder = fullPathFolder
                    }
                }
                ToolTip.text: "Set search folder to current treeview selected folder"
                ToolTip.visible: hovered
            }
            Label {
                text: "In: " + currentSearchFolder
            }
        }

        Rectangle {
            color: systemPalette.alternateBase
            Layout.fillWidth: true
            height: 1
        }
        RowLayout {
            id: searchStatusLabelId
            visible: false
            Label {
                text: "Running..."
            }
        }
        ListView {
            id: searchResultRepeaterId
            model: searchResultModel

            ScrollBar.vertical: ScrollBar {}
            Layout.fillWidth: true
            Layout.fillHeight: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            delegate: RowLayout {

                Label {
                    text: modelData.replace(passwordStorePathStr, "")
                }
                Button {
                    text: "←"
                    onClicked: {
                        getMainqmltype().setTreeViewSelected(modelData)
                    }
                    ToolTip.text: "Select"
                    ToolTip.visible: hovered
                    palette.buttonText: systemPalette.buttonText
                }
                Button {
                    text: "☍"
                    ToolTip.visible: hovered
                    ToolTip.text: "Clipboard rel.path"
                    onClicked: {
                        getMainqmltype().clipboardRelPath(
                                    fullPathFolder,
                                    modelData.substr(0, modelData.length - 4))
                    }
                    palette.buttonText: systemPalette.buttonText
                }
                Label {
                    visible: modelData === filePath
                    text: "⬤"
                }
            }
        }
    }
}
