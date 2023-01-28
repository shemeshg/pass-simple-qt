import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias badEntriesRepeater: badEntriesRepeater
    property alias dropdownWithListComponentId: dropdownWithListComponentId

    FileDialog {
        id: fileDialogImportAndTrustId
        title: "Please choose a .pub file to import and trust"
        onAccepted: {
            mainLayout.getGpgIdManageType().importPublicKeyAndTrust(fileDialogImportAndTrustId.selectedFile);
            initOnFileChanged();
        }
        onRejected: {
        }
    }

    Text {
        text: "<h1>Manage .gpg-id<h1>"
    }
    Button {
        text: "Import and trust a new public key"
        enabled: classInitialized
        onClicked: { fileDialogImportAndTrustId.open()}
    }
    Button {
        text: "Import all public keys in .gpg-pub-keys/"
        enabled: classInitialized && gpgPubKeysFolderExists
        onClicked: {
            mainLayout.getGpgIdManageType().importAllGpgPubKeysFolder();
            initOnFileChanged();
        }
    }
    Button {
        enabled: classInitialized && gpgPubKeysFolderExists && badEntriesRepeater.model.length === 0
                 && dropdownWithListComponentId.selectedItems.length > 0
        text: "Save changes to .gpg-id \n Recreate.gpg-pub-keys/ \n Re-encrypt all .gpg-id related files"
        onClicked: {
            mainLayout.getGpgIdManageType().saveChanges(dropdownWithListComponentId.selectedItems);
            initOnFileChanged();
        }
    }
    Text {
        text: "<h2>Bad .gpg-id entries<h2>"
        visible: badEntriesRepeater.model.length > 0
    }

    Repeater {
        id: badEntriesRepeater
        model: []
        RowLayout{
            Label {
                text:  modelData
            }
        }
    }


    DropdownWithListComponent {
        id: dropdownWithListComponentId
    }
}
