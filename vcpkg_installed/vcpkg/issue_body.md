Package: python3:x64-linux@3.11.8#4

**Host Environment**

- Host: x64-linux
- Compiler: GNU 13.3.0
-    vcpkg-tool version: 2024-07-10-d2dfc73769081bdd9b782d08d27794780b7a99b9
    vcpkg-scripts version: cacf59943 2024-07-27 (2 days ago)

**To Reproduce**

`vcpkg install `

**Failure logs**

```
CMake Warning at /home/m-d-nabeel/.cache/vcpkg/registries/git-trees/42da794facada8d85273d1efcc53f1af7e8cb243/portfile.cmake:7 (message):
  python3 currently requires the following programs from the system package
  manager:

      autoconf automake autoconf-archive

  On Debian and Ubuntu derivatives:

      sudo apt-get install autoconf automake autoconf-archive

  On recent Red Hat and Fedora derivatives:

      sudo dnf install autoconf automake autoconf-archive

  On Arch Linux and derivatives:

      sudo pacman -S autoconf automake autoconf-archive

  On Alpine:

      apk add autoconf automake autoconf-archive

  On macOS:

      brew install autoconf automake autoconf-archive

Call Stack (most recent call first):
  scripts/ports.cmake:192 (include)


-- Using cached python-cpython-v3.11.8.tar.gz.
-- Cleaning sources at /home/m-d-nabeel/vcpkg/buildtrees/python3/src/v3.11.8-fe0ac5827a.clean. Use --editable to skip cleaning for the packages you specify.
-- Extracting source /home/m-d-nabeel/vcpkg/downloads/python-cpython-v3.11.8.tar.gz
-- Applying patch 0001-only-build-required-projects.patch
-- Applying patch 0003-use-vcpkg-zlib.patch
-- Applying patch 0004-devendor-external-dependencies.patch
-- Applying patch 0005-dont-copy-vcruntime.patch
-- Applying patch 0008-python.pc.patch
-- Applying patch 0010-dont-skip-rpath.patch
-- Applying patch 0012-force-disable-modules.patch
-- Applying patch 0014-fix-get-python-inc-output.patch
-- Applying patch 0015-dont-use-WINDOWS-def.patch
-- Applying patch 0016-undup-ffi-symbols.patch
-- Applying patch 0018-fix-sysconfig-include.patch
-- Applying patch 0002-static-library.patch
-- Applying patch 0011-gcc-ldflags-fix.patch
-- Using source at /home/m-d-nabeel/vcpkg/buildtrees/python3/src/v3.11.8-fe0ac5827a.clean
-- Found external ninja('1.12.1').
-- Getting CMake variables for x64-linux-dbg
-- Getting CMake variables for x64-linux-rel
CMake Error at scripts/cmake/vcpkg_configure_make.cmake:721 (message):
  python3 requires autoconf from the system package manager (example: "sudo
  apt-get install autoconf")
Call Stack (most recent call first):
  /home/m-d-nabeel/.cache/vcpkg/registries/git-trees/42da794facada8d85273d1efcc53f1af7e8cb243/portfile.cmake:274 (vcpkg_configure_make)
  scripts/ports.cmake:192 (include)



```

**Additional context**

<details><summary>vcpkg.json</summary>

```
{
  "dependencies": [
    "python3",
    "pybind11"
  ]
}

```
</details>
