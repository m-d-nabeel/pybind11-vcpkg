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
    fs::path exe_path = fs::canonical("/proc/self/exe");
    fs::path project_root = exe_path.parent_path().parent_path();
    fs::path python_modules_path = project_root / "python";

    // Add our python_modules directory to sys.path
    py::module_ sys = py::module_::import("sys");
    py::list path = sys.attr("path");
    path.insert(0, python_modules_path.string());

    std::cout << "Python module search paths:" << std::endl;
    for (const auto &p : path) {
      std::cout << py::str(p).cast<std::string>() << std::endl;
    }

    // Now try to import our module
    py::module_ hello = py::module_::import("hello");
    py::object result = hello.attr("greet")("World");
    std::cout << "Result from Python: " << result.cast<std::string>()
              << std::endl;

  } catch (py::error_already_set &e) {
    std::cerr << "Python error: " << e.what() << std::endl;
  } catch (std::exception &e) {
    std::cerr << "Standard exception: " << e.what() << std::endl;
  }

  return 0;
}