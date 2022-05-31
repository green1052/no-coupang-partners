#!/bin/bash

on_err() {
    ERROR_CODE=$?
    echo "error ${ERROR_CODE}"
    echo "the command executing at the time of the error was"
    echo "${BASH_COMMAND}"
    echo "on line ${BASH_LINENO[0]}"
    exit ${ERROR_CODE}
}
trap on_err ERR

NOW=`date -u +"%Y.%m.%d %H.%M.%S (UTC)"`

HOST_HEADER_LINES=$(grep -c '#.*' hosts.txt)
HOST_HEADER=$(head -${HOST_HEADER_LINES} hosts.txt)
HOST_LIST=$(tail -n +$((${HOST_HEADER_LINES}+1)) hosts.txt | sort -nf | uniq)
REGEX_LIST=()
UBL_LIST=()

echo "${HOST_HEADER}" > hosts.txt

while IFS= read -r line; do
    if [ -n "$line" ]; then
        line=${line,,}
        echo "$line" >> hosts.txt

        line=$(echo "$line" | sed 's/[\r\n]//g;')

        re=$(echo "$line" | sed 's/\./\\./g; s/\?/./g; s/\-/\\-/g; s/\*/\\w\*/g')
        REGEX_LIST+=($re)

        if [[ $line == *'?'* ]] || [[ $line == *'*'* && $line != '*'* ]]; then
            re="/^.*:\\/\\/$re\\//"
        else
            re="*://$line/*"
        fi

        UBL_LIST+=($re)
    fi
done <<< "$HOST_LIST"

function join { local IFS="$1"; shift; echo "$*"; }

REGEX=$(join '|' ${REGEX_LIST[@]})
UBL=$(join $'\n' ${UBL_LIST[@]})

##################################################

cat <<EOF > filter-share/search.txt
google.*#?#div[role="main"] div#search div[data-async-context] div[data-hveid]:-abp-contains(/${REGEX}/)
duckduckgo.com#?#div.result:-abp-contains(/${REGEX}/)
EOF