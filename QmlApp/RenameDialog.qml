import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

CoreDialogYesNo {
    id: renameDialog
    title: "Set  name"

    TextField {
        id: fieldName
        text: ""
        width: parent.width
    }

    onOpened: {
        fieldName.text = filePath.replace(fullPathFolder, "").substring(
                    1, filePath.replace(fullPathFolder, "").length - 4)
    }
    onAccepted: {
        if (saveBtnId.visible && saveBtnId.enabled) {
            saveBtnId.clicked()
        }
        mainLayout.getMainqmltype().renameGpgFile(
                    filePath, fullPathFolder + "/" + fieldName.text + ".gpg")
    }
    onClosed: {
        fieldName.text = filePath.replace(fullPathFolder, "").substring(
                    1, filePath.replace(fullPathFolder, "").length - 4)
    }
}
