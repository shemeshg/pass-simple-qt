import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSearch
    width: parent.width

    property string currentSearchFolder: passwordStorePathStr

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
        id: searchStatusLabelId
        visible: false
        Label {
            text: "Running..."
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
            onAccepted: {
                btnFindId.clicked()
            }
        }
        Button {
            Timer {
                id: timer
            }
            function delay(delayTime, cb) {
                timer.interval = delayTime;
                timer.repeat = false;
                timer.triggered.connect(cb);
                timer.start();
            }
            id: btnFindId
            text: "find"
            onClicked: {
                btnFindId.enabled = false
                searchStatusLabelId.visible= true
                delay(10, function() {
                    getMainqmltype().doSearch(currentSearchFolder, textFieldFileSearch.text,textFieldContentSearch.text)
                    btnFindId.enabled = true
                    searchStatusLabelId.visible=false;
                })


            }
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
            text: ".*" + findTextId.text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') +  ".*"
            Layout.fillWidth: true
            onAccepted: {
                btnFindId.clicked()
            }
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
            onAccepted: {
                btnFindId.clicked()
            }
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
            text: ".*" + searchTextId.text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') +  ".*"
            Layout.fillWidth: true
            onAccepted: {
                btnFindId.clicked()
            }
        }
    }
    RowLayout {
        Label {
            text: "In: " + currentSearchFolder
            Layout.fillWidth: true
        }
        Button {
            text: "."
            onClicked: {
                if(fullPathFolder){
                    currentSearchFolder = fullPathFolder
                }
            }
            ToolTip.text: "Set search folder to current treeview selected folder"
            ToolTip.visible: hovered
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
