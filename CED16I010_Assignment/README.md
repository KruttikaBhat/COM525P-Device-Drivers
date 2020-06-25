## Requirements ##  
1. ssmtp : Installation reference https://askubuntu.com/questions/12917/how-to-send-mail-from-the-command-line
2. rsync : normally preinstalled
3. mpack : needs to be installed


## Functions ##
This script allows:  
1. backup of local files 
2. full system backup
3. backup to a remote server 
4. restore backed up files (from a local file only)

The script can be made to run regularly by modifying add_to_cron.sh, which will add the script as a cron job. A mail is sent to you with the log file, using ssmtp, whenever a backup is performed (but not when restoring). 


## To use ##
Before running this script, modify line 12 by replacing the given email address with your email address. Ensure ssmtp is set up and working before running the script.

Create backup.sh executable:
`chmod +x backup.sh`  
`./backup.sh -argument source-path destination-path`

where argument can be:  
1. local: if you are doing a backup of one directory  
Format: `./backup.sh -local source-path destination-path`  
Example: `./backup.sh -local /home/dell/Desktop/GRE/ /home/dell/Desktop/`

2. system: if you are backing up your system  
Format: `./backup.sh -system destination-path`  
Example: `./backup.sh -system /media/dell/New Volume2`  

3. remote: if you are backing to a remote server in this case the command would be ./backup.sh -remote source-path  destination-path server-address  
Format: `./backup.sh -remote source-path destination-path ssh_remote`  

4. restore: if you want to retrive the backed up files  
Format: `./backup.sh -restore source-path destination-path`  
Example: `./backup.sh -restore /home/dell/Desktop/data/ /home/dell/Desktop/GRE/`

## To automate ##
Before running, modify the script at line 4 to run at the time you wish, with the argument, source/destination that you require. An example is currently shown in the script. But if you run it as it is then you will get an error. 

Create the executable and run it:
`chmod +x add_to_cron.sh  
./add_to_cron.sh`
			
