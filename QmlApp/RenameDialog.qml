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
        fieldName.text = QmlAppSt.filePath.replace(QmlAppSt.fullPathFolder,
                                                   "").substring(
                    1, QmlAppSt.filePath.replace(QmlAppSt.fullPathFolder,
                                                 "").length - 4)
    }
    onAccepted: {
        QmlAppSt.mainqmltype.renameGpgFile(
                    QmlAppSt.filePath,
                    QmlAppSt.fullPathFolder + "/" + fieldName.text + ".gpg")
    }
    onClosed: {


        /*
        fieldName.text = QmlAppSt.filePath.replace(QmlAppSt.fullPathFolder,
                                                   "").substring(
                    1, QmlAppSt.filePath.replace(QmlAppSt.fullPathFolder,
                                                 "").length - 4)
                                                 */
    }
}
