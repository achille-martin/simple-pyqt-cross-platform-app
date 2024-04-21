#!/usr/bin/env bash

# MIT License

# Copyright (c) 2024 Achille MARTIN

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

###################################################
# PURPOSE
# -------
# Identify wheels 
# for desired non-standard python package
# with specific package version
# for the current OS specifications
#
# INPUTS
# ------
# * Python package name
# * Python package version number
# 
# OUTPUTS
# -------
# * Wheel name associated to input python package
###################################################

# Define print usage function
print_usage() {
    printf "Usage: get_python_package_wheel.sh <python_package_name> <python_package_version>\n"
}

# Ensure that package name and version are supplied
if [[ "$#" -ne 2 ]]; then
    print_usage
    exit 1
fi

# Define a custom error handler function
handle_error() {
    printf "An error occurred: $1\n"
    exit 1
}

# Set the error handler to be called when an error occurs
trap 'handle_error "please review the input arguments"' ERR

# Collect required arguments
python_package_name=$1
python_package_version=$2
printf "Python package deisred: $python_package_name\n"
printf "Python package version desired: $python_package_version\n"
printf "______\n"

# Create a temporary folder to download the wheels
temp_wheels_folder_path="$HOME/Downloads/temp_wheels"
mkdir -p $temp_wheels_folder_path

# Download the wheels for the current OS specifications
pip download --only-binary :all: --dest . --no-cache -d $temp_wheels_folder_path $python_package_name==$python_package_version

# Get the name of the wheels from the downloaded material
wheel_name=$(ls $temp_wheels_folder_path -tp | grep -v /$ | head -1)

# It is possible to remove the temporary wheel folder,
# but might look risky from a user perspective.
# User can manually delete the temporary folder if needed.

# Print out the name of the wheels
printf "______\n"
printf "Wheel name for Python package $python_package_name (version $python_package_version) and for current OS specifications is:\n"
printf "$wheel_name\n"