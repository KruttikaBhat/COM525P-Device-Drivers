


subject="Found File bigger then 100mb"
##sending mail as
from="gkb15997@gmail.com"
## sending mail to
to="ced16i010@iiitdm.ac.in"


## find files greater than 100mb
free=$ find /home/dell/Documents/ -type f -size +100000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }' 


## check if free memory is less or equals to  100MB
if [[ "$free" ]] 
then
        echo "\$free is empty"        
        
else
	ssmtp gkb15997@gmail.com < message.txt
        echo "\$free is not empty and mail was sent"
fi

exit 0
