#!/bin/bash

GDK_BACKEND=x11 evolution -c mail &
sleep 1
pid=$( pgrep -x evolution )
QT_QPA_PLATFORM=xcb kdocker -q -x $pid
