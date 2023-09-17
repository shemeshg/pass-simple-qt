qt6_add_qml_module(QmlCore
        URI QmlCore
        VERSION 1.0
        SOURCES
            QmlCoreType.h 
            QmlCoreType.cpp
        RESOURCES
            QML_FILES CoreButton.qml
            QML_FILES TextAreaFactory.qml CoreTextArea.qml +linux/CoreTextArea.qml
            QML_FILES CoreSwitch.qml
            QML_FILES CoreComboBox.qml
            QML_FILES CoreDialogYesNo.qml
            QML_FILES CoreTextField.qml
            QML_FILES CoreThinBar.qml
            QML_FILES CorePagePadFooter.qml
            QML_FILES CoreToolTip.qml
        )
