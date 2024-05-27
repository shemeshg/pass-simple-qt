# hygen add_subdirectory
include(FetchContent)

FetchContent_Declare(
  yaml-cpp
  GIT_REPOSITORY https://github.com/jbeder/yaml-cpp.git
  GIT_TAG 0.8.0
)
FetchContent_GetProperties(yaml-cpp)

if(NOT yaml-cpp_POPULATED)
  message(STATUS "Fetching yaml-cpp...")
  FetchContent_Populate(yaml-cpp)
  add_subdirectory(${yaml-cpp_SOURCE_DIR} ${yaml-cpp_BINARY_DIR})
endif()

link_libraries(
    yaml-cpp::yaml-cpp
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
        QML_FILES
            EditYamlComponent.qml
        RESOURCES
                icons/control_point_black_24dp.svg
                icons/edit_FILL0_wght400_GRAD0_opsz48.svg
                icons/move_down_black_24dp.svg
                icons/move_up_black_24dp.svg
                icons/remove_circle_outline_black_24dp.svg
                icons/content_copy_FILL0_wght400_GRAD0_opsz24.svg
    )
