import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

import DropdownWithList
import QmlCore

Column {
    width: parent.width
    height: parent.height

    property alias badEntriesRepeater: badEntriesRepeater
    property alias dropdownWithListComponentId: dropdownWithListComponentId

    ScrollView {
        width: parent.width
        height: parent.height
        contentHeight: clid.height
        contentWidth: clid.width

        ColumnLayout {
            id: clid
            FileDialog {
                id: fileDialogImportAndTrustId
                title: "Please choose a .pub file to import and trust"
                fileMode: FileDialog.OpenFiles
                onAccepted: {
                    let serr = ""
                    currentFiles.forEach(f => {
                                             if (!serr) {
                                                 serr = mainLayout.getGpgIdManageType(
                                                     ).importPublicKeyAndTrust(
                                                     f)
                                                 eencryptTextId.text = serr
                                             }
                                         })
                    if (!serr) {
                        initOnFileChanged()
                    }
                }
                onRejected: {

                }
            }

            Label {
                visible: false
                text: "<h1>Manage .gpg-id<h1>"
            }
            CoreLabelAndText {
                coreLabel: "gpg-id"
                coreText: QmlAppSt.nearestGpg
            }
            CoreButton {
                text: "Import and trust a new public key"
                enabled: QmlAppSt.classInitialized
                onClicked: {
                    fileDialogImportAndTrustId.open()
                }
            }
            CoreButton {
                text: "Import all public keys in .public-keys/"
                enabled: QmlAppSt.classInitialized
                         && QmlAppSt.gpgPubKeysFolderExists
                onClicked: {
                    let serr = mainLayout.getGpgIdManageType(
                            ).importAllGpgPubKeysFolder()
                    eencryptTextId.text = serr
                    if (!serr) {
                        initOnFileChanged()
                    }
                }
            }

            CoreButton {
                Timer {
                    id: timer
                }

                id: reencryptBtnId
                enabled: QmlAppSt.classInitialized
                         && badEntriesRepeater.model.length === 0
                         && dropdownWithListComponentId.selectedItems.length > 0
                text: "Save changes to .gpg-id \n Recreate .public-keys/ \n Re-encrypt all .gpg-id related files"
                onClicked: {
                    reencryptBtnId.enabled = false
                    eencryptTextId.text = "Running... This might take long, Please wait"
                    mainLayout.doMainUiDisable()

                    mainLayout.getGpgIdManageType().saveChangesAsync(
                                dropdownWithListComponentId.selectedItems,
                                mainLayout.getMainqmltype(
                                    ).appSettingsType.doSign, returnStatus => {
                                    initOnFileChanged()
                                    reencryptBtnId.enabled = true
                                    eencryptTextId.text = returnStatus
                                    mainLayout.doMainUiEnable()
                                })
                }
            }
            Label {
                id: eencryptTextId
                text: ""
            }

            Label {
                text: "<h2>Bad .gpg-id entries<h2>"
                visible: badEntriesRepeater.model.length > 0
            }

            Repeater {
                id: badEntriesRepeater
                model: []
                RowLayout {
                    CoreLabel {
                        text: modelData
                    }
                }
            }

            DropdownWithListComponent {
                id: dropdownWithListComponentId
            }

            CorePagePadFooter {}
        }
    }
}
