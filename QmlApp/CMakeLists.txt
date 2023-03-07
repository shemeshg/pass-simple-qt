


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
            qrc.qrc
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
        RESOURCES
            icons/icons8-locked-with-key-48.png
            icons/outline_settings_black_24dp.png
            icons/outline_account_tree_black_24dp.png
            icons/outline_store_black_24dp.png
            icons/outline_search_black_24dp.png
        )


