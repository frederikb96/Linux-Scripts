#!/bin/bash
#pkexec apt install nvidia-driver-390 -y \
echo "Laptop" \
&& doOwncloudConfigPause.py on \
&& doOwncloudAnacronPause.py on \
&& doLMatlabLaptop.sh \
&& echo "Matlab done!" \
&& echo "Shutdown ..." \
&& sleep 3 \
&& shutdown now
