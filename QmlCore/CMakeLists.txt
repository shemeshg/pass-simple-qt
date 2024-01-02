set(OS_DEPENDENT_QML)
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    list(APPEND OS_DEPENDENT_QML +mac/CoreTextArea.qml)
endif()
if(UNIX AND NOT APPLE)
    list(APPEND OS_DEPENDENT_QML +linux/CoreTextArea.qml)
endif()
if(WIN32)
    list(APPEND OS_DEPENDENT_QML +win32/CoreTextArea.qml)
endif()

set_source_files_properties(CoreSystemPalette.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt6_add_qml_module(QmlCore
        URI QmlCore
        VERSION 1.0
        SOURCES
            QmlCoreType.h 
            QmlCoreType.cpp
        RESOURCES
            QML_FILES CoreButton.qml
            QML_FILES TextAreaFactory.qml
            #QML_FILES CoreTextArea.qml
            QML_FILES ${OS_DEPENDENT_QML}
            QML_FILES CoreSwitch.qml
            QML_FILES CoreComboBox.qml
            QML_FILES CoreDialogYesNo.qml
            QML_FILES CoreTextField.qml
            QML_FILES CoreThinBar.qml
            QML_FILES CorePagePadFooter.qml
            QML_FILES CoreToolTip.qml
            QML_FILES CoreLabel.qml
            QML_FILES CoreLabelAndText.qml
            QML_FILES CoreTabButton.qml
            QML_FILES CoreSystemPalette.qml
        )
