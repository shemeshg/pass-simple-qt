import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls

Item {
    property alias alianHelloWorld: qmlAppType.helloWorld
    property int filePanSize: 0
    property string filePath: ""

    ColumnLayout {
    QmlAppType {
        id: qmlAppType
        helloWorld: "shalom olam 888"
    }


    Text {
        id: textId
        text: qmlAppType.helloWorld
    }

    Text {
        id: filepansizeId
        text:"FilePanSize : " + filePanSize
    }
    Text {
        id: nameId
        text:"File : " + filePath
    }

    Button {
        text: "Hide/Show treeview"
        onClicked: { mainLayout.toggleFilepan()}
    }
}
}
