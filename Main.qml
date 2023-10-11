import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QmlApp

Item {

    id: mainLayout

    property bool isShowLog: false
    property bool isMainUiDisabled: false

    function doMainUiDisable() {
        isMainUiDisabled = true
        getMainqmltype().doMainUiDisable()
    }

    function doMainUiEnable() {
        isMainUiDisabled = false
        getMainqmltype().doMainUiEnable()
    }

    function getMainqmltype() {
        return mainqmltype
    }

    function getDecrypted() {
        return mainqmltype.getDecrypted()
    }

    function getNearestGit() {
        return mainqmltype.getNearestGit()
    }

    function getNearestTemplateGpg() {
        return mainqmltype.getNearestTemplateGpg()
    }

    function getNearestGpgId() {
        return mainqmltype.getNearestGpgId()
    }

    function getDecryptedSignedBy() {
        return mainqmltype.getDecryptedSignedBy()
    }

    function getGpgIdManageType() {
        return mainqmltype.gpgIdManageType
    }

    function encrypt(s) {
        return mainqmltype.encrypt(s)
    }

    function encryptAsync(s, callback) {
        return mainqmltype.encryptAsync(s, callback)
    }

    function openExternalEncryptWait() {
        return mainqmltype.openExternalEncryptWait()
    }
    function openExternalEncryptNoWait() {
        return mainqmltype.openExternalEncryptNoWait()
    }
    function closeExternalEncryptNoWait() {
        mainqmltype.closeExternalEncryptNoWait()
    }

    QmlAppComponent {
        id: qmlAppComponent
        anchors.fill: parent
        visible: !isShowLog
    }

    ExceptionAndLog {
        id: exceptionAndLog
    }

    Binding {
        target: qmlAppComponent
        property: "filePanSize"
        value: mainqmltype.filePanSize
    }


    /*
    Binding {
        target: QmlAppSt
        property: "filePath"
        value: mainqmltype.filePath
    }
    */
    Binding {
        target: qmlAppComponent
        property: "menubarCommStr"
        value: mainqmltype.menubarCommStr
    }

    Binding {
        target: qmlAppComponent
        property: "waitItems"
        value: mainqmltype.waitItems
    }

    Binding {
        target: qmlAppComponent
        property: "noneWaitItems"
        value: mainqmltype.noneWaitItems
    }

    Binding {
        target: exceptionAndLog
        property: "exceptionCounter"
        value: mainqmltype.exceptionCounter
    }

    Binding {
        target: exceptionAndLog
        property: "exceptionStr"
        value: mainqmltype.exceptionStr
    }

    signal toggleFilepan
    onToggleFilepan: mainqmltype.toggleFilepan()
}
