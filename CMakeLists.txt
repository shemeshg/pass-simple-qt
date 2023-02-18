cmake_minimum_required(VERSION 3.5)

project(pass-simple VERSION 0.24 LANGUAGES CXX)

include(cmake/CPM.cmake)
CPMAddPackage("gh:TheLartians/Format.cmake@1.7.3")

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

CMAKE_POLICY(SET CMP0071 NEW) 

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets LinguistTools QuickWidgets Concurrent LabsFolderListModel)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets LinguistTools QuickWidgets Concurrent LabsFolderListModel)


set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/rc.qrc")
add_subdirectory(QmlApp)
add_subdirectory(EditYaml)
add_subdirectory(InputType)
add_subdirectory(DropdownWithList)

# generated files should be on build dir only
set(CMAKE_INCLUDE_CURRENT_DIR ON)
configure_file("${PROJECT_SOURCE_DIR}/config.h.in" "${CMAKE_BINARY_DIR}/config.h")

set(PROJECT_SOURCES
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
    qwidgetqrc.qrc
    ${TS_FILES}
    ${APP_ICON_RESOURCE_WINDOWS}
)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(MACOSX TRUE)
    set(PROJECT_OS "MACOSX")
endif()
if(UNIX AND NOT APPLE)
    set(LINUX TRUE)
    set(PROJECT_OS "LINUX")
endif()
if(WIN32 OR MSVC OR MSYS OR MINGW)
    set(WINDOWS TRUE)
    set(PROJECT_OS "WINDOWS")
endif()


if(MACOSX)
    # Application icon
    set(MACOSX_BUNDLE_ICON_FILE icon.icns)
    set(APP_ICON_MACOSX ${CMAKE_CURRENT_SOURCE_DIR}/icon.icns)
    set_source_files_properties(${APP_ICON_MACOSX} PROPERTIES
           MACOSX_PACKAGE_LOCATION "Resources")
endif()

set(QML_IMPORT_PATH ${CMAKE_SOURCE_DIR}/QmlApp
                ${CMAKE_SOURCE_DIR}/EditYaml
                ${CMAKE_SOURCE_DIR}/InputType
                ${CMAKE_SOURCE_DIR}/DropdownWithList
                CACHE STRING "" FORCE)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(pass-simple
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
        ${APP_ICON_MACOSX}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET pass-simple APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(pass-simple SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(pass-simple
            ${PROJECT_SOURCES}
        )
    endif()

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()


# LibGpgError bug must include_directories on root, but can be linked in subdirectory
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/gpgfactory/cmake)
find_package(LibGpgError REQUIRED)
include_directories(${LibGpgError_INCLUDE_DIRS})
# End LibGpgError
add_subdirectory(gpgfactory/libpgpfactory)

find_package(yaml-cpp REQUIRED)
include_directories(${YAML_CPP_INCLUDE_DIR})

set(TS_FILES ts/pass-simple_en_US.ts)






target_link_libraries(pass-simple PRIVATE Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::QuickWidgets
    Qt6::Concurrent
Qt${QT_VERSION_MAJOR}::LabsFolderListModel
    QmlApp
    EditYaml
    InputType
    DropdownWithList
    libpgpfactory    
	yaml-cpp
)

set_target_properties(pass-simple PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER PassSimple.shemeshg.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    OUTPUT_NAME "Pass simple"
)



qt_add_qml_module(pass-simple
    URI MainQml
    VERSION 1.0
    SOURCES
        mainqmltype.h mainqmltype.cpp
        GpgIdManageType.h GpgIdManageType.cpp
        UiGuard.h UiGuard.cpp
        InputType/totp.h
        InputType/totp.cpp
        InputType/Base32.h
        InputType/Base32.cpp
        InputType/Clock.h
        InputType/Clock.cpp
  AppSettings.cpp AppSettings.h
        # hygen srcs
    QML_FILES mainQml.qml
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
  set_property(TARGET pass-simple PROPERTY WIN32_EXECUTABLE true)
endif()

install(TARGETS pass-simple
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(pass-simple)
endif()
