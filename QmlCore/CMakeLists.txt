find_package(Qt6 REQUIRED COMPONENTS
Gui
)
link_libraries(
Qt6::Gui
)

set_source_files_properties(CoreSystemPalette.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt6_add_qml_module(QmlCore 
        URI QmlCore 
        VERSION 1.0
        SOURCES
            QmlCoreType.cpp 
            
        QML_FILES
            CoreButton.qml 
            CoreComboBox.qml 
            CoreDialogYesNo.qml 
            CoreLabel.qml 
            CoreLabelAndText.qml 
            CorePagePadFooter.qml 
            CoreSwitch.qml 
            CoreSystemPalette.qml 
            CoreTabButton.qml 
            CoreTextArea.qml 
            CoreTextField.qml 
            CoreThinBar.qml 
            CoreToolTip.qml 
            
        )