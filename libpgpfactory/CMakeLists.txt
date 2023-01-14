include(FeatureSummary)


find_package(Gpgmepp CONFIG REQUIRED) 

include_directories(${GPGMEAPP_INCLUDES})



set(libpgpfactory_SRCS
    libpgpfactory.h
    libpgpfactory.cpp
    libpasshelper.h
    libpasshelper.cpp    
)

# Declare the library
add_library(libpgpfactory STATIC
    ${libpgpfactory_SRCS}
)
target_link_libraries(libpgpfactory Gpgmepp  ${LibGpgError_LIBRARIES})

# Specify here the include directories exported
# by this library
target_include_directories(libpgpfactory PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)




set_target_properties(libpgpfactory PROPERTIES LINKER_LANGUAGE CXX)