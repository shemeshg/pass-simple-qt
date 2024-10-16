#!/bin/sh

# cd /Users/macos/Qt/6.8.0/Src/
# mkdir /Users/macos/DATA/develop/Qt6.8Static
# ./configure -release -static -opensource -confirm-license -prefix /Users/macos/DATA/develop/Qt6.8Static
# cmake --build . --parallel
# cmake --install .

rm -rf /Users/macos/DATA/develop/out
cd /Users/macos/DATA/develop/
mkdir out
cd out
/Users/macos/DATA/develop/Qt6.8Static/bin/qt-cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ../pass-simple-qt
cmake --build .
cmake --install .