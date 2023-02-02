add_subdirectory(DropdownWithList)
add_subdirectory(EditYaml)
# hygen add_subdirectory
link_libraries(
DropdownWithList
EditYaml
# hygen target_link_libraries
)

qt6_add_qml_module(QmlApp
        URI QmlApp
        VERSION 1.0
        SOURCES
            QmlAppType.h 
            QmlAppType.cpp
            qrc.qrc
        QML_FILES
            QmlAppComponent.qml
        )
