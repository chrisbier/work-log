#!/bin/bash
thisyear=$(date +%Y)
export thisyear
todayfile=journals/$(date +%Y_%m_%d).md
export todayfile
yesterdaymonth=$(date +%m --date="yesterday")
export yesterdaymonth
TODAY=$(date +%Y_%m_%d)
JOURNALS="journals"
PAGES="pages"

# Create initial
cat << EOF > ./${JOURNALS}/${TODAY}.md
- # 🕬 Interrupts
    -
- # 📆 Meetings

- # ✏️ Work

EOF

## Add in Today's Meetings

# Get Today's Meetings Template
MEETINGS_FILE_PREFIX="${PAGES}/Templates___$(date +%A)s"
# Is Sprint Week
weekofyear=$(date +%V)
POSTFIX=""
SPRINT_WEEK=true
MEETINGS_FILE="${MEETINGS_FILE_PREFIX}.md"
TEMP_FILE="/tmp/meetings.md"
if [[ -f "${TEMP_FILE}" ]]
then 
    rm "${TEMP_FILE}"
fi

# If week of year is even SPRINT_WEEK is False
if [[ $((weekofyear % 2)) == 0 ]]
then
    SPRINT_WEEK=false
    POSTFIX="Off-Sprint"
    # If the file exists, use it, if not, no changes.
    if [[ -f "${MEETINGS_FILE_PREFIX} ${POSTFIX}.md" ]]
    then
        MEETINGS_FILE="${MEETINGS_FILE_PREFIX} ${POSTFIX}.md"
    fi
fi

# Extract just the Templated Meetings
grep -E '^\s+\-' "${MEETINGS_FILE}" > ${TEMP_FILE}

# Insert today's meeting schedule
sed -ie '/📆 Meetings/r '"${TEMP_FILE}" "${JOURNALS}/${TODAY}.md"

rm "${TEMP_FILE}"

## End Today's Meetings


## Copy Yesterday's Work

retval=""

function find_last_log() {
    day_value=$1
    month_value=$(date +%m --date="now - $day_value days")
    filename=$(date +%Y_%m_%d --date="now - $day_value days").md
    filename_full_path="${JOURNALS}/${filename}"

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

# yesterdayfile=$(find_last_log 1 )
find_last_log 1
yesterdayfile=$retval
# echo $yesterdayfile

if [ -e "$yesterdayfile" ]
then
    # Find Work section and add Yesterday's Work
    grep -A 200 -E "✏️ Work" ${yesterdayfile} | grep -E "^\s-" | sed '/^\s-/a\            - ' >> ${todayfile}
else
    echo "ERROR: Yesterday File ${yesterdayfile} Not Found"
fi

## End Copy Work

# Delete temp file
rm "./${JOURNAL}/${TODAY}.mde"
