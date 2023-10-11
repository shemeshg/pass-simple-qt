import QmlCore

CoreDialogYesNo {
    id: renameDialog
    title: "Set  name"

    CoreTextField {
        id: fieldName
        text: ""
        width: parent.width
    }

    onOpened: {
        fieldName.text = QmlAppSt.filePath.replace(fullPathFolder,
                                                   "").substring(
                    1, QmlAppSt.filePath.replace(fullPathFolder, "").length - 4)
    }
    onAccepted: {
        if (saveBtnId.visible && saveBtnId.enabled) {
            saveBtnId.clicked()
        }
        mainLayout.getMainqmltype().renameGpgFile(
                    QmlAppSt.filePath,
                    fullPathFolder + "/" + fieldName.text + ".gpg")
    }
    onClosed: {
        fieldName.text = QmlAppSt.filePath.replace(fullPathFolder,
                                                   "").substring(
                    1, QmlAppSt.filePath.replace(fullPathFolder, "").length - 4)
    }
}
