#!/usr/bin/env sh
# 8888 for jupyter, 8050 for dash
podman run -it -p8888:8888 -p8050:8050 -v.:/home/user/notebook:U jupyter

