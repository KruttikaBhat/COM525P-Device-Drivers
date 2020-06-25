# COM525P-Device-Drivers-Practise
Exercises done as part of the course Device Drivers.  

3. Write a shell program to send a mail to you if it find existence of a file with size more than 100MB.  
  * Install ssmtp. I used https://askubuntu.com/questions/12917/how-to-send-mail-from-the-command-line as reference. 
  * Modify line 12 in LE3.sh by changing the path of the directory you wish to check.  
  * Create the executable of LE3.sh by running, `chmod +x LE3.sh`
  * Finally run the script, `./LE3.sh`  

4. Write a shell program which will download a given web page through http url. Insert a timer code in that to print how much time is taken for download. Put above shell program in Cron and run it every 10 minutes for three hours and download same webpage. Find minimum and maximum download time manually from output data.  
  * Modify line 1 of LE4.sh to specify location of the output file.
  * `crontab -e` in terminal will allow you to edit the crontab file. Refer to 4-1.png for adding a cron job. This command runs the script every 10 minutes. You can change it to run whenever you want. To stop executing, remove the job from cronfile bby commenting it or deleting it. 
  
5. Write any shell program with more than 200 lines of source code excluding comments.  
6. Write a C program. Compile as a kernel object file with extension .ko. Insert above into kernel. Also remove.  
7. Write a simple Network Device Driver. Write a C program to capture network packets. Run this program when you type password in http access through browser. Manually find the password typed from captured http packet.  
  * Run sniffer.c in a terminal 
     `gcc sniffer.c -o sniffer -lpcap` 
     `sudo ./sniffer>test.txt ip`
  * Open a browser and type a password into an http access site, suzh as http://testphp.vulnweb.com/. 
  * Stop the sniffer.c program execution.
  * A test.txt file will have been created where you can search for the password.
  
8. Write a Device Deriver which uses the system call IOCTL to set parameters in a character or block device. Also write a user application program that call this driver to set the parameters. Check the output.  

9. Write a Keyboard Device driver which captures a password that got typed in a HTTPS secured browser link text box. Check the unencrypted password in log.  

15. C program which create a char device,  read and write in that.



