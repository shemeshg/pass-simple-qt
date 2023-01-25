import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QmlApp


Item {

    id: mainLayout

    function getDecrypted() {
        return mainqmltype.getDecrypted();
    }

    function getNearestGit() {
        return mainqmltype.getNearestGit();
    }

    function getNearestGpgId() {
        return mainqmltype.getNearestGpgId();
    }

    function getDecryptedSignedBy() {
        return mainqmltype.getDecryptedSignedBy();
    }

    function getGpgIdManageType() {
        return mainqmltype.gpgIdManageType;
    }

    function encrypt(s){
        return mainqmltype.encrypt(s);
    }

    function openExternalEncryptWait(){
        return mainqmltype.openExternalEncryptWait();
    }
    function openExternalEncryptNoWait(){
        return mainqmltype.openExternalEncryptNoWait()
    }
    function closeExternalEncryptNoWait(){
        mainqmltype.closeExternalEncryptNoWait();
    }

    QmlAppComponent {
        id: qmlAppComponent
    }

    Binding {
        target: qmlAppComponent
        property: "filePanSize"
        value: mainqmltype.filePanSize
    }


    Binding {
        target: qmlAppComponent
        property: "filePath"
        value: mainqmltype.filePath
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


    signal toggleFilepan()
    onToggleFilepan: mainqmltype.toggleFilepan();


}


