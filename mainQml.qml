import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QmlApp


ColumnLayout {


    id: mainLayout
    anchors.fill: parent

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


