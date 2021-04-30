#!/bin/bash
log_max_size="128" #KB
log_file="/tmp/neteasemusicunblock.log"

((log_size = "$(ls -l "${log_file}" | awk -F ' ' '{print $5}')" / "1024"))
(("${log_size}" >= "${log_max_size}")) && echo "" >"${log_file}"
if [ "$(uci get neteasemusicunblock.@neteasemusicunblock[0].daemon_enable)" == "1" ]; then
    if [ -z "$(ps | grep "neteasemusicunblock" | grep -v "grep")" ]; then
        echo "$(date -R) try restart..." >>"${log_file}"
        /etc/init.d/neteasemusicunblock restart
    fi
fi
