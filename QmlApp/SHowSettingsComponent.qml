import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

import QmlCore

ScrollView {
    visible: QmlAppSt.isShowSettings
    width: parent.width
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    contentWidth: columnLayoutHomeId.width - 30

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
            QmlAppSt.passwordStorePathStr = mainLayout.getMainqmltype(
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
            let path = selectStorePathDialogId.currentFolder.toString()
            path = path.replace(/^(file:\/{3})/, "")
            // unescape html codes like '%23' for '#'
            path = decodeURIComponent(path)

            //path =  path.substring(0, path.lastIndexOf("/")) ;
            QmlAppSt.passwordStorePathStr = "/" + path
        }
        onRejected: {

        }
    }

    function saveSettingsComponent() {
        if (!Number(fontSize.text)) {
            fontSize.text = ""
        }

        mainLayout.getMainqmltype(
                    ).submit_AppSettingsType(QmlAppSt.passwordStorePathStr,
                                             tmpFolderPath.text, gitExecPath.text,
                                             vscodeExecPath.text, autoTypeCmd.text,
                                             binaryExts.text, useClipboard.checked,
                                             doSign.checked, preferYamlView.checked,
                                             fontSize.text, commitMsg.text,
                                             ctxSigner.displayText)
        QmlAppSt.passwordStorePathStr = mainLayout.getMainqmltype(
                    ).appSettingsType.passwordStorePath
        QmlAppSt.isShowSettings = false
    }

    ColumnLayout {

        height: parent.height
        width: parent.width

        Layout.fillWidth: true
        Layout.fillHeight: true

        RowLayout {
            CoreButton {
                text: "Back"
                onClicked: QmlAppSt.isShowSettings = false
            }
            CoreButton {
                text: "Save"
                onClicked: saveSettingsComponent()
            }
        }
        CoreThinBar {}

        RowLayout {
            Label {
                text: "Password Store Path:"
            }
            CoreButton {
                text: "default"
                onClicked: QmlAppSt.passwordStorePathStr = ""
            }
            CoreButton {
                text: "select"
                onClicked: selectStorePathDialogId.open()
            }
        }

        RowLayout {
            CoreTextField {
                text: QmlAppSt.passwordStorePathStr
                Layout.fillWidth: true
                onTextChanged: QmlAppSt.passwordStorePathStr = text
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
        }

        Label {
            text: "Commit Msg."
        }
        CoreTextArea {
            id: commitMsg
            text: mainLayout.getMainqmltype().appSettingsType.commitMsg
            Layout.fillWidth: true
        }

        Label {
            text: "Private personal Id: "
        }
        CoreComboBox {
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
        CoreTextField {
            id: tmpFolderPath
            text: mainLayout.getMainqmltype().appSettingsType.tmpFolderPath
            Layout.fillWidth: true
        }
        Label {
            text: "<b>git</b> executable full path"
        }
        CoreTextField {
            id: gitExecPath
            text: mainLayout.getMainqmltype().appSettingsType.gitExecPath
            Layout.fillWidth: true
        }
        Label {
            text: "<b>Visual Studio Code</b> executable full path"
        }
        CoreTextField {
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
            CoreTextField {
                id: autoTypeCmd
                text: mainLayout.getMainqmltype().appSettingsType.autoTypeCmd
                Layout.fillWidth: true
            }
        }
        Label {
            text: "Font size (reopen app required)"
        }
        CoreTextField {
            id: fontSize
            text: mainLayout.getMainqmltype().appSettingsType.fontSize
            Layout.fillWidth: true
        }

        CoreSwitch {
            id: preferYamlView
            text: qsTr("Prefer Yaml view if Yaml valid")
            checked: isPreferYamlView
        }
        CoreSwitch {
            id: useClipboard
            text: qsTr("Use clipboard")
            checked: isUseClipboard
        }
        CoreSwitch {
            id: doSign
            text: qsTr("Sign")
            checked: isDoSign
        }
        Label {
            text: "Binary extensions"
        }
        CoreTextArea {
            id: binaryExts
            text: mainLayout.getMainqmltype().appSettingsType.binaryExts
            Layout.fillWidth: true
        }
        CorePagePadFooter {}
    }
}
