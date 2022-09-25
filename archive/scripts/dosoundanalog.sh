#!/bin/bash

analog=$(pacmd list-sinks | grep .analog-stereo)
i="99"

if [[ $analog == *"_00_"* ]]
then
	i="00"
elif [[ $analog == *"_01_"* ]]
then
	i="01"
elif [[ $analog == *"_02_"* ]]
then 
        i="02"
fi

pacmd set-default-sink alsa_output.pci-0000_${i}_1b.0.analog-stereo
