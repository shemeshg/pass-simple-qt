pragma Singleton

import QtQuick

QtObject {
    property string filePath: ""
    property string menubarCommStr: ""
    property int filePanSize: 0
    property var waitItems: []
    property var noneWaitItems: []
    property int exceptionCounter: 0
    property string exceptionStr: ""
    property bool isShowLog: false
    property bool isMainUiDisabled: false
    property string passwordStorePathStr: ""
    property bool isShowSettings: false
    property bool isShowSearch: false
    property bool isShowPreview: true

    property bool isSaving: false
}
