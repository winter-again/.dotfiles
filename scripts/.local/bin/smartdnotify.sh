#!/usr/bin/env bash

# NOTE: for SMART notifs; called from /etc/smartd.conf
notify-send "$SMARTD_DEVICESTRING" "$SMARTD_MESSAGE"
