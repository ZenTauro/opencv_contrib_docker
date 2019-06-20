#!/bin/bash

docker run -it --rm \
    -e DISPLAY="${DISPLAY}" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/user/develop:"$(pwd)" \
    opencv_contrib:1.0.0 \
    bash
