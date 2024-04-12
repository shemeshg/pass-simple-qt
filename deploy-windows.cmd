CALL  "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
cd D:\projects\pass-simple-qt
git pull
cd gpgfactory
git pull
R:
cd \
mkdir deployed
cd deployed
call D:\Qt\6.7.0\msvc2019_64\bin\qt-cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. D:\projects\pass-simple-qt
call ninja
D:\Qt\6.7.0\msvc2019_64\bin\windeployqt.exe  --qmldir D:\projects\pass-simple-qt pass-simple.exe
cd \
move deployed pass-simple-windows-x64
powershell -Command "Compress-Archive -Path r:\pass-simple-windows-x64 -DestinationPath pass-simple-qt-1.0.4_win_x64.zip"
REM # rmdir /s/q pass-simple-windows-x64

