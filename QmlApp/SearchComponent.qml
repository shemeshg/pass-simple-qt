import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSearch
    width: parent.width
    RowLayout {
        Button {
            text: "Back"
            onClicked: isShowSearch = false
        }
        Button {
            text: "Show regex"
            onClicked: {
                textFindRegexId.visible = !textFindRegexId.visible
                textSearchRegexId.visible = !textSearchRegexId.visible
            }
        }
    }
    Row{
        Rectangle {
            color: "white"
            width: scrollViewId.width - 20
            height: 2
        }
    }
    RowLayout {
        Label {
            text: "File name"
        }
        TextField {
            id: findTextId
            text: ""
            Layout.fillWidth: true
        }
        Button {
            text: "find"
            onClicked: getMainqmltype().doSearch(textFieldFileSearch.text,textFieldContentSearch.text)
        }
    }
    RowLayout {
        id: textFindRegexId
        visible: false
        Label {
            text: "std::regex"
        }
        TextField {
            id: textFieldFileSearch
            text: ".*" + findTextId.text.replace(/\./g,"\\.").replace(/\*/g ,".*") +  ".*"
            Layout.fillWidth: true
        }
    }
    RowLayout {
        Label {
            text: "Contain"
        }
        TextField {
            id: searchTextId
            text: ""
            Layout.fillWidth: true
        }
    }
    RowLayout {
        id: textSearchRegexId
        visible: false
        Label {
            text: "std::regex"
        }
        TextField {
            id: textFieldContentSearch
            text: ".*" + searchTextId.text.replace(/\./g,"\\.").replace(/\*/g ,".*") +  ".*"
            Layout.fillWidth: true
        }
    }

    Repeater {
        model: getMainqmltype().searchResult
        RowLayout{
            Label {
                text:  modelData

            }
            Button {
                text: "select"
                onClicked: getMainqmltype().setTreeViewSelected(modelData)
            }

        }
    }
}
