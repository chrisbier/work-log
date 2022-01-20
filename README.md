# work-log
These are the scripts I use to manage my work log. I create a new file named YYYYmmdd.md for each day, and keep them in subfolders in the format of YYYY/mm/YYYYmmdd.md

I generally organize things with Interruptions or unplanned requests in the top section, meetings in the middle, and then projects at the bottom.

## Scripts
* today.sh
 Grabs TODOs from the previous work day's file and adds them to today. It also adds the daily meetings to the top.
* endofday.sh
 Adds changes and commits them with the name "End of Day YYYYmmdd"
* githooks/post-commit
 A simple hook to push to the central repo after each commit.
* mkyear.sh
 Create the folder structure for each month in a new year.
