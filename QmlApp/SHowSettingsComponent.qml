import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QmlCore

ScrollView {
    visible: QmlAppSt.isShowSettings
    width: parent.width
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    contentWidth: columnLayoutHomeId.width - 30

    property bool isUseClipboard: QmlAppSt.mainqmltype.appSettingsType.useClipboard
    property bool isUseMonospaceFont: QmlAppSt.mainqmltype.appSettingsType.useMonospaceFont
    property bool isAllowScreenCapture: QmlAppSt.mainqmltype.appSettingsType.allowScreenCapture
    property bool isUseRnpgp: QmlAppSt.mainqmltype.appSettingsType.useRnpgp
    property bool isPreferYamlView: QmlAppSt.mainqmltype.appSettingsType.preferYamlView
    property bool isDoSign: QmlAppSt.mainqmltype.appSettingsType.doSign

    onVisibleChanged: {
        if (visible) {
            isUseClipboard = QmlAppSt.mainqmltype.appSettingsType.useClipboard
            isUseMonospaceFont = QmlAppSt.mainqmltype.appSettingsType.useMonospaceFont
            useMonospaceFont.checked = isUseMonospaceFont
            isUseRnpgp = QmlAppSt.mainqmltype.appSettingsType.useRnpgp
            isAllowScreenCapture = QmlAppSt.mainqmltype.appSettingsType.allowScreenCapture
            useClipboard.checked = isUseClipboard
            isPreferYamlView = QmlAppSt.mainqmltype.appSettingsType.preferYamlView
            preferYamlView.checked = isPreferYamlView
            isDoSign = QmlAppSt.mainqmltype.appSettingsType.doSign
            doSign.checked = isDoSign
            QmlAppSt.passwordStorePathStr = QmlAppSt.mainqmltype.appSettingsType.passwordStorePath

            ctxSigner.currentIndex = QmlAppSt.allPrivateKeys.indexOf(
                        QmlAppSt.mainqmltype.appSettingsType.ctxSigner)
            tmpFolderPath.text = QmlAppSt.mainqmltype.appSettingsType.tmpFolderPath
            gitExecPath.text = QmlAppSt.mainqmltype.appSettingsType.gitExecPath
            rnpgpHome.text = QmlAppSt.mainqmltype.appSettingsType.rnpgpHome
            vscodeExecPath.text = QmlAppSt.mainqmltype.appSettingsType.vscodeExecPath
            autoTypeCmd.text = QmlAppSt.mainqmltype.appSettingsType.autoTypeCmd
            fontSize.text = QmlAppSt.mainqmltype.appSettingsType.fontSize
            commitMsg.text = QmlAppSt.mainqmltype.appSettingsType.commitMsg
            binaryExts.text = QmlAppSt.mainqmltype.appSettingsType.binaryExts
            ignoreSearch.text = QmlAppSt.mainqmltype.appSettingsType.ignoreSearch
            ddListStores.text = QmlAppSt.mainqmltype.appSettingsType.ddListStores
            passwordStoreId.text = QmlAppSt.passwordStorePathStr
            // Refactore showSettings
            rnpPassFromStdExec.checked = QmlAppSt.mainqmltype.appSettingsType.rnpPassFromStdExec
            rnpPassStdExecPath.text = QmlAppSt.mainqmltype.appSettingsType.rnpPassStdExecPath
            //End refactor way of settings
            comboLstStoresCompleted()
        }
    }

    function comboLstStoresCompleted() {
        comboLstStores.currentIndex = 0
        for (var i = 0; i < comboLstStores.model.length; i++) {
            if (comboLstStores.model[i].value === passwordStoreId.text) {
                comboLstStores.currentIndex = i
                break
            }
        }
    }

    function setComboLstStoresModel() {
        var s = ddListStores.text
        var ret = [{
                       "text": "",
                       "value": ""
                   }]
        var lines = s.split("\n")
        lines.forEach(r => {
                          if (r.includes("#")) {
                              let row = r.split("#")
                              ret.push({
                                           "text": row[0].trim(),
                                           "value": row[1].trim()
                                       })
                          }
                      })

        return ret
    }

    function saveSettingsComponent() {
        if (!Number(fontSize.text)) {
            fontSize.text = ""
        }
        QmlAppSt.mainqmltype.submitAppSettingsPasswordStorePath(
                    passwordStoreId.text)
        QmlAppSt.mainqmltype.appSettingsType.rnpPassFromStdExec = rnpPassFromStdExec.checked
        QmlAppSt.mainqmltype.appSettingsType.rnpPassStdExecPath = rnpPassStdExecPath.text
        QmlAppSt.mainqmltype.appSettingsType.tmpFolderPath = tmpFolderPath.text
        QmlAppSt.mainqmltype.appSettingsType.gitExecPath = gitExecPath.text
        QmlAppSt.mainqmltype.appSettingsType.rnpgpHome = rnpgpHome.text
        QmlAppSt.mainqmltype.appSettingsType.vscodeExecPath = vscodeExecPath.text
        QmlAppSt.mainqmltype.appSettingsType.autoTypeCmd = autoTypeCmd.text
        QmlAppSt.mainqmltype.appSettingsType.binaryExts = binaryExts.text
        QmlAppSt.mainqmltype.appSettingsType.ignoreSearch = ignoreSearch.text
        QmlAppSt.mainqmltype.appSettingsType.useClipboard = useClipboard.checked
        QmlAppSt.mainqmltype.appSettingsType.useMonospaceFont = useMonospaceFont.checked
        QmlAppSt.mainqmltype.appSettingsType.allowScreenCapture = allowScreenCapture.checked
        QmlAppSt.mainqmltype.appSettingsType.useRnpgp = useRnpgp.checked
        QmlAppSt.mainqmltype.appSettingsType.doSign = doSign.checked
        QmlAppSt.mainqmltype.appSettingsType.preferYamlView = preferYamlView.checked
        QmlAppSt.mainqmltype.appSettingsType.fontSize = fontSize.text
        QmlAppSt.mainqmltype.appSettingsType.commitMsg = commitMsg.text
        QmlAppSt.mainqmltype.appSettingsType.ddListStores = ddListStores.text
        QmlAppSt.mainqmltype.appSettingsType.ctxSigner = ctxSigner.currentText
        QmlAppSt.passwordStorePathStr = QmlAppSt.mainqmltype.appSettingsType.passwordStorePath

        QmlAppSt.isShowSettings = false
    }

    ColumnLayout {

        height: parent.height
        width: parent.width

        Layout.fillWidth: true
        Layout.fillHeight: true

        SettingsLabelComboBox {
            id: comboLstStores
            labelText: "Password Store Path:"
            textRole: "text"
            valueRole: "value"
            onActivated1: () => {
                              if (currentValue == currentText
                                  && currentText === "") {
                                  return
                              }

                              passwordStoreId.text = currentValue
                          }

            Component.onCompleted: {
                comboLstStoresCompleted()
            }

            model: {
                return setComboLstStoresModel()
            }
        }
        SettingsSelectFolder {
            id: passwordStoreId
            hooverText: "Select folder<br/>Use empty string for default"
            onSetPath: s => {
                           passwordStoreId.text = s
                       }
            onTextChanged1: {
                comboLstStoresCompleted()
            }
        }

        SettingsLabelTextArea {
            id: ddListStores
            labelText: "Dropdown list:"
            text: QmlAppSt.mainqmltype.appSettingsType.ddListStores
            onTextEntered: {
                comboLstStores.model = setComboLstStoresModel()
                comboLstStoresCompleted()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
        }

        SettingsLabelTextArea {
            id: commitMsg
            labelText: "Commit Msg.:"
            text: QmlAppSt.mainqmltype.appSettingsType.commitMsg
        }

        SettingsLabelComboBox {
            id: ctxSigner
            labelText: "Private personal Id: "
            model: QmlAppSt.allPrivateKeys
            Component.onCompleted: {
                currentIndex = QmlAppSt.allPrivateKeys.indexOf(
                            QmlAppSt.mainqmltype.appSettingsType.ctxSigner)
            }
        }

        Label {
            text: "Temporary directory:"
        }
        SettingsSelectFolder {
            id: tmpFolderPath
            text: QmlAppSt.mainqmltype.appSettingsType.tmpFolderPath
            hooverText: "Select folder<br/>Use empty string for default"
            onSetPath: s => {
                           tmpFolderPath.text = s
                       }
        }

        SettingsLabelTextField {
            id: gitExecPath
            labelText: "<b>git</b> executable full path:"
            text: QmlAppSt.mainqmltype.appSettingsType.gitExecPath
        }
        SettingsLabelTextField {
            id: vscodeExecPath
            labelText: "<b>Visual Studio Code</b> executable full path:"
            text: QmlAppSt.mainqmltype.appSettingsType.vscodeExecPath
        }
        SettingsLabelTextField {
            visible: Qt.platform.os === "linux"
            id: autoTypeCmd
            labelText: "Linux only autotype cmd:"
            text: QmlAppSt.mainqmltype.appSettingsType.autoTypeCmd
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
        }
        CoreSwitch {
            id: useMonospaceFont
            text: qsTr("Use monospace font for TextEdit")
            checked: isUseMonospaceFont
        }
        SettingsLabelTextField {
            id: fontSize
            labelText: "Font size (reopen app required):"
            text: QmlAppSt.mainqmltype.appSettingsType.fontSize
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
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
        CoreSwitch {
            id: allowScreenCapture
            visible: Qt.platform.os !== "linux"
            text: qsTr("Allow screen capture")
            checked: isAllowScreenCapture
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
            visible: useRnpgp.checked
        }
        CoreSwitch {
            id: useRnpgp
            enabled: Qt.platform.os !== "windows"
            text: qsTr("Use Rnpgp")
            checked: isUseRnpgp
        }
        Label {
            visible: useRnpgp.checked
            text: "Rnp home folder:"
        }

        SettingsSelectFolder {
            id: rnpgpHome
            visible: useRnpgp.checked
            text: QmlAppSt.mainqmltype.appSettingsType.rnpgpHome
            hooverText: "Rnp home folder"
            onSetPath: s => {
                           rnpgpHome.text = s
                       }
        }
        CoreSwitch {
            id: rnpPassFromStdExec
            visible: useRnpgp.checked
            text: qsTr("Rnp password from std exec (Rnp & Yubikey integration)")
        }
        SettingsLabelTextField {
            id: rnpPassStdExecPath
            visible: useRnpgp.checked && rnpPassFromStdExec.checked
            labelText: "Rnp password std exec path:"
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: CoreSystemPalette.text
            visible: useRnpgp.checked
        }
        SettingsLabelTextArea {
            id: binaryExts
            labelText: "Binary extensions:"
            text: QmlAppSt.mainqmltype.appSettingsType.binaryExts
        }
        SettingsLabelTextArea {
            id: ignoreSearch
            labelText: "Ignore search:"
            text: QmlAppSt.mainqmltype.appSettingsType.ignoreSearch
        }
        CorePagePadFooter {}
    }
}
