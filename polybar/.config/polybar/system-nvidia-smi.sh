#!/bin/sh

nvidia-smi --query-gpu=utilization.memory --format=csv,noheader,nounits | awk '{ print ""$1"%"}'
