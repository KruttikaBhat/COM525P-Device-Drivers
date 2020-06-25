#!/bin/bash

readonly func=$1
shift


fn_sendmail(){
now=$(date +"%Y-%m-%d-%H%M%S")
subject="Backup on $now" 

echo "Back was done succesfully on $now, find the corresponding log file attached." > BODY
mpack -s "$subject" -d BODY $logFile gkb15997@gmail.com
}


writeToLog() {
echo -e "${1}" | tee -a "${logFile}"
}


fn_local(){
echo "Entered"
echo $1 
echo $2


# Configuration variables (change as you wish)
src="${1:-/path/to/source}"
dst="${2:-/path/to/target}"
backupDepth=${backupDepth:-7}
timeout=${timeout:-1800}
pathBak0="${pathBak0:-data}"
rotationLockFileName="${rotationLockFileName:-.rsync-rotation-lock}"
pathBakN="${pathBakN:-backup}"
nameBakN="${nameBakN:-backup}"
exclusionFileName="${exclusionFileName:-exclude.txt}"
dateCmd="${dateCmd:-date}"
logName="${logName:-rsync-incremental-backup_$(${dateCmd} -Id)_$(${dateCmd} +%H-%M-%S).log}"
ownFolderName="${ownFolderName:-.rsync-incremental-backup}"
logFolderName="${logFolderName:-log}"

# Combinate previously defined variables for use (don't touch this)
ownFolderPath="${HOME}/${ownFolderName}"
tempLogPath="${ownFolderPath}/local_${dst//[\/]/\\}"
exclusionFilePath="${ownFolderPath}/${exclusionFileName}"
bak0="${dst}/${pathBak0}"
rotationLockFilePath="${dst}/${rotationLockFileName}"
logPath="${dst}/${pathBakN}/${logFolderName}"
logFile="${tempLogPath}/${logName}"

# Prepare own folder
mkdir -p "${tempLogPath}"
touch "${logFile}"
touch "${exclusionFilePath}"

writeToLog "********************************"
writeToLog "*                              *"
writeToLog "*   rsync-incremental-backup   *"
writeToLog "*                              *"
writeToLog "********************************"

# Prepare backup paths
i=1
while [ "${i}" -le "${backupDepth}" ]
do
	export "bak${i}=${dst}/${pathBakN}/${nameBakN}.${i}"
	true "$((i = i + 1))"
done

writeToLog "\\n[$(${dateCmd} -Is)] You are going to backup"
writeToLog "\\tfrom:  ${src}"
writeToLog "\\tto:    ${bak0}"

# Prepare paths at destination
mkdir -p "${dst}" "${logPath}"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending begins\\n"

# Send old pending logs to destination
rsync -rhv --remove-source-files --exclude="${logName}" --log-file="${logFile}" \
	"${tempLogPath}/" "${logPath}/"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending finished"

# Rotate backups if last rsync succeeded ..
if ([ ! -e "${rotationLockFilePath}" ])
then
	# .. and there is previous data
	if [ -d "${bak0}" ]
	then
		writeToLog "\\n[$(${dateCmd} -Is)] Backups rotation begins"

		true "$((i = i - 1))"

		# Remove the oldest backup if exists
		bak="bak${i}"
		rm -rf "${!bak}"

		# Rotate the previous backups
		while [ "${i}" -gt 0 ]
		do
			bakNewPath="bak${i}"
			true "$((i = i - 1))"
			bakOldPath="bak${i}"
			if [ -d "${!bakOldPath}" ]
			then
				mv "${!bakOldPath}" "${!bakNewPath}"
			fi
		done

		writeToLog "[$(${dateCmd} -Is)] Backups rotation finished\\n"
	else
		writeToLog "\\n[$(${dateCmd} -Is)] No previous data found, there is no backups to be rotated\\n"
	fi
else
	writeToLog "\\n[$(${dateCmd} -Is)] Last backup failed, backups will not be rotated\\n"
fi

# Set rotation lock file to detect in next run when backup fails
touch "${rotationLockFilePath}"

writeToLog "[$(${dateCmd} -Is)] Backup begins\\n"

# Do the backup
if rsync -achv --progress --timeout="${timeout}" --delete -W --link-dest="${bak1}/" \
	--log-file="${logFile}" --exclude="${ownFolderPath}" --chmod=+r \
	--exclude-from="${exclusionFilePath}" "${src}/" "${bak0}/"
then
	writeToLog "\\n[$(${dateCmd} -Is)] Backup completed successfully\\n"
	fn_sendmail "${logFile}"    #send a mail on successful backup
	# Clear unneeded partials and lock file
	rm -rf "${rotationLockFilePath}"
	rsyncFail=0
else
	writeToLog "\\n[$(${dateCmd} -Is)] Backup failed, try again later\\n"
	rsyncFail=1
fi

# Send the complete log file to destination
mv "${logFile}" "${logPath}"

exit "${rsyncFail}"

}

fn_system(){

# Configuration variables (change as you wish)
src="/"
dst="${1:-/mnt/path/to/target}"
backupDepth=${backupDepth:-7}
timeout=${timeout:-1800}
pathBak0="${pathBak0:-data}"
rotationLockFileName="${rotationLockFileName:-.rsync-rotation-lock}"
pathBakN="${pathBakN:-backup}"
nameBakN="${nameBakN:-backup}"
exclusionFileName="${exclusionFileName:-exclude.txt}"
dateCmd="${dateCmd:-date}"
logName="${logName:-rsync-incremental-backup_$(${dateCmd} -Id)_$(${dateCmd} +%H-%M-%S).log}"
ownFolderName="${ownFolderName:-.rsync-incremental-backup}"
logFolderName="${logFolderName:-log}"

# Combinate previously defined variables for use (don't touch this)
ownFolderPath="${HOME}/${ownFolderName}"
tempLogPath="${ownFolderPath}/system_${dst//[\/]/\\}"
exclusionFilePath="${ownFolderPath}/${exclusionFileName}"
bak0="${dst}/${pathBak0}"
rotationLockFilePath="${dst}/${rotationLockFileName}"
logPath="${dst}/${pathBakN}/${logFolderName}"
logFile="${tempLogPath}/${logName}"

# Prepare own folder
mkdir -p "${tempLogPath}"
touch "${logFile}"
touch "${exclusionFilePath}"


writeToLog "********************************"
writeToLog "*                              *"
writeToLog "*   rsync-incremental-backup   *"
writeToLog "*                              *"
writeToLog "********************************"

# Prepare backup paths
i=1
while [ "${i}" -le "${backupDepth}" ]
do
	export "bak${i}=${dst}/${pathBakN}/${nameBakN}.${i}"
	true "$((i = i + 1))"
done

writeToLog "\\n[$(${dateCmd} -Is)] You are going to backup"
writeToLog "\\tfrom:  ${src}"
writeToLog "\\tto:    ${bak0}"

# Prepare paths at destination
mkdir -p "${dst}" "${logPath}"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending begins\\n"

# Send old pending logs to destination
rsync -rhv --remove-source-files --exclude="${logName}" --log-file="${logFile}" \
	"${tempLogPath}/" "${logPath}/"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending finished"

# Rotate backups if last rsync succeeded ..
if ([ ! -e "${rotationLockFilePath}" ])
then
	# .. and there is previous data
	if [ -d "${bak0}" ]
	then
		writeToLog "\\n[$(${dateCmd} -Is)] Backups rotation begins"

		true "$((i = i - 1))"

		# Remove the oldest backup if exists
		bak="bak${i}"
		rm -rf "${!bak}"

		# Rotate the previous backups
		while [ "${i}" -gt 0 ]
		do
			bakNewPath="bak${i}"
			true "$((i = i - 1))"
			bakOldPath="bak${i}"
			if [ -d "${!bakOldPath}" ]
			then
				mv "${!bakOldPath}" "${!bakNewPath}"
			fi
		done

		writeToLog "[$(${dateCmd} -Is)] Backups rotation finished\\n"
	else
		writeToLog "\\n[$(${dateCmd} -Is)] No previous data found, there is no backups to be rotated\\n"
	fi
else
	writeToLog "\\n[$(${dateCmd} -Is)] Last backup failed, backups will not be rotated\\n"
fi

# Set rotation lock file to detect in next run when backup fails
touch "${rotationLockFilePath}"

writeToLog "[$(${dateCmd} -Is)] Backup begins\\n"

# Do the backup (with mandatory exclusions)
if rsync -aAhv --progress --timeout="${timeout}" --delete -W --link-dest="${bak1}/" \
	--log-file="${logFile}" --exclude="${ownFolderPath}" --exclude-from="${exclusionFilePath}" \
	--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
	"${src}/" "${bak0}/"
then
	writeToLog "\\n[$(${dateCmd} -Is)] Backup completed successfully\\n"

	# Clear unneeded partials and lock file
	rm -rf "${rotationLockFilePath}"
	rsyncFail=0
else
	writeToLog "\\n[$(${dateCmd} -Is)] Backup failed, try again later\\n"
	rsyncFail=1
fi

# Send the complete log file to destination
mv "${logFile}" "${logPath}"

exit "${rsyncFail}"
}


fn_remote(){
# Configuration variables (change as you wish)
src="${1:-/path/to/source}"
dst="${2:-/path/to/target}"
remote="${3:-ssh_remote}"
backupDepth=${backupDepth:-7}
timeout=${timeout:-1800}
pathBak0="${pathBak0:-data}"
partialFolderName="${partialFolderName:-.rsync-partial}"
rotationLockFileName="${rotationLockFileName:-.rsync-rotation-lock}"
pathBakN="${pathBakN:-backup}"
nameBakN="${nameBakN:-backup}"
exclusionFileName="${exclusionFileName:-exclude.txt}"
dateCmd="${dateCmd:-date}"
logName="${logName:-rsync-incremental-backup_$(${dateCmd} -Id)_$(${dateCmd} +%H-%M-%S).log}"
ownFolderName="${ownFolderName:-.rsync-incremental-backup}"
logFolderName="${logFolderName:-log}"
interactiveMode="${interactiveMode:-no}"

# Combinate previously defined variables for use (don't touch this)
ownFolderPath="${HOME}/${ownFolderName}"
tempLogPath="${ownFolderPath}/${remote}_${dst//[\/]/\\}"
exclusionFilePath="${ownFolderPath}/${exclusionFileName}"
remoteDst="${remote}:${dst}"
bak0="${dst}/${pathBak0}"
remoteBak0="${remoteDst}/${pathBak0}"
partialFolderPath="${dst}/${partialFolderName}"
rotationLockFilePath="${dst}/${rotationLockFileName}"
logPath="${dst}/${pathBakN}/${logFolderName}"
remoteLogPath="${remote}:${logPath}"
logFile="${tempLogPath}/${logName}"

# Prepare own folder
mkdir -p "${tempLogPath}"
touch "${logFile}"
touch "${exclusionFilePath}"


writeToLog "********************************"
writeToLog "*                              *"
writeToLog "*   rsync-incremental-backup   *"
writeToLog "*                              *"
writeToLog "********************************"

# Prepare backup paths
i=1
while [ "${i}" -le "${backupDepth}" ]
do
	export "bak${i}=${dst}/${pathBakN}/${nameBakN}.${i}"
	true "$((i = i + 1))"
done

writeToLog "\\n[$(${dateCmd} -Is)] You are going to backup"
writeToLog "\\tfrom:  ${src}"
writeToLog "\\tto:    ${remoteBak0}"

# Prepare ssh parameters for socket connection, reused by following sessions
sshParams=(-o "ControlPath=\"${ownFolderPath}/ssh_connection_socket_%h_%p_%r\"" -o "ControlMaster=auto" \
	-o "ControlPersist=10")

# Prepare rsync transport shell with ssh parameters (escape for proper space handling)
rsyncShellParams=(-e "ssh$(for i in "${sshParams[@]}"; do echo -n " '${i}'"; done)")

batchMode="yes"
if [ "${interactiveMode}" = "yes" ]
then
	batchMode="no"
fi

# Check remote connection and create master socket connection
if ! ssh "${sshParams[@]}" -q -o BatchMode="${batchMode}" -o ConnectTimeout=10 "${remote}" exit
then
	writeToLog "\\n[$(${dateCmd} -Is)] Remote destination is not reachable"
	exit 1
fi

# Prepare paths at destination
ssh "${sshParams[@]}" "${remote}" "mkdir -p ${dst} ${logPath}"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending begins\\n"

# Send old pending logs to destination
rsync "${rsyncShellParams[@]}" -rhvz --remove-source-files --exclude="${logName}" --log-file="${logFile}" \
	"${tempLogPath}/" "${remoteLogPath}/"

writeToLog "\\n[$(${dateCmd} -Is)] Old logs sending finished"

# Rotate backups if last rsync succeeded ..
if (ssh "${sshParams[@]}" "${remote}" "[ ! -d ${partialFolderPath} ] && [ ! -e ${rotationLockFilePath} ]")
then
	# .. and there is previous data
	if (ssh "${sshParams[@]}" "${remote}" "[ -d ${bak0} ]")
	then
		writeToLog "\\n[$(${dateCmd} -Is)] Backups rotation begins"

		true "$((i = i - 1))"

		# Remove the oldest backup if exists
		bak="bak${i}"
		ssh "${sshParams[@]}" "${remote}" "rm -rf ${!bak}"

		# Rotate the previous backups
		while [ "${i}" -gt 0 ]
		do
			bakNewPath="bak${i}"
			true "$((i = i - 1))"
			bakOldPath="bak${i}"
			if (ssh "${sshParams[@]}" "${remote}" "[ -d ${!bakOldPath} ]")
			then
				ssh "${sshParams[@]}" "${remote}" "mv ${!bakOldPath} ${!bakNewPath}"
			fi
		done

		writeToLog "[$(${dateCmd} -Is)] Backups rotation finished\\n"
	else
		writeToLog "\\n[$(${dateCmd} -Is)] No previous data found, there is no backups to be rotated\\n"
	fi
else
	writeToLog "\\n[$(${dateCmd} -Is)] Last backup failed, backups will not be rotated\\n"
fi

# Set rotation lock file to detect in next run when backup fails
ssh "${sshParams[@]}" "${remote}" "touch ${rotationLockFilePath}"

writeToLog "[$(${dateCmd} -Is)] Backup begins\\n"

# Do the backup
if rsync "${rsyncShellParams[@]}" -achvz --progress --timeout="${timeout}" --delete --no-W \
	--partial-dir="${partialFolderName}" --link-dest="${bak1}/" --log-file="${logFile}" --exclude="${ownFolderPath}" \
	--chmod=+r --exclude-from="${exclusionFilePath}" "${src}/" "${remoteBak0}/"
then
	writeToLog "\\n[$(${dateCmd} -Is)] Backup completed successfully\\n"

	# Clear unneeded partials and lock file
	ssh "${sshParams[@]}" "${remote}" "rm -rf ${partialFolderPath} ${rotationLockFilePath}"
	rsyncFail=0
else
	writeToLog "\\n[$(${dateCmd} -Is)] Backup failed, try again later\\n"
	rsyncFail=1
fi

# Send the complete log file to destination
if scp "${sshParams[@]}" "${logFile}" "${remoteLogPath}"
then
	rm "${logFile}"
fi

# Close master socket connection quietly
ssh "${sshParams[@]}" -q -O exit "${remote}"

exit "${rsyncFail}"
}


fn_restore(){
echo "Entered"
echo $1 
echo $2
# Configuration variables (change as you wish)
src="${1:-/path/to/source}"
dst="${2:-/path/to/target}"

if rsync -aP $src $dst
then 
	echo "\\n[$(${dateCmd} -Is)] Restoration completed successfully\\n"
	rsyncFail=0
else
	rsyncFail=1
fi		
	

exit "${rsyncFail}"


}

while [ "$#" -gt 0 ]; do
  case $func in
    -local) 
    	fn_local $1 $2
    	break
    	;;
    -system)
    	fn_system $1
    	break
    	;;
    -remote)
    	fn_remote $1 $2 $3
    	break
    	;;
    -restore) 
	fn_restore $1 $2
    	break
    	;;		
  esac
done

