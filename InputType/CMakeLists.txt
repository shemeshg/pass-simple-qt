qt6_add_qml_module(InputType
        URI InputType
        VERSION 1.0
        SOURCES
            InputTypeType.h 
            InputTypeType.cpp
            QtTotp/totp.h
            QtTotp/totp.cpp
            QtTotp/Base32.h
            QtTotp/Base32.cpp
            QtTotp/Clock.h
            QtTotp/Clock.cpp
	    QtTotp/getTotp.h
        QML_FILES
            InputTypeComponent.qml
        RESOURCES
            icons/outline_file_upload_black_24dp.png
            icons/outline_file_download_black_24dp.png
        )
