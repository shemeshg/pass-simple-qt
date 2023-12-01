import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

ColumnLayout {
    visible: QmlAppSt.isShowSearch
    width: parent.width
    height: parent.height

    property string currentSearchFolder: QmlAppSt.passwordStorePathStr
    property var searchResultModel: []
    property bool regexVisible: false

    onVisibleChanged: {
        if (visible) {
            findTextId.forceActiveFocus()
        }
    }

    function doSearchAction() {
        QmlAppSt.doMainUiDisable()
        btnRunSearchId.enabled = false
        searchStatusLabelId.visible = true
        searchResultModel = []

        QmlAppSt.mainqmltype.doSearchAsync(currentSearchFolder,
                                           textFieldFileSearch.text,
                                           textFieldContentSearch.text,
                                           isMemCash.checked, () => {
                                               searchResultModel = QmlAppSt.mainqmltype.searchResult
                                               btnRunSearchId.enabled = true
                                               searchStatusLabelId.visible = false
                                               QmlAppSt.doMainUiEnable()
                                               if (isSelectFirst.checked
                                                   && searchResultModel.length > 0) {
                                                   QmlAppSt.mainqmltype.setTreeViewSelected(
                                                       searchResultModel[0])
                                               }
                                           })
    }

    RowLayout {
        CoreButton {
            text: "Back"
            hooverText: "<b>Cmd F</b> back"
            onClicked: QmlAppSt.isShowSearch = false
        }
        CoreButton {
            text: "regex"
            onClicked: {
                regexVisible = !regexVisible
            }
        }
        CoreButton {
            id: btnRunSearchId
            text: "find"
            onClicked: {

                doSearchAction()
            }
        }
    }

    CoreThinBar {}

    ColumnLayout {

        RowLayout {
            Label {
                text: "File name"
            }
            Item {
                height: 2
                width: 2
                Layout.fillWidth: true
            }
            CoreSwitch {
                id: isSelectFirst
                checked: QmlAppSt.mainqmltype.appSettingsType.isFindSlctFrst
                text: qsTr("select 1st")
                onToggled: {
                    QmlAppSt.mainqmltype.appSettingsType.isFindSlctFrst = checked
                }
            }
        }
        RowLayout {
            CoreTextField {
                id: findTextId
                text: ""
                Layout.fillWidth: true
                onAccepted: {
                    doSearchAction()
                }
            }
        }
        ColumnLayout {
            visible: regexVisible
            Label {
                text: "std::regex"
            }
            RowLayout {
                CoreTextField {
                    id: textFieldFileSearch
                    text: ".*" + findTextId.text.replace(
                              /[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + ".*"
                    Layout.fillWidth: true
                    onAccepted: {
                        doSearchAction()
                    }
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
            CoreSwitch {
                id: isMemCash
                checked: QmlAppSt.mainqmltype.appSettingsType.isFindMemCash
                text: qsTr("mem.cash")
                onToggled: {
                    QmlAppSt.mainqmltype.appSettingsType.isFindMemCash = checked
                }
            }
        }

        RowLayout {
            CoreTextField {
                id: searchTextId
                text: ""
                Layout.fillWidth: true
                onAccepted: {
                    doSearchAction()
                }
            }
        }

        ColumnLayout {
            visible: regexVisible
            Label {
                text: "std::regex"
            }

            RowLayout {
                CoreTextField {
                    id: textFieldContentSearch
                    text: ".*" + searchTextId.text.replace(
                              /[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') + ".*"
                    Layout.fillWidth: true
                    onAccepted: {
                        doSearchAction()
                    }
                }
            }
        }

        RowLayout {

            CoreButton {
                text: "."
                onClicked: {
                    if (QmlAppSt.fullPathFolder) {
                        currentSearchFolder = QmlAppSt.fullPathFolder
                    }
                }
                hooverText: "Set search folder to current treeview selected folder"
            }
            Label {
                text: "In: "
            }
            CoreLabel {
                text: currentSearchFolder
            }
        }

        CoreThinBar {}
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
            Component {
                id: myfooter
                CorePagePadFooter {}
            }
            footer: myfooter
            clip: true

            ScrollBar.vertical: ScrollBar {}
            Layout.fillWidth: true
            Layout.fillHeight: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            delegate: RowLayout {

                CoreLabel {
                    text: modelData.replace(QmlAppSt.passwordStorePathStr,
                                            "").substring(
                              1,
                              modelData.replace(QmlAppSt.passwordStorePathStr,
                                                "").length - 4)
                }
                CoreButton {
                    text: "←"
                    onClicked: {
                        QmlAppSt.mainqmltype.setTreeViewSelected(modelData)
                    }
                    hooverText: "Select"
                }
                CoreButton {
                    text: "☍"
                    hooverText: "Clipboard rel.path"
                    onClicked: {
                        QmlAppSt.mainqmltype.clipboardRelPath(
                                    QmlAppSt.fullPathFolder,
                                    modelData.substr(0, modelData.length - 4))
                    }
                }
                Label {
                    visible: modelData === QmlAppSt.filePath
                    text: "⬤"
                }
            }
        }
    }
}
