#!/bin/sh
/Volumes/FAST/Qt/6.5.0/macos/bin/qt-cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ../pass-simple
cmake --build .
cmake --install .
