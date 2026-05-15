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

           "CPACK_DEBIAN_PACKAGE_DEPENDS": ["libxcb-cursor-dev","libc6,libstdc++6","libgcc-s1","pass","gnupg2","libgpgme-dev",
                                            "libgpgmepp-dev","libbotan-2-dev"],

           "QML_DIRS": ["QmlApp","EditYaml","InputType", "DropdownWithList","Datetime", "QmlCore"],

           "QT_COMPONENTS": [ "Quick","Widgets","Svg","Concurrent", "QuickControls2", "QuickWidgets"],
           "add_subdirectory_lib": ["gpgfactory/libpgpfactory"],
           "add_subdirectory_qt": ["QmlApp","EditYaml","InputType", "DropdownWithList","Datetime", "QmlCore"]
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
