qt6_add_qml_module(InputType
        URI InputType
        VERSION 1.0
        SOURCES
            InputTypeType.h 
            InputTypeType.cpp
            totp.h
            totp.cpp
            Base32.h
            Base32.cpp
            Clock.h
            Clock.cpp
            qrc.qrc
        QML_FILES
            InputTypeComponent.qml
        )
