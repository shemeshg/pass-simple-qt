

find_package(Qt6 REQUIRED COMPONENTS
Widgets
LabsFolderListModel
)
link_libraries(
Qt6::Widgets
Qt6::LabsFolderListModel
)



set_source_files_properties(QmlAppSt.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt6_add_qml_module(QmlApp 
        URI QmlApp 
        VERSION 1.0
        SOURCES
            QmlAppType.cpp 
            
        QML_FILES
            AddComponent.qml 
            ColumnLayoutHome.qml 
            EditComponent.qml 
            ExceptionAndLog.qml 
            ManageGpgIdComponent.qml 
            MetaDataComponent.qml 
            QmlAppComponent.qml 
            QmlAppSt.qml 
            RenameDialog.qml 
            SHowSettingsComponent.qml 
            SearchComponent.qml 
            SettingsLabelComboBox.qml 
            SettingsLabelTextArea.qml 
            SettingsLabelTextField.qml 
            SettingsSelectFolder.qml 
            TextEditComponent.qml 
            

        RESOURCES
            icons/icons8-locked-with-key-48.png 
            icons/account_tree_FILL0_wght400_GRAD0_opsz48.svg 
            icons/edit_FILL0_wght400_GRAD0_opsz48.svg 
            icons/search_FILL0_wght400_GRAD0_opsz48.svg 
            icons/settings_FILL0_wght400_GRAD0_opsz48.svg 
            icons/store_FILL0_wght400_GRAD0_opsz48.svg 
            icons/sync_FILL0_wght400_GRAD0_opsz48.svg 
            icons/sync_problem_FILL0_wght400_GRAD0_opsz48.svg 
            
            
        )