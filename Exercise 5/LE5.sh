#!/bin/sh
ls
pwd
variable="Hello"
echo $variable
echo "What is your name?"
read name
echo "How do you do, $name?"
read remark
echo "I am $remark too!"
val=`expr 2 + 2`
echo "Total value : $val"
a=10
b=20
val=`expr $a + $b`
echo $val
val=`expr $a - $b`
echo $val
val=`expr $a \* $b`
echo $val
val=`expr $b / $a`
echo $val
val=`expr $a % $b`
echo $val
val=[ $a == $b ]
echo $val
val=[ $a != $b ] 
echo $val
val= a = $b
echo $val
a=10
val=[ $a -eq $b ] 
echo $val
val=[ $a -ne $b ] 
echo $val
val=[ $a -gt $b ] 
echo $val
val=[ $a -lt $b ] 
echo $val
val=[ $a -le $b ] 
echo $val
val=[ !false ] 
echo $val
val=[ $a -lt 20 -o $b -gt 100 ] 
echo $val
val=[ $a -lt 20 -a $b -gt 100 ] 
echo $val
a="abc"
b="efg"
val=[ $a = $b ] 
echo $val
val=[ $a != $b ] 
echo $val
val=[ -z $a ] 
echo $val
val=[ -n $a ] 
echo $val 
val=[ $a ] 
echo $val

a=10
b=20

if [ $a == $b ]
then
   echo "a is equal to b"
fi

if [ $a != $b ]
then
   echo "a is not equal to b"
fi

if [ $a == $b ]
then
   echo "a is equal to b"
else
   echo "a is not equal to b"
fi

if [ $a == $b ]
then
   echo "a is equal to b"
elif [ $a -gt $b ]
then
   echo "a is greater than b"
elif [ $a -lt $b ]
then
   echo "a is less than b"
else
   echo "None of the condition met"
fi

FRUIT="kiwi"

case "$FRUIT" in
   "apple") echo "Apple pie is quite tasty." 
   ;;
   "banana") echo "I like banana nut bread." 
   ;;
   "kiwi") echo "New Zealand is famous for kiwi." 
   ;;
esac


a=0

while [ $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
for var in 0 1 2 3 4 5 6 7 8 9
do
   echo $var
done
a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done


a=0
while [ "$a" -lt 10 ]    # this is loop1
do
   b="$a"
   while [ "$b" -ge 0 ]  # this is loop2
   do
      echo -n "$b "
      b=`expr $b - 1`
   done
   echo
   a=`expr $a + 1`
done
a=0

while [ $a -lt 10 ]
do
   echo $a
   if [ $a -eq 5 ]
   then
      break
   fi
   a=`expr $a + 1`
done
for var1 in 1 2 3
do
   for var2 in 0 5
   do
      if [ $var1 -eq 2 -a $var2 -eq 0 ]
      then
         break 2
      else
         echo "$var1 $var2"
      fi
   done
done
NUMS="1 2 3 4 5 6 7"

for NUM in $NUMS
do
   Q=`expr $NUM % 2`
   if [ $Q -eq 0 ]
   then
      echo "Number is an even number!!"
      continue
   fi
   echo "Found odd number"
done
DATE=`date`
echo "Date is $DATE"

USERS=`who | wc -l`
echo "Logged in user are $USERS"

UP=`date ; uptime`
echo "Uptime is $UP"
echo ${var:-"Variable is not set"}
echo "1 - Value of var is ${var}"

echo ${var:="Variable is not set"}
echo "2 - Value of var is ${var}"

unset var
echo ${var:+"This is default value"}
echo "3 - Value of var is $var"

var="Prefix"
echo ${var:+"This is default value"}
echo "4 - Value of var is $var"

echo ${var:?"Print this message"}
echo "5 - Value of var is ${var}"
who > users
cat users
wc -l users
cat << EOF
This is a simple lookup program 
for good (and bad) restaurants
in Cape Town.
EOF	
