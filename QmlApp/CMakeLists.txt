add_subdirectory(DropdownWithList)
add_subdirectory(EditYaml)
# hygen add_subdirectory
link_libraries(
DropdownWithList
EditYaml
# hygen target_link_libraries
)

set(QML_IMPORT_PATH 
                ${CMAKE_SOURCE_DIR}/EditYaml
                ${CMAKE_SOURCE_DIR}/DropdownWithList
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
            icons/icons8-shop-80.png
            icons/icons8-automation-50.png
            icons/icons8-search-more-50.png
            icons/icons8-tree-structure-80.png
        )
