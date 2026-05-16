



qt6_add_qml_module(InputType 
        URI InputType 
        VERSION 1.0
        SOURCES
            InputTypeType.cpp 
            QtTotp/Base32.cpp 
            QtTotp/Clock.cpp 
            QtTotp/totp.cpp 
            
        QML_FILES
            InputTypeComponent.qml 
            

        RESOURCES
            icons/outline_file_download_black_24dp.png 
            icons/outline_file_upload_black_24dp.png 
            
            
        )