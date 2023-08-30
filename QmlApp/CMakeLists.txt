


# hygen add_subdirectory
link_libraries(

# hygen target_link_libraries
)

set(QML_IMPORT_PATH
              #  ${CMAKE_SOURCE_DIR}/EditYaml
                ${CMAKE_SOURCE_DIR}/DropdownWithList
                ${CMAKE_SOURCE_DIR}/InputType
                CACHE STRING "" FORCE)


qt6_add_qml_module(QmlApp
        URI QmlApp
        VERSION 1.0
        SOURCES
            QmlAppType.h 
            QmlAppType.cpp
        QML_FILES
            QmlAppComponent.qml
            EditComponent.qml
            ManageGpgIdComponent.qml
            MetaDataComponent.qml
            ExceptionAndLog.qml
            ColumnLayoutHome.qml
            AddComponent.qml
            SearchComponent.qml
            SHowSettingsComponent.qml
            TextEditComponent.qml
            RenameDialog.qml
        RESOURCES
            icons/icons8-locked-with-key-48.png
            icons/settings_FILL0_wght400_GRAD0_opsz48.svg
            icons/store_FILL0_wght400_GRAD0_opsz48.svg
            icons/search_FILL0_wght400_GRAD0_opsz48.svg
            icons/edit_FILL0_wght400_GRAD0_opsz48.svg
            icons/account_tree_FILL0_wght400_GRAD0_opsz48.svg
            icons/sync_FILL0_wght400_GRAD0_opsz48.svg
            icons/sync_problem_FILL0_wght400_GRAD0_opsz48.svg
        )


