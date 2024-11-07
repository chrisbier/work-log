#!/bin/bash
# Run this once the work day is over to automatically grab today's updates
# * Doesn't automatically grab the last work day of the previous month if you forgot to add it

year=$(date +%Y)
month=$(date +%m)
fullday=$(date +%Y-%m-%d)

#git add ToDo_iManage.md
#git add FrankMeetings.md
git add "$year"/"$month"/*
git commit -m "End of Day $fullday"

#killall firefox
#killall firefox-bin
killall lens
killall codium
killall zoom
