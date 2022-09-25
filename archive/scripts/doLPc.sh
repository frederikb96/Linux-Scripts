#!/bin/bash
#pkexec apt install nvidia-driver-510 -y \
echo "Pc" \
&& doOwncloudConfigPause.py off \
&& doOwncloudAnacronPause.py off \
&& doLMatlabPc.sh \
&& echo "Matlab done!" \
&& echo "Rebooting..." \
&& sleep 3 \
&& reboot
