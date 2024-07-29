# Description: Commands to setup the project

# For Python setup
# Create a virtual environment and install the dependencies
python -m venv env
source env/bin/activate
pip install -r requirements.txt

# For C++ setup
vcpkg install

# For C++ build
mkdir build
cd build
cmake ..
make