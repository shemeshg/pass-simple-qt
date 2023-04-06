#!/bin/sh
/Volumes/FAST/Qt/6.5.0/macos/bin/qt-cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ../pass-simple
cmake --build .
cmake --install .

# mv pass-simple.app "Pass simple.app"
# zip -r -y pass-simple-osx_0.43.0.zip ./Pass\ simple.app

# sftp iuqwer9@frs.sourceforge.net

# sftp> cd /home/frs/project/pass-simple
# sftp> rm pass-simple-osx_0.42.0.dmg
# sftp> put pass-simple-osx_0.43.0.dmg

# sha256sum put pass-simple-osx_0.43.0.dmg
