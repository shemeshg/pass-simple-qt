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
                coreText: filePath
            }
            CoreLabelAndText {
                coreLabel: "Git"
                coreText: nearestGit
            }
            RowLayout {
                CoreButton {
                    text: "status"
                    enabled: nearestGit
                    onClicked: {
                        let s = getMainqmltype().runCmd(
                                [mainLayout.getMainqmltype(
                                     ).appSettingsType.gitExecPath, "-C", nearestGit, "status"],
                                " 2>&1")
                        gitResponseId = s
                    }
                }
                CoreButton {
                    text: "add commit all"
                    enabled: nearestGit
                    onClicked: {
                        let addAll = getMainqmltype().runCmd(
                                [mainLayout.getMainqmltype(
                                     ).appSettingsType.gitExecPath, "-C", nearestGit, "add", "."],
                                " 2>&1")
                        let commitAm = getMainqmltype().runCmd(
                                [mainLayout.getMainqmltype(
                                     ).appSettingsType.gitExecPath, "-C", nearestGit, "commit", "-am", "pass simple"],
                                " 2>&1")
                        gitResponseId = "Add:\n" + addAll + "\n" + "Commit:\n" + commitAm
                    }
                }
                CoreButton {
                    text: "pull push"
                    enabled: nearestGit
                    onClicked: {

                        let pull = getMainqmltype().runCmd(
                                [mainLayout.getMainqmltype(
                                     ).appSettingsType.gitExecPath, "-C", nearestGit, "pull"],
                                " 2>&1")
                        let push = getMainqmltype().runCmd(
                                [mainLayout.getMainqmltype(
                                     ).appSettingsType.gitExecPath, "-C", nearestGit, "push"],
                                " 2>&1")
                        gitResponseId = "Pull:\n" + pull + "\nPush:\n" + push
                    }
                }
            }

            CoreTextArea {
                text: gitResponseId
                readOnly: true
            }

            CoreLabelAndText {
                id: nearestGpgIdId
                coreLabel: "GpgId"
                coreText: nearestGpg
            }
            CoreLabelAndText {
                coreLabel: "Signed By"
                coreText: decryptedSignedById
            }
            Label {
                text: "<h2>Wait Items</h2>"
            }
            Repeater {
                model: waitItems
                RowLayout {
                    CoreLabel {
                        text: modelData
                    }
                    CoreButton {
                        text: "select"
                        onClicked: getMainqmltype().setTreeViewSelected(
                                       modelData)
                    }
                }
            }

            Label {
                text: "<h2>None Wait Items</h2>"
            }
            Repeater {
                model: noneWaitItems
                RowLayout {
                    CoreLabel {
                        text: modelData
                    }
                    CoreButton {
                        text: "select"
                        onClicked: getMainqmltype().setTreeViewSelected(
                                       modelData)
                    }
                }
            }
            CorePagePadFooter {}
        }
    }
}
