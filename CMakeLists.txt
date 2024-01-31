cmake_minimum_required(VERSION 3.5)

project(pass-simple VERSION 0.163 LANGUAGES CXX)

# include(cmake/CPM.cmake)
# CPMAddPackage("gh:TheLartians/Format.cmake@1.7.3")

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

CMAKE_POLICY(SET CMP0071 NEW) 

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(MACOSX TRUE)
endif()
if(UNIX AND NOT APPLE)
    set(LINUX TRUE)
endif()
if(WIN32 OR MSVC OR MSYS OR MINGW)
    set(WINDOWS TRUE)
endif()

if(MACOSX)
#    set(CMAKE_OSX_ARCHITECTURES "x86_64" )
#    include( "/Users/macos/vcpkg/scripts/buildsystems/vcpkg.cmake")
endif()
if(LINUX)
    include( "/opt/vcpkg/scripts/buildsystems/vcpkg.cmake")
endif()
if(WINDOWS)
include( "D:/vcpkg/scripts/buildsystems/vcpkg.cmake")
endif()


find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets LinguistTools QuickWidgets Concurrent LabsFolderListModel Svg QuickControls2)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets LinguistTools QuickWidgets Concurrent LabsFolderListModel Svg QuickControls2)
qt_standard_project_setup(REQUIRES 6.5)

set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/rc.qrc")
add_subdirectory(QmlApp)
add_subdirectory(EditYaml)
add_subdirectory(InputType)
add_subdirectory(DropdownWithList)
add_subdirectory(Datetime)
add_subdirectory(QmlCore)

# generated files should be on build dir only
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(PROJECT_SOURCES
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
    about.ui   
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

configure_file("${PROJECT_SOURCE_DIR}/config.h.in" "${CMAKE_BINARY_DIR}/config.h")

if(MACOSX)
    # Application icon
    set(MACOSX_BUNDLE_ICON_FILE icon.icns)
    set(APP_ICON_MACOSX ${CMAKE_CURRENT_SOURCE_DIR}/icon.icns)
    set_source_files_properties(${APP_ICON_MACOSX} PROPERTIES
           MACOSX_PACKAGE_LOCATION "Resources")
    set(CPACK_PACKAGE_NAME pass-simple)
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Pass simple")
    set(CPACK_PACKAGE_VENDOR "shemeshg")     
    include(CPack)     
endif()

set(QML_IMPORT_PATH ${CMAKE_SOURCE_DIR}/QmlApp
                ${CMAKE_SOURCE_DIR}/EditYaml
                ${CMAKE_SOURCE_DIR}/InputType
                ${CMAKE_SOURCE_DIR}/DropdownWithList
                ${CMAKE_SOURCE_DIR}/Datetime
                ${CMAKE_SOURCE_DIR}/QmlCore
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

if(UNIX)
    # LibGpgError bug must include_directories on root, but can be linked in subdirectory
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/gpgfactory/libpgpfactory/cmake)
    find_package(LibGpgError REQUIRED)
    include_directories(${LibGpgError_INCLUDE_DIRS})
    # End LibGpgError
endif()
add_subdirectory(gpgfactory/libpgpfactory)




set(TS_FILES ts/pass-simple_en_US.ts)


target_link_libraries(pass-simple PRIVATE Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::QuickWidgets
    Qt6::Concurrent
Qt${QT_VERSION_MAJOR}::LabsFolderListModel
Qt${QT_VERSION_MAJOR}::Svg
Qt${QT_VERSION_MAJOR}::QuickControls2
    QmlApp
    EditYaml
    InputType
    DropdownWithList
    Datetime
    QmlCore
    libpgpfactory
)

set_target_properties(pass-simple PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER PassSimple.shemeshg.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    OUTPUT_NAME "pass-simple"
)

if(LINUX)
    set(CPACK_PACKAGE_NAME pass-simple)
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Pass simple")
    set(CPACK_PACKAGE_VENDOR "shemeshg")
    set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CPACK_PACKAGE_NAME})
    set(CPACK_VERBATIM_VARIABLES ON)
    set(CPACK_PACKAGING_INSTALL_PREFIX "/opt/pass-simple")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "shemeshg <https://github.com/shemeshg>")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libxcb-cursor-dev,libc6,libstdc++6,libgcc-s1,pass,gnupg2,libgpgme-dev,libgpgmepp-dev")
    INSTALL(FILES pass-simple.desktop DESTINATION share/applications)
    install(FILES pass-simple.png DESTINATION share/icons/hicolor/256x256/apps)
    install(FILES script/pass-simple.sh DESTINATION bin)

    # dynamically configured debian control scripts
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/script/postinst
                   ${CMAKE_CURRENT_BINARY_DIR}/script/postinst)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/script/prerm
                   ${CMAKE_CURRENT_BINARY_DIR}/script/prerm)


    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_BINARY_DIR}/script/postinst;${CMAKE_CURRENT_BINARY_DIR}/script/prerm;")


    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA, ./script/postinst)
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA, ./script/prerm)
    include(CPack)
    
    set (ubuntu_so_files /lib/x86_64-linux-gnu/librnp.so.0.17.0
    /lib/libbotan-3.so.2.2.0)
endif()

if(APPLE)
    set(mac_SOURCES
            macutils/AppKitImpl.mm
            macutils/AppKit.h)
endif()

qt_add_qml_module(pass-simple
    URI MainQml
    VERSION 1.0
    SOURCES
        mainqmltype.h mainqmltype.cpp
        GpgIdManageType.h GpgIdManageType.cpp
        JsAsync.h JsAsync.cpp
        UiGuard.h UiGuard.cpp
        appfilesysmodel.h appfilesysmodel.cpp
  AppSettings.cpp AppSettings.h
        ${mac_SOURCES}
        # bug totp
        QtTotp/totp.h
        QtTotp/totp.cpp
        QtTotp/Base32.h
        QtTotp/Base32.cpp
        QtTotp/Clock.h
        QtTotp/Clock.cpp
        QtTotp/getTotp.h
        # end bug totp
        # hygen srcs
    QML_FILES Main.qml     
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
  set_property(TARGET pass-simple PROPERTY WIN32_EXECUTABLE true)
endif()

install(TARGETS pass-simple
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(pass-simple)
endif()


# Generate the deployment script for the target pass-simple.
qt_generate_deploy_qml_app_script(
    TARGET pass-simple
    OUTPUT_SCRIPT deploy_script
    POST_INCLUDE_FILES
      ${POST_INCLUDE_FILES}
      ${ubuntu_so_files}
    NO_UNSUPPORTED_PLATFORM_ERROR
)

# Call the deployment script on "cmake --install".
install(SCRIPT ${deploy_script})
