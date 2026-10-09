#!/bin/bash

/usr/bin/ipghost &

/root/.opencode/bin/opencode web --port 4096 --hostname 0.0.0.0

