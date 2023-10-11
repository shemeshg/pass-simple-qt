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
    property bool isDarkTheme: false
    property bool isSaving: false
    property bool gpgPubKeysFolderExists: false
    property bool hasEffectiveGpgIdFile: false
    property bool isGpgFile: false
    property bool isBinaryFile: false
    property bool isPreviousShowPreview: false
    property int gitDiffReturnCode: 0
    property string nearestGpg: ""
    property string fullPathFolder: ""
    property bool classInitialized: false
    property string nearestGit: ""
    property var allPrivateKeys: []
}
