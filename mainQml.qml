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


    signal toggleFilepan()
    onToggleFilepan: mainqmltype.toggleFilepan();


}


