add_subdirectory(DropdownWithList)
link_libraries( DropdownWithList )

qt6_add_qml_module(QmlApp
        URI QmlApp
        VERSION 1.0
        SOURCES
            QmlAppType.h 
            QmlAppType.cpp
        QML_FILES
            QmlAppComponent.qml
        )
