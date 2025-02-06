#!/bin/sh
# git tag -a v0.99 -m "commit"
# git push --tags
~/Qt/6.8.2/macos/bin/qt-cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ../pass-simple-qt
cmake --build .
cmake --install .

#mv pass-simple.app "Pass simple.app"
#zip -r -y pass-simple-macos_0.99.0.zip ./Pass\ simple.app
cpack -G DragNDrop

cp -R "Pass-simple.app" out;
ln -s /Applications out;
hdiutil create -volname "pass-simple" -srcfolder out -ov -format UDZO pass-simple-1.0.19-arm64.dmg


#sha256sum pass-simple-macos_0.99.0.zip

# sftp iuqwer9@frs.sourceforge.net

# sftp> cd /home/frs/project/pass-simple
# sftp> rm pass-simple-osx_0.55.0.dmg
# sftp> put pass-simple-macos_0.56.0.dmg
