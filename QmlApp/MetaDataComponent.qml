import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QmlCore

Column {
    width: parent.width
    height: parent.height

    property string decryptedSignedById: ""
    property string gitResponseId: ""
    ScrollView {

        width: parent.width
        height: parent.height
        contentHeight: clid.height
        contentWidth: clid.width

        ColumnLayout {
            id: clid

            Label {
                text: "<h1>Meta data<h1>"
                visible: false
            }

            CoreLabelAndText {
                id: nameId
                coreLabel: "File"
                coreText: QmlAppSt.filePath
            }
            CoreLabelAndText {
                coreLabel: "Git"
                coreText: QmlAppSt.nearestGit
            }
            RowLayout {
                CoreButton {
                    text: "status"
                    enabled: QmlAppSt.nearestGit
                    onClicked: {
                        let s = QmlAppSt.mainqmltype.runCmd(
                                [QmlAppSt.mainqmltype.appSettingsType.gitExecPath, "-C", QmlAppSt.nearestGit, "status"],
                                " 2>&1")
                        gitResponseId = s
                    }
                }
                CoreButton {
                    text: "add commit all"
                    enabled: QmlAppSt.nearestGit
                    onClicked: {
                        let addAll = QmlAppSt.mainqmltype.runCmd(
                                [QmlAppSt.mainqmltype.appSettingsType.gitExecPath, "-C", QmlAppSt.nearestGit, "add", "."],
                                " 2>&1")
                        let commitAm = QmlAppSt.mainqmltype.runCmd(
                                [QmlAppSt.mainqmltype.appSettingsType.gitExecPath, "-C", QmlAppSt.nearestGit, "commit", "-am", "pass simple"],
                                " 2>&1")
                        gitResponseId = "Add:\n" + addAll + "\n" + "Commit:\n" + commitAm
                    }
                }
                CoreButton {
                    text: "pull push"
                    enabled: QmlAppSt.nearestGit
                    onClicked: {

                        let pull = QmlAppSt.mainqmltype.runCmd(
                                [QmlAppSt.mainqmltype.appSettingsType.gitExecPath, "-C", QmlAppSt.nearestGit, "pull"],
                                " 2>&1")
                        let push = QmlAppSt.mainqmltype.runCmd(
                                [QmlAppSt.mainqmltype.appSettingsType.gitExecPath, "-C", QmlAppSt.nearestGit, "push"],
                                " 2>&1")
                        gitResponseId = "Pull:\n" + pull + "\nPush:\n" + push
                    }
                }
            }
            RowLayout {
                CoreTextArea {
                    text: gitResponseId
                    readOnly: true
                }
            }

            CoreLabelAndText {
                id: nearestGpgIdId
                coreLabel: "GpgId"
                coreText: QmlAppSt.nearestGpg
            }
            CoreLabelAndText {
                coreLabel: "Signed By"
                coreText: decryptedSignedById
            }

            RowLayout {
                Label {
                    text: "<h2>Opened Items</h2>"
                }
                CoreButton {
                    text: "Save and Close All"
                    Layout.alignment: Qt.AlignTop
                    visible: QmlAppSt.noneWaitItems.length > 0
                    onClicked: {
                        QmlAppSt.mainqmltype.closeAllExternalEncryptNoWait()
                    }
                }
                CoreButton {
                    text: "Discard All"
                    Layout.alignment: Qt.AlignTop
                    visible: QmlAppSt.noneWaitItems.length > 0
                    onClicked: {
                        QmlAppSt.mainqmltype.discardAllChangesEncryptNoWait()
                    }
                }
            }
            RowLayout {
                CoreTextField {
                    id: txtFilter
                    placeholderText: "filter"
                    Layout.fillWidth: true
                    visible: QmlAppSt.noneWaitItems.length > 0
                }
            }
            Repeater {
                model: QmlAppSt.noneWaitItems
                RowLayout {
                    visible: modelDataTxt.text.includes(txtFilter.text)
                    CoreLabel {
                        id: modelDataTxt
                        text: modelData.replace(QmlAppSt.passwordStorePathStr,
                                                "").substring(
                                  1, modelData.replace(
                                      QmlAppSt.passwordStorePathStr,
                                      "").length - 4)
                    }
                    CoreButton {
                        text: "←"
                        onClicked: QmlAppSt.mainqmltype.setTreeViewSelected(
                                       modelData)
                        hooverText: "Select"
                    }
                    CoreButton {
                        text: "Save and Close"
                        onClicked: {
                            QmlAppSt.mainqmltype.closeExternalEncryptNoWait()
                        }
                        visible: !QmlAppSt.isShowPreview
                                 && QmlAppSt.noneWaitItems.indexOf(
                                     QmlAppSt.filePath) > -1
                                 && !QmlAppSt.isBinaryFile
                                 && modelData === QmlAppSt.filePath
                    }
                    CoreButton {
                        text: "Show Folder"
                        onClicked: {

                            QmlAppSt.mainqmltype.showFolderEncryptNoWait()
                        }
                        visible: !QmlAppSt.isShowPreview
                                 && QmlAppSt.noneWaitItems.indexOf(
                                     QmlAppSt.filePath) > -1
                                 && !QmlAppSt.isBinaryFile
                                 && modelData === QmlAppSt.filePath
                    }
                    CoreButton {
                        text: "Discard changes"
                        onClicked: {

                            QmlAppSt.mainqmltype.discardChangesEncryptNoWait()
                        }
                        visible: !QmlAppSt.isShowPreview
                                 && QmlAppSt.noneWaitItems.indexOf(
                                     QmlAppSt.filePath) > -1
                                 && !QmlAppSt.isBinaryFile
                                 && modelData === QmlAppSt.filePath
                    }
                }
            }
            CorePagePadFooter {}
        }
    }
}
