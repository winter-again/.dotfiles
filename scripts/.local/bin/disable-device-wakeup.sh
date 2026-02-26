#!/usr/bin/env bash

# meant to be triggered by disable-device-wakeup.service

WAKEUP="/proc/acpi/wakeup"
triggers=("LID0")

for trigger in "${triggers[@]}"; do
    # flip setting only if trigger is currently enabled
    if grep -qw "^$trigger.*enabled" "$WAKEUP"; then
        echo "$trigger" > "$WAKEUP"
    fi
done
