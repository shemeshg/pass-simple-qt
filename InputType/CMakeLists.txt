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
        QML_FILES
            InputTypeComponent.qml
        RESOURCES
            icons/outline_file_upload_black_24dp.png
            icons/outline_file_download_black_24dp.png
        )
