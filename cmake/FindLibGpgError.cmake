find_package(PkgConfig QUIET)
pkg_check_modules(PC_LibGpgError QUIET gpg-error)

set(LibGpgError_VERSION ${PC_LibGpgError_VERSION})
set(LibGpgError_DEFINITIONS ${PC_LibGpgError_CFLAGS_OTHER})

find_path(LibGpgError_INCLUDE_DIR
    NAMES
        gpg-error.h
    PATHS
        ${PC_LibGpgError_INCLUDE_DIRS}
)
find_library(LibGpgError_LIBRARY
    NAMES
        gpg-error
    PATHS
        ${PC_LibGpgError_LIBRARY_DIRS}
)

if(LibGpgError_INCLUDE_DIR AND NOT LibGpgError_VERSION)
    # The version is given in the format MAJOR.MINOR optionally followed
    # by an intermediate "beta" version given as -betaNUM, e.g. "1.47-beta7".
    file(STRINGS "${LibGpgError_INCLUDE_DIR}/gpg-error.h" LibGpgError_VERSION_STR
         REGEX "^#[\t ]*define[\t ]+GPG_ERROR_VERSION[\t ]+\"([0-9])+\\.([0-9])+(-[a-z0-9]*)?\".*")
    string(REGEX REPLACE "^.*GPG_ERROR_VERSION[\t ]+\"([0-9]+\\.[0-9]+(-[a-z0-9]*)?)\".*$"
           "\\1" LibGpgError_VERSION_STR "${LibGpgError_VERSION_STR}")

    set(LibGpgError_VERSION "${LibGpgError_VERSION_STR}")

    unset(LibGpgError_VERSION_STR)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibGpgError
    REQUIRED_VARS
        LibGpgError_LIBRARY
        LibGpgError_INCLUDE_DIR
        LibGpgError_VERSION
    VERSION_VAR
        LibGpgError_VERSION
)

mark_as_advanced(
    LibGpgError_INCLUDE_DIR
    LibGpgError_LIBRARY
)

if(LibGpgError_FOUND)
    set(LibGpgError_LIBRARIES ${LibGpgError_LIBRARY})
    set(LibGpgError_INCLUDE_DIRS ${LibGpgError_INCLUDE_DIR})
endif()

include(FeatureSummary)
set_package_properties(LibGpgError PROPERTIES
    DESCRIPTION "Runtime library for all GnuPG components"
    URL https://www.gnupg.org/software/libgpg-error
)