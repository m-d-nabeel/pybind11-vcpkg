#include <filesystem>
#include <iostream>
#include <pybind11/embed.h>
#include <pybind11/pybind11.h>

namespace py = pybind11;
namespace fs = std::filesystem;

int main() {
  py::scoped_interpreter guard{};

  try {
    // Get the executable path
    fs::path exe_path            = fs::canonical("/proc/self/exe");
    fs::path project_root        = exe_path.parent_path().parent_path();
    fs::path python_modules_path = project_root / "python_modules";
    fs::path site_packages_path  = "/home/m-d-nabeel/Projects/pybind/env/lib/python3.8/site-packages";

    // Add our python_modules directory to sys.path
    py::module_ sys = py::module_::import("sys");
    py::list path   = sys.attr("path");
    path.insert(0, python_modules_path.string());
    path.insert(0, site_packages_path.string());

    std::cout << "Python module search paths:" << std::endl;
    for (const auto &p : path) {
      std::cout << py::str(p).cast<std::string>() << std::endl;
    }

    // Import the hello module and call the greet function
    py::module_ hello = py::module_::import("hello");
    py::object result = hello.attr("greet")("World");
    std::cout << "Result from Python: " << result.cast<std::string>() << std::endl;

    py::module_ spleeter         = py::module_::import("spleeter");
    py::module_ spleeter_wrapper = py::module_::import("spleeter_wrapper");
    py::object result2 =
        spleeter_wrapper.attr("separate_audio")("/home/m-d-nabeel/Projects/pybind/example/on-and-on.mp3", "/home/m-d-nabeel/Projects/pybind/example");
    std::cout << "Result from Python: " << result2.cast<std::string>() << std::endl;

  } catch (py::error_already_set &e) {
    std::cerr << "Python error: " << e.what() << std::endl;
  } catch (std::exception &e) {
    std::cerr << "Standard exception: " << e.what() << std::endl;
  }

  return 0;
}