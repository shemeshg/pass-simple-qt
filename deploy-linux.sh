#!/bin/sh
sudo  dpkg -r  pass-simple
~/Qt/6.5.0/gcc_64/bin/qt-cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ../pass-simple-qt

cmake --build .
cmake --install .

cpack -G DEB

sudo dpkg -i /home/ubuntu/Documents/gili/pass-simple-0.42-Linux.deb
