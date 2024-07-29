#!/usr/bin/env bash

deviceName="EON Smart Box"
resolution="1080p"
display=":0"


xfce4-terminal --command="bash -c 'sudo ufw disable; mkchromecast --display $display --name '\''$deviceName'\'' --control --notifications --video --resolution $resolution --screencast; sudo ufw enable; for i in {5..1}; do echo \"Closing terminal in \$i\"; sleep 1; done'"

