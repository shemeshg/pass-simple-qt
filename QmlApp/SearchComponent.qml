import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    visible: isShowSearch
    width: parent.width
    height: parent.height

    property string currentSearchFolder: passwordStorePathStr
    property var  searchResultModel: []

    Timer {
        id: timer
    }
    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }
    function doSearchAction(){

        btnRunSearchId.enabled = false
        searchStatusLabelId.visible= true
        searchResultModel=[]
        delay(10, function() {
            getMainqmltype().doSearch(currentSearchFolder, textFieldFileSearch.text,textFieldContentSearch.text)
            searchResultModel = getMainqmltype().searchResult
            btnRunSearchId.enabled = true
            searchStatusLabelId.visible=false;
        })

    }

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
        Button {

            id: btnRunSearchId
            text: "find"
            onClicked: {

                doSearchAction()

            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: "white"
    }

    ColumnLayout {
        spacing: 8

        Label {
            text: "File name"
        }
        TextField {
            id: findTextId
            text: ""
            Layout.fillWidth: true
            onAccepted: {
                doSearchAction()
            }
        }
        ColumnLayout {
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
                    doSearchAction()
                }
            }
        }
        Label {
            text: "Contain"
        }
        TextField {
            id: searchTextId
            text: ""
            Layout.fillWidth: true
            onAccepted: {
                doSearchAction()
            }
        }

        ColumnLayout {
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
                    doSearchAction()
                }
            }
        }

        RowLayout {
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
            Label {
                text: "In: " + currentSearchFolder
            }
        }

        Rectangle {
            color: "white"
            Layout.fillWidth: true
            height: 1
        }
        RowLayout {
            id: searchStatusLabelId
            visible: false
            Label {
                text: "Running..."
            }
        }
        ListView {
            id: searchResultRepeaterId
            model: searchResultModel

            ScrollBar.vertical: ScrollBar {}
            Layout.fillWidth: true
            Layout.fillHeight: true
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            delegate: RowLayout{

                Label {
                    text:  modelData.replace(passwordStorePathStr,"")

                }
                Button {
                    text: "select"
                    onClicked: getMainqmltype().setTreeViewSelected(modelData)
                }
            }

        }
    }
}
