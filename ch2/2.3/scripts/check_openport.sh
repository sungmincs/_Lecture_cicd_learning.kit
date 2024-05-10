#!/usr/bin/env bash

netstat -anvp tcp | awk 'NR<3 || /LISTEN/'
