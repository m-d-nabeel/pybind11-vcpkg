# For very old ports whose upstream do not properly set the minimum CMake version.
cmake_policy(SET CMP0012 NEW)
cmake_policy(SET CMP0057 NEW)

# This prevents the port's python.exe from overriding the Python fetched by
# vcpkg_find_acquire_program(PYTHON3) and prevents the vcpkg toolchain from
# stomping on FindPython's default functionality.
list(REMOVE_ITEM CMAKE_PROGRAM_PATH "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/tools/python3")
if(FALSE)
    _find_package(${ARGS})
    return()
endif()

# CMake's FindPython's separation of concerns is very muddy. We only want to force vcpkg's Python
# if the consumer is using the development component. What we don't want to do is break detection
# of the system Python, which may have certain packages the user expects. But - if the user is
# embedding Python or using both the development and interpreter components, then we need the
# interpreter matching vcpkg's Python libraries. Note that the "Development" component implies
# both "Development.Module" and "Development.Embed"
if("Development" IN_LIST ARGS OR "Development.Embed" IN_LIST ARGS)
    set(_PythonFinder_WantInterp TRUE)
    set(_PythonFinder_WantLibs TRUE)
elseif("Development.Module" IN_LIST ARGS)
    if("Interpreter" IN_LIST ARGS)
        set(_PythonFinder_WantInterp TRUE)
    endif()
    set(_PythonFinder_WantLibs TRUE)
endif()

if(_PythonFinder_WantLibs)
    find_path(
        _Python3_INCLUDE_DIR
        NAMES "Python.h"
        PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include"
        PATH_SUFFIXES "python3.11"
        NO_DEFAULT_PATH
    )

    # Don't set the public facing hint or the finder will be unable to detect the debug library.
    # Internally, it uses the same value with an underscore prepended.
    find_library(
        _Python3_LIBRARY_RELEASE
        NAMES
        "python311"
        "python3.11"
        PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib"
        NO_DEFAULT_PATH
    )
    find_library(
        _Python3_LIBRARY_DEBUG
        NAMES
        "python311_d"
        "python3.11d"
        PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/debug/lib"
        NO_DEFAULT_PATH
    )

    if(_PythonFinder_WantInterp)
        find_program(
            Python3_EXECUTABLE
            NAMES "python" "python3.11"
            PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/tools/python3"
            NO_DEFAULT_PATH
        )
    endif()

    # These are duplicated as normal variables to nullify FindPython's checksum verifications.
    set(_Python3_INCLUDE_DIR "${_Python3_INCLUDE_DIR}")
    set(_Python3_LIBRARY_RELEASE "${_Python3_LIBRARY_RELEASE}")
    set(_Python3_LIBRARY_DEBUG "${_Python3_LIBRARY_DEBUG}")

    _find_package(${ARGS})

    if(static STREQUAL static)
        # Python for Windows embeds the zlib module into the core, so we have to link against it.
        # This is a separate extension module on Unix-like platforms.
        if(WIN32)
            find_package(ZLIB)
            if(TARGET Python3::Python)
                set_property(TARGET Python3::Python APPEND PROPERTY INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
            endif()
            if(TARGET Python3::Module)
                set_property(TARGET Python3::Module APPEND PROPERTY INTERFACE_LINK_LIBRARIES ZLIB::ZLIB)
            endif()
            if(DEFINED Python3_LIBRARIES)
                list(APPEND Python3_LIBRARIES ${ZLIB_LIBRARIES})
            endif()
        endif()

        if(APPLE)
            find_package(Iconv)
            find_package(Intl)
            if(TARGET Python3::Python)
                get_target_property(_PYTHON_INTERFACE_LIBS Python3::Python INTERFACE_LINK_LIBRARIES)
                if(NOT _PYTHON_INTERFACE_LIBS)
                    set(_PYTHON_INTERFACE_LIBS "")
                endif()
                list(REMOVE_ITEM _PYTHON_INTERFACE_LIBS "-liconv" "-lintl")
                list(APPEND _PYTHON_INTERFACE_LIBS
                    Iconv::Iconv
                    "$<IF:$<CONFIG:Debug>,${Intl_LIBRARY_DEBUG},${Intl_LIBRARY_RELEASE}>"
                )
                set_property(TARGET Python3::Python PROPERTY INTERFACE_LINK_LIBRARIES ${_PYTHON_INTERFACE_LIBS})
                unset(_PYTHON_INTERFACE_LIBS)
            endif()
            if(TARGET Python3::Module)
                get_target_property(_PYTHON_INTERFACE_LIBS Python3::Module INTERFACE_LINK_LIBRARIES)
                if(NOT _PYTHON_INTERFACE_LIBS)
                    set(_PYTHON_INTERFACE_LIBS "")
                endif()
                list(REMOVE_ITEM _PYTHON_INTERFACE_LIBS "-liconv" "-lintl")
                list(APPEND _PYTHON_INTERFACE_LIBS
                    Iconv::Iconv
                    "$<IF:$<CONFIG:Debug>,${Intl_LIBRARY_DEBUG},${Intl_LIBRARY_RELEASE}>"
                )
                set_property(TARGET Python3::Module PROPERTY INTERFACE_LINK_LIBRARIES ${_PYTHON_INTERFACE_LIBS})
                unset(_PYTHON_INTERFACE_LIBS)
            endif()
            if(DEFINED Python3_LIBRARIES)
                list(APPEND Python3_LIBRARIES "-framework CoreFoundation" ${Iconv_LIBRARIES} ${Intl_LIBRARIES})
            endif()
        endif()
    endif()
else()
    _find_package(${ARGS})
endif()

if(TARGET Python3::Python)
    target_compile_definitions(Python3::Python INTERFACE "$<$<CONFIG:Debug>:Py_DEBUG>")
endif()
if(TARGET Python3::Module)
    target_compile_definitions(Python3::Module INTERFACE "$<$<CONFIG:Debug>:Py_DEBUG>")
endif()

unset(_PythonFinder_WantInterp)
unset(_PythonFinder_WantLibs)
