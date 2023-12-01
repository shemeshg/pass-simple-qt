import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QmlApp

Item {

    id: mainLayout

    QmlAppComponent {
        id: qmlAppComponent
        anchors.leftMargin: 10
        anchors.rightMargin: 20

        anchors.fill: parent
        visible: !QmlAppSt.isShowLog
    }

    ExceptionAndLog {
        id: exceptionAndLog
    }

    Binding {
        target: QmlAppSt
        property: "filePanSize"
        value: mainqmltype.filePanSize
    }

    Binding {
        target: QmlAppSt
        property: "mainqmltype"
        value: mainqmltype
    }

    Binding {
        target: QmlAppSt
        property: "filePath"
        value: mainqmltype.filePath
    }

    Binding {
        target: QmlAppSt
        property: "menubarCommStr"
        value: mainqmltype.menubarCommStr
    }

    Binding {
        target: QmlAppSt
        property: "waitItems"
        value: mainqmltype.waitItems
    }

    Binding {
        target: QmlAppSt
        property: "noneWaitItems"
        value: mainqmltype.noneWaitItems
    }

    Binding {
        target: QmlAppSt
        property: "exceptionCounter"
        value: mainqmltype.exceptionCounter
    }

    Binding {
        target: QmlAppSt
        property: "exceptionStr"
        value: mainqmltype.exceptionStr
    }

    signal toggleFilepan
    onToggleFilepan: mainqmltype.toggleFilepan()
}
