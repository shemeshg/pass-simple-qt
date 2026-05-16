#!/usr/bin/env bash
set -e

# Resolve script directory in a portable way
script_dir="$(cd "$(dirname "$0")" && pwd)"

# Go to project root
cd "$script_dir/.."

# Create venv if missing
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    . .venv/bin/activate
    pip install cogapp Jinja2
else
    . .venv/bin/activate
fi

# Run cog on root CMakeLists
cog -r CMakeLists.txt

# List of directories that contain generator scripts
modules=(
    QmlCore
    Datetime
    DropdownWithList
    InputType
    EditYaml
    QmlApp
)

# Run generator in each module
for dir in "${modules[@]}"; do
    cd "$script_dir/../$dir"
    python3 genQmldirAndCMake.py
done
