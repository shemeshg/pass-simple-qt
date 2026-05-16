from jinja2 import Environment, FileSystemLoader
import os

template_dict = {
           "APP_VER": "1.1.0",
           "APP_NAME": "pass-simple",
           "APP_DESCRIPTION": "Pass simple",
           "APP_VENDOR": "shemeshg",
           "APP_IDENTIFIER": "com.shemeshg.passsimple",
           "APP_CONTACT":"https://github.com/shemeshg",           
           "MAIN_QML_URI": "MainQml",


            "PROJECT_SOURCES": [
                "main.cpp",
                "mainwindow.cpp",
                "mainwindow.h",
                "mainwindow.ui",
                "about.ui",   
                "${APP_ICON_RESOURCE_WINDOWS}"
            ],

            "LINUX_POST_INCLUDE_FILES": [
               # "/lib/x86_64-linux-gnu/librnp.so.0.17.1",
               # "/lib/libbotan-3.so.2.2.0"
            ],

            "MAIN_QML_SOURCES_MAC": [
                "macutils/AppKitImpl.mm",
                "macutils/AppKit.h"
            ],

            "MAIN_QML_SOURCES": [
                "mainqmltype.cpp",                
                "GpgIdManageType.cpp",                
                "JsAsync.cpp",                
                "UiGuard.cpp",                
                "appfilesysmodel.cpp",
                "AppSettings.cpp",
                "QtTotp/totp.cpp",
                "QtTotp/Base32.cpp",                
                "QtTotp/Clock.cpp",
                "QtTotp/getTotp.cpp"
            ],

            "WINDOWS_INSTALL_DLLS": [
                "${CMAKE_CURRENT_BINARY_DIR}/src/rnp/botan-3.dll",
                "${CMAKE_CURRENT_BINARY_DIR}/src/rnp/bz2.dll",
                "${CMAKE_CURRENT_BINARY_DIR}/src/rnp/getopt.dll",
                "${CMAKE_CURRENT_BINARY_DIR}/src/rnp/json-c.dll",
                "${CMAKE_CURRENT_BINARY_DIR}/src/rnp/z.dll"
            ],

           "CPACK_DEBIAN_PACKAGE_DEPENDS": ["libxcb-cursor-dev","libc6,libstdc++6","libgcc-s1","pass","gnupg2","libgpgme-dev",
                                            "libgpgmepp-dev","libbotan-2-dev"],

           "QML_DIRS": ["QmlApp","EditYaml","InputType", "DropdownWithList","Datetime", "QmlCore"],

           "QT_COMPONENTS": [ "Quick","Widgets","Svg","Concurrent", "QuickControls2", "QuickWidgets"],
           "add_subdirectory_lib": ["gpgfactory/libpgpfactory",
                                    "QmlApp","EditYaml","InputType", "DropdownWithList","Datetime", "QmlCore"
                                    ],
           "add_subdirectory_qt": []
           }

template_dict["add_subdirectory_lib_target"] = [os.path.basename(path) for path in template_dict["add_subdirectory_lib"]]
template_dict["add_subdirectory_qt_target"] = [os.path.basename(path) + "plugin" for path in template_dict["add_subdirectory_qt"]]


environment = Environment(loader=FileSystemLoader("."))
template = environment.get_template("CMakeCogMain.j2")


content = template.render(
    template_dict
)

def getCmake():   
    return content
#print(getCmake())
