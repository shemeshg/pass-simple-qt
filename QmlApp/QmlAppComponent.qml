import QtQuick
import QmlApp

Rectangle {

    property alias alianHelloWorld: qmlAppType.helloWorld

    QmlAppType {
        id: qmlAppType
        helloWorld: "shalom olam 888"
    }

    border.width: 2
    border.color: "black"
    Text {
        id: textId
        text: qmlAppType.helloWorld
    }

}
