find_package(Qt6 REQUIRED COMPONENTS
Gui
)
link_libraries(
Qt6::Gui
)



qt6_add_qml_module(Datetime 
        URI Datetime 
        VERSION 1.0
        SOURCES
            DatetimeType.cpp 
            datetimevalidator.cpp 
            
        QML_FILES
            DatetimeComponent.qml 
            
        )