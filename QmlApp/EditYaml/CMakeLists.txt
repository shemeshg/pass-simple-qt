find_package(yaml-cpp REQUIRED)
include_directories(${YAML_CPP_INCLUDE_DIR})
link_libraries(
yaml-cpp
# hygen target_link_libraries
)

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
