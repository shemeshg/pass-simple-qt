#!/bin/sh
LD_LIBRARY_PATH=/opt/pass-simple/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH
export YDOTOOL_SOCKET=/tmp/.ydotool_socket
/opt/pass-simple/bin/pass-simple "$@"
