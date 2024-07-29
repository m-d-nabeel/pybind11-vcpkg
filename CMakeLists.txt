cmake_minimum_required(VERSION 3.12...3.21)
project(pybind11_example)

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
        CACHE STRING "")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(pybind11_DIR "/home/m-d-nabeel/Projects/pybind/vcpkg_installed/x64-linux/share/pybind11")

# Find Python and pybind11
find_package(Python3 COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 CONFIG REQUIRED)

# Add your main executable
add_executable(main src/main.cpp)

# Link Python and pybind11 to your main executable
target_link_libraries(main PRIVATE pybind11::embed Python3::Python)