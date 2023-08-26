import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import DropdownWithList
import Qt.labs.platform

ScrollView {
    visible: isShowSettings
    height: parent.height
    width: parent.width
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    contentWidth: columnLayoutHomeId.width - 30
    contentHeight: columnLayoutHomeId.height + 200

    property bool isUseClipboard: mainLayout.getMainqmltype(
                                      ).appSettingsType.useClipboard
    property bool isPreferYamlView: mainLayout.getMainqmltype(
                                        ).appSettingsType.preferYamlView
    property bool isDoSign: mainLayout.getMainqmltype().appSettingsType.doSign

    onVisibleChanged: {
        if (visible) {
            isUseClipboard = mainLayout.getMainqmltype(
                        ).appSettingsType.useClipboard
            useClipboard.checked = isUseClipboard
            isPreferYamlView = mainLayout.getMainqmltype(
                        ).appSettingsType.preferYamlView
            preferYamlView.checked = isPreferYamlView
            isDoSign = mainLayout.getMainqmltype().appSettingsType.doSign
            doSign.checked = isDoSign
            passwordStorePathStr = mainLayout.getMainqmltype(
                        ).appSettingsType.passwordStorePath
            ctxSigner.currentIndex = ctxSigner.find(
                        mainLayout.getMainqmltype().appSettingsType.ctxSigner)
            tmpFolderPath.text = mainLayout.getMainqmltype(
                        ).appSettingsType.tmpFolderPath
            gitExecPath.text = mainLayout.getMainqmltype(
                        ).appSettingsType.gitExecPath
            vscodeExecPath.text = mainLayout.getMainqmltype(
                        ).appSettingsType.vscodeExecPath
            autoTypeCmd.text = mainLayout.getMainqmltype(
                        ).appSettingsType.autoTypeCmd
            fontSize.text = mainLayout.getMainqmltype().appSettingsType.fontSize
            commitMsg.text = mainLayout.getMainqmltype(
                        ).appSettingsType.commitMsg
            binaryExts.text = mainLayout.getMainqmltype(
                        ).appSettingsType.binaryExts
        }
    }

    FolderDialog {
        id: selectStorePathDialogId
        title: "Select folder"
        onAccepted: {
            let path = selectStorePathDialogId.folder.toString()
            path = path.replace(/^(file:\/{3})/, "")
            // unescape html codes like '%23' for '#'
            path = decodeURIComponent(path)

            //path =  path.substring(0, path.lastIndexOf("/")) ;
            passwordStorePathStr = "/" + path
        }
        onRejected: {

        }
    }

    function saveSettingsComponent() {
        if (!Number(fontSize.text)) {
            fontSize.text = ""
        }

        mainLayout.getMainqmltype(
                    ).submit_AppSettingsType(passwordStorePathStr,
                                             tmpFolderPath.text, gitExecPath.text,
                                             vscodeExecPath.text, autoTypeCmd.text,
                                             binaryExts.text, useClipboard.checked,
                                             doSign.checked, preferYamlView.checked,
                                             fontSize.text, commitMsg.text,
                                             ctxSigner.displayText)
        passwordStorePathStr = mainLayout.getMainqmltype(
                    ).appSettingsType.passwordStorePath
        isShowSettings = false
    }

    ColumnLayout {

        height: parent.height
        width: parent.width

        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {
            Button {
                text: "Back"
                onClicked: isShowSettings = false
            }
            Button {
                text: "Save"
                onClicked: saveSettingsComponent()
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: systemPalette.alternateBase
        }

        RowLayout {
            Label {
                text: "Password Store Path:"
            }
            Button {
                text: "default"
                onClicked: passwordStorePathStr = ""
            }
            Button {
                text: "select"
                onClicked: selectStorePathDialogId.open()
            }
        }

        RowLayout {
            TextField {
                text: passwordStorePathStr
                Layout.fillWidth: true
                onTextChanged: passwordStorePathStr = text
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: systemPalette.text
        }
        ColumnLayout {
            Label {
                text: "Commit Msg."
            }
            TextArea {
                id: commitMsg
                text: mainLayout.getMainqmltype().appSettingsType.commitMsg
                Layout.fillWidth: true
            }
        }

        ColumnLayout {
            spacing: 8

            Label {
                text: "Private personal Id: "
            }
            ComboBox {
                id: ctxSigner
                model: allPrivateKeys
                Component.onCompleted: {
                    currentIndex = find(mainLayout.getMainqmltype(
                                            ).appSettingsType.ctxSigner)
                }
                Layout.fillWidth: true
            }
            Label {
                text: "Temporary directory"
            }
            TextField {
                id: tmpFolderPath
                text: mainLayout.getMainqmltype().appSettingsType.tmpFolderPath
                Layout.fillWidth: true
            }
            Label {
                text: "<b>git</b> executable full path"
            }
            TextField {
                id: gitExecPath
                text: mainLayout.getMainqmltype().appSettingsType.gitExecPath
                Layout.fillWidth: true
            }
            Label {
                text: "<b>Visual Studio Code</b> executable full path"
            }
            TextField {
                id: vscodeExecPath
                text: mainLayout.getMainqmltype().appSettingsType.vscodeExecPath
                Layout.fillWidth: true
            }
            ColumnLayout {
                Layout.fillWidth: true
                visible: Qt.platform.os === "linux"
                Label {
                    text: "Linux only autotype cmd"
                }
                TextField {
                    id: autoTypeCmd
                    text: mainLayout.getMainqmltype(
                              ).appSettingsType.autoTypeCmd
                    Layout.fillWidth: true
                }
            }
            ColumnLayout {
                Label {
                    text: "Font size (reopen app required)"
                }
                TextField {
                    id: fontSize
                    text: mainLayout.getMainqmltype().appSettingsType.fontSize
                    Layout.fillWidth: true
                }
            }
            Switch {
                id: preferYamlView
                text: qsTr("Prefer Yaml view if Yaml valid")
                checked: isPreferYamlView
            }
            Switch {
                id: useClipboard
                text: qsTr("Use clipboard")
                checked: isUseClipboard
            }
            Switch {
                id: doSign
                text: qsTr("Sign")
                checked: isDoSign
            }
            ColumnLayout {
                Layout.fillWidth: true
                Label {
                    text: "Binary extensions"
                }
                TextArea {
                    id: binaryExts
                    selectionColor: systemPalette.highlight
                    selectedTextColor: systemPalette.highlightedText
                    text: mainLayout.getMainqmltype().appSettingsType.binaryExts
                    Layout.fillWidth: true
                }
            }
        }
    }
}
