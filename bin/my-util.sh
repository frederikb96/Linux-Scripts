#!/bin/bash
xprop | awk '/PID/ {print $3}'
