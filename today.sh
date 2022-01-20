#!/bin/bash

thisyear=$(date +%Y)
export thisyear
todayfile=$thisyear/$(date +%m)/$(date +%Y%m%d).md
export todayfile
yesterdaymonth=$(date +%m --date="yesterday")
export yesterdaymonth

retval=""

function find_last_log() {
    day_value=$1
    month_value=$(date +%m --date="now - $day_value days")
    filename=$(date +%Y%m%d --date="now - $day_value days").md
    filename_full_path=$thisyear/$month_value/$filename 

    if [ "$day_value" -gt 30 ]
    then
        retval="-1"
        return 2;
    fi

    if [ -f "$filename_full_path" ]
    then
        retval="$filename_full_path"
        return 1
    else
        find_last_log $(( "$day_value" + 1 ));
    fi
}

#yesterdayfile=$(find_last_log 1 )
find_last_log 1
yesterdayfile=$retval

# Initialize File with Typical Meetings
# TODO have something query Outlook for my calendar and add meetings here
cat <<EOF >> "$todayfile"

# SRE-Share Standup
# CPE Standup
# SRE-Work Standup
# SRE-Core Standup

EOF
# if the day file doesn't exist, grep the TODOs from yesterday and copy them over
#if [ ! -e $todayfile ]
#then
#    yesterday=$(date --date="1 day ago" +%Y%m%d".md")
#    yesterdaymonth=$(date --date="1 day ago" +%m)
#    yesterdayfile=$thisyear/$yesterdaymonth/$yesterday
#    yesterdayfile=$thisyear/$yesterdaymonth/$(python3 ./relative_date.py)".md"

if [ -e "$yesterdayfile" ]
then
    grep -i todo "$yesterdayfile" | awk '{ if ($1 ~ /^#/) { print "\n"$0 } else { print $0 } }' >> "$todayfile"
    echo >> "${todayfile}"
fi
#fi

# Open yesterday, today, and any other misc files in gvim with vertical splits
gvim -O $yesterdayfile $todayfile $1 $2 $3 $4 $5
