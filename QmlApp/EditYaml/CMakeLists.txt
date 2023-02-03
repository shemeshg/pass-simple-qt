add_subdirectory(InputType)
# hygen add_subdirectory


find_package(yaml-cpp REQUIRED)
include_directories(${YAML_CPP_INCLUDE_DIR})
link_libraries(
yaml-cpp
InputType
# hygen target_link_libraries
)

set(QML_IMPORT_PATH 
                ${CMAKE_SOURCE_DIR}/InputType
                CACHE STRING "" FORCE)

qt6_add_qml_module(EditYaml
        URI EditYaml
        VERSION 1.0
        SOURCES
            EditYamlType.h 
            EditYamlType.cpp
            qrc.qrc
        QML_FILES
            EditYamlComponent.qml
    )
