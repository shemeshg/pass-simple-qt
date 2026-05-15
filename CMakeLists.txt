# [[[cog
# import cog
# from CMakeCogMain import getCmake
# cog.outl(getCmake())
# ]]]
cmake_minimum_required(VERSION 3.16)

project(pass-simple VERSION 1.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)
set(CMAKE_AUTORCC ON)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    # Append -fPIC to the CXXFLAGS only if the system is Linux
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif()


find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Widgets Svg Concurrent QuickControls2 QuickWidgets)

qt_standard_project_setup(REQUIRES 6.5)

# rnpgp specific
set(BUILD_TESTING OFF)
# END rnpgp specific

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CMAKE_OSX_ARCHITECTURES "arm64")
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

    # rnpgp specific
    set(VCPKG_INSTALLED_DIR "C:/Users/windows/Documents/Projects/rnp/vcpkg_install")
    set(VCPKG_ROOT "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/vcpkg")
    set(DCRYPTO_BACKEND "botan" )
    include( "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/vcpkg/scripts/buildsystems/vcpkg.cmake")
    # END rnpgp specific

endif()
if(MACOSX)
    # Application icon
    set(MACOSX_BUNDLE_ICON_FILE icon.icns)
    set(APP_ICON_MACOSX ${CMAKE_CURRENT_SOURCE_DIR}/icon.icns)
    set_source_files_properties(${APP_ICON_MACOSX} PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources")
    set(CPACK_PACKAGE_NAME pass-simple)
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Pass simple")
    set(CPACK_PACKAGE_VENDOR "shemeshg")    
endif()

    
    

list(APPEND QML_DIRS  ${CMAKE_CURRENT_SOURCE_DIR}/QmlApp  ${CMAKE_CURRENT_SOURCE_DIR}/EditYaml  ${CMAKE_CURRENT_SOURCE_DIR}/InputType  ${CMAKE_CURRENT_SOURCE_DIR}/DropdownWithList  ${CMAKE_CURRENT_SOURCE_DIR}/Datetime  ${CMAKE_CURRENT_SOURCE_DIR}/QmlCore )
set(QML_IMPORT_PATH "${QML_DIRS}" CACHE STRING "Import paths for Qt Creator's code model" FORCE)


set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/rc.qrc")
qt_add_executable(${CMAKE_PROJECT_NAME}
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
    about.ui
    ${APP_ICON_RESOURCE_WINDOWS}
    
    MANUAL_FINALIZATION
        ${APP_ICON_MACOSX}
)


if(APPLE)
    set(MAIN_QML_SOURCES_MAC
    macutils/AppKitImpl.mm
    macutils/AppKit.h
    )
endif()

qt_add_qml_module(${CMAKE_PROJECT_NAME}
    URI MainQml
    VERSION 1.0
    SOURCES
    ${MAIN_QML_SOURCES_MAC}
    mainqmltype.cpp
    GpgIdManageType.cpp
    JsAsync.cpp
    UiGuard.cpp
    appfilesysmodel.cpp
    AppSettings.cpp
    QtTotp/totp.cpp
    QtTotp/Base32.cpp
    QtTotp/Clock.cpp
    QtTotp/getTotp.cpp
    QML_FILES
    Main.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.shemeshg.passsimple
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
    set(CPACK_PACKAGE_CONTACT "https://github.com/shemeshg") 
    set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CPACK_PACKAGE_NAME})
    set(CPACK_VERBATIM_VARIABLES ON)
    set(CPACK_PACKAGING_INSTALL_PREFIX "/opt/pass-simple")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "shemeshg <https://github.com/shemeshg>")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "libxcb-cursor-dev,libc6,libstdc++6,libgcc-s1,pass,gnupg2,libgpgme-dev,libgpgmepp-dev,libbotan-2-dev")
    INSTALL(FILES pass-simple.desktop DESTINATION share/applications)
    install(FILES pass-simple.png DESTINATION share/icons/hicolor/256x256/apps)
    install(FILES deployScript/pass-simple.sh DESTINATION bin)

    # dynamically configured debian control scripts
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/deployScript/postinst
        ${CMAKE_CURRENT_BINARY_DIR}/deployScript/postinst)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/deployScript/prerm
        ${CMAKE_CURRENT_BINARY_DIR}/deployScript/prerm)


    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_BINARY_DIR}/deployScript/postinst;${CMAKE_CURRENT_BINARY_DIR}/deployScript/prerm;")


    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA, ./deployScript/postinst)
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA, ./deployScript/prerm)

endif()
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set_property(TARGET pass-simple PROPERTY WIN32_EXECUTABLE true)

    if(WINDOWS)
      install(FILES
            ${CMAKE_SOURCE_DIR}/icon.ico
            ${CMAKE_CURRENT_BINARY_DIR}/src/rnp/botan-3.dll
            ${CMAKE_CURRENT_BINARY_DIR}/src/rnp/bz2.dll
            ${CMAKE_CURRENT_BINARY_DIR}/src/rnp/getopt.dll
            ${CMAKE_CURRENT_BINARY_DIR}/src/rnp/json-c.dll
            ${CMAKE_CURRENT_BINARY_DIR}/src/rnp/zlib1.dll
            DESTINATION bin)
    endif()

    # set the install/uninstall icon used for the installer itself
    set (CPACK_NSIS_MUI_ICON
        "${CMAKE_SOURCE_DIR}/icon.ico")
    set (CPACK_NSIS_MUI_UNIICON
        "${CMAKE_SOURCE_DIR}/icon.ico")

    # set the add/remove programs icon using an installed executable
    SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\pass-simple.exe")

    set (CPACK_NSIS_PACKAGE_NAME "pass-simple")

    set (CPACK_RESOURCE_FILE_LICENSE
        "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

    set (CPACK_CREATE_DESKTOP_LINKS pass-simple)

    set (CPACK_PACKAGE_INSTALL_DIRECTORY "pass-simple")
    set (CPACK_PACKAGE_INSTALL_REGISTRY_KEY "pass-simple")
    set (CPACK_PACKAGE_EXECUTABLES "pass-simple" "pass-simple")

    #cpack_add_component(development DISPLAY_NAME
    #    "pass-simple" )

    set (CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    set(CPACK_NSIS_CREATE_ICONS_EXTRA
        "CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\pass-simple.lnk' '$INSTDIR\\\\bin\\\\pass-simple.exe' '' '$INSTDIR\\\\bin\\\\icon.ico'"
    )


endif()

if(UNIX)
    # LibGpgError bug must include_directories on root, but can be linked in subdirectory
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/gpgfactory/libpgpfactory/cmake)
    find_package(LibGpgError REQUIRED)
    include_directories(${LibGpgError_INCLUDE_DIRS})
    # End LibGpgError
endif()

add_subdirectory(gpgfactory/libpgpfactory)
add_subdirectory(QmlApp)
add_subdirectory(EditYaml)
add_subdirectory(InputType)
add_subdirectory(DropdownWithList)
add_subdirectory(Datetime)
add_subdirectory(QmlCore)
target_link_libraries(${CMAKE_PROJECT_NAME}
    PRIVATE 
    Qt6::Quick
    Qt6::Widgets
    Qt6::Svg
    Qt6::Concurrent
    Qt6::QuickControls2
    Qt6::QuickWidgets
    libpgpfactory
    QmlApp
    EditYaml
    InputType
    DropdownWithList
    Datetime
    QmlCore
    )
include(CPack)
include(GNUInstallDirs)
install(TARGETS ${CMAKE_PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_finalize_executable(pass-simple)
# Generate the deployment script for the target pass-simple.
if(LINUX)
    qt_generate_deploy_qml_app_script(
        TARGET pass-simple
        OUTPUT_SCRIPT deploy_script
        POST_INCLUDE_FILES
        /lib/x86_64-linux-gnu/librnp.so.0.17.1
        /lib/libbotan-3.so.2.2.0
        # NO_UNSUPPORTED_PLATFORM_ERROR
    )
else()
    qt_generate_deploy_qml_app_script(
        TARGET pass-simple
        OUTPUT_SCRIPT deploy_script
        # NO_UNSUPPORTED_PLATFORM_ERROR
    )
endif()

# Call the deployment script on "cmake --install".
install(SCRIPT ${deploy_script})

configure_file("${PROJECT_SOURCE_DIR}/config.h.in" "${CMAKE_BINARY_DIR}/config.h")
# Make config.h.in available
set(CMAKE_INCLUDE_CURRENT_DIR ON)
# [[[end]]]
