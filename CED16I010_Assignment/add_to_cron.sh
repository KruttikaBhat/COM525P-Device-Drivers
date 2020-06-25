#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "00 09 * * * ./backup.sh -local /home/dell/Desktop/GRE/ /home/dell/Desktop/" >> mycron
#install new cron file
crontab mycron
rm mycron
