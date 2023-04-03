find_package(Qt6 REQUIRED COMPONENTS Gui)

qt6_add_qml_module(Datetime
        URI Datetime
        VERSION 1.0
        SOURCES
            DatetimeType.h 
            DatetimeType.cpp
            datetimevalidator.h
            datetimevalidator.cpp
        QML_FILES
            DatetimeComponent.qml
        )

    # Specify here the include directories exported
    # by this library

    target_include_directories(Datetime PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
    )

target_link_libraries(Datetime PRIVATE Qt6::Gui)
