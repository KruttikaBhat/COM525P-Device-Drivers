FILE=/home/dell/Desktop/Semester\ 8/Device\ Drivers/Exercise\ 4/download.out

# the url to retrieve
URL=https://www.debian.org/

# write header information to the log file
#start_date=`date`
#echo "START-------------------------------------------------" > $FILE
#echo "" > $FILE

# retrieve the web page using curl. time the process with the time command.
#time (curl --connect-timeout 100 $URL) >> "$FILE"
curl -so /dev/null -w '%{time_total}\n' https://www.debian.org/ >> "$FILE"

# write additional footer information to the log file
#echo "" >> $FILE
#end_date=`date`
#echo "STARTTIME: $start_date" >> $FILE
#echo "END TIME:  $end_date" >> $FILE
#echo "" >> $FILE

#curl -so /dev/null -w '%{time_total}\n' https://www.debian.org/

