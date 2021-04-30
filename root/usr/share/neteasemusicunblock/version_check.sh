#!/bin/bash
log_file="/tmp/neteasemusicunblock.log"
json_file="/tmp/neteasemusicunblock_latest.json"
if [ "$(uci get neteasemusicunblock.@neteasemusicunblock[0].auto_update)" == "1" ]; then
    echo "$(date -R) check latest version ..." >>"${log_file}"
    curl -s -o "${json_file}" https://api.github.com/repos/cnsilvan/neteasemusicunblock/releases/latest
    if [ $? -ne 0 ]; then
       echo "$(date -R) curl api.github.com failed" >>"${log_file}"
       exit 1
    fi
    currentTagCMD="$(neteasemusicunblock -v | grep Version | awk '{print $2}')"
    currentRuntimeCMD="$(neteasemusicunblock -v | grep runtime | awk -F\( '{print $2}' | awk '{print $3,$4}' | sed -E 's/\)//g'| sed 's/[ \t]*$//g')"
    latestTagCMD="$(cat ${json_file} | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/')"
    GOOSS="$(echo $currentRuntimeCMD | awk '{print $1}')"
    GOOS="linux"
    GOARCH="amd64"
    suffix="$(echo $currentRuntimeCMD | awk '{print $2}')"
    if [ ! -n "$suffix" ]; then
        suffix=".zip"
    fi
    if [ "$suffix" == "hardfloat" ]; then
        suffix=".zip"
    fi
    if [ -n "$(echo $GOOSS | awk -F/ '{print $1}')" ]; then
        GOOS="$(echo $GOOSS | awk -F/ '{print $1}')"
    fi
    if [ -n "$(echo $GOOSS | awk -F/ '{print $2}')" ]; then
        GOARCH="$(echo $GOOSS | awk -F/ '{print $2}')"
    fi
    downloadUrl="$(cat ${json_file} | grep '\"browser_download_url\":' | grep ${GOOS} | grep ${GOARCH} | grep ${suffix} | sed -E 's/.*\"([^\"]+)\".*/\1/')"
    if [ ! -n "${downloadUrl}" ]; then
       echo "$(date -R) not found ${currentRuntimeCMD} on GitHub,please go to https://github.com/cnsilvan/luci-app-neteasemusicunblock/issues to open a issue " >>"${log_file}"
       exit 1
    fi
    if [ "${currentTagCMD}" == "${latestTagCMD}" ]; then
        echo "$(date -R) current version: ${currentTagCMD}(${currentRuntimeCMD}) is the latest version" >>"${log_file}"
    else
        echo "$(date -R) start downloading the latest version[ ${currentTagCMD}(${currentRuntimeCMD}) >> ${latestTagCMD}(${currentRuntimeCMD}) ]..." >>"${log_file}"
        echo "$(date -R) ${downloadUrl}" >>"${log_file}"
        curl -LJO ${downloadUrl}
        if [ $? -eq 0 ]; then
            echo "$(date -R) download successful" >>"${log_file}"
            unzip $(find . -type f -name "*neteasemusicunblock*.zip") -d ./neteasemusicunblock/
            rm -f $(find . -type f -name "*neteasemusicunblock*.zip")
            chmod +x ./neteasemusicunblock/neteasemusicunblock
            if [ -n "$(./neteasemusicunblock/neteasemusicunblock -v | grep Version | awk '{print $2}')" ]; then
                mv ./neteasemusicunblock/neteasemusicunblock /usr/bin/
                rm -rf ./neteasemusicunblock/
                echo "$(date -R) update successful" >>"${log_file}"
                /etc/init.d/neteasemusicunblock restart
            else
                rm -rf ./neteasemusicunblock/
                echo "$(date -R) update failed. please check if the downloaded version is correct" >>"${log_file}"
            fi
        else
            echo "$(date -R) download failed" >>"${log_file}"

        fi

    fi

fi
