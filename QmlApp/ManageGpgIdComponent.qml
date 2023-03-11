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
    Text {
        text: "gpg-id: " + nearestGpg
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
        Timer {
            id: timer
        }
        function delay(delayTime, cb) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.start();
        }


        id: reencryptBtnId
        enabled: classInitialized  && badEntriesRepeater.model.length === 0
                 && dropdownWithListComponentId.selectedItems.length > 0
        text: "Save changes to .gpg-id \n Recreate.gpg-pub-keys/ \n Re-encrypt all .gpg-id related files"
        onClicked: {
            reencryptBtnId.enabled = false;
            eencryptTextId.text = "Running... This might take long, Please wait"
            delay(1000, function() {
                mainLayout.getGpgIdManageType().saveChanges(dropdownWithListComponentId.selectedItems);
                initOnFileChanged();
                reencryptBtnId.enabled = true;
                eencryptTextId.text = ""
              })

        }
    }
    Text {
        id: eencryptTextId
        text: ""
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
