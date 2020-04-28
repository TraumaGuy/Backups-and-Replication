#!/bin/sh

###############################
#  RSYNC Replica
#
#   HOW TO USE (put it in crontab)
#	    0 12 * * * sh /path/rsync_replica.sh >> /path/log.log
#
#   REQUIREMENTS
#       - to be able to ssh to host without password (only using PUB KEY)
#
#
#	Modification Log
#		2020-04-28  First version
#		
#
#
###############################

##	RSYNC CONFIGURATION
#   It must include:
#   SSHPASS=passphrase      - ssh password in order to shutdown the remote when finish
#   HOST=NAS                - hostname indicated in .ssh/config
#   IP=10.0.0.0             - Network Address (not the remote IP address) for WOL command
#   MAC=00:00:00:00:00      - remote MAC address for WOL command
#   MIN=5                   - Minutes to wait after WOL
. /home/jfc/scripts/rsync.conf

echo SSHPASS $SSHPASS
echo IP $IP
echo MAC $MAC
echo MIN $MIN

##   Starting WOL
echo "=============================================================================="
echo $(date +%Y%m%d-%H%M)" WOL of device $IP $MAC"
    bash /home/jfc/scripts/telegram-message.sh "RSYNC Replica" "WOL device $IP" > /dev/null

wakeonlan -i 192.168.100.0 00:11:32:44:9B:4B
if $? != 0; then
	bash /home/jfc/scripts/telegram-message.sh "RSYNC Replica" "ERROR during WOL" "of $IP"
    exit 1
fi

##   Waiting for start up
echo $(date +%Y%m%d-%H%M)" Waiting for Start up $IP $MAC"
sleep ${MIN}m

##  Starting Rsync folders


##   Turning off remote device

echo $SSHPASS | ssh -tt quiltra "sudo ps -A"

exit



info "Starting backup"
bash /home/jfc/scripts/telegram-message.sh "Borg Backup" "Repo: ${TITLE}" "Starting backup" > /dev/null

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create -s --compression auto,zlib,5 ${FULLREP} ${ORI}

backup_exit=$?

info "Pruning repository"
bash /home/jfc/scripts/telegram-message.sh "Borg Backup" "Repo: ${TITLE}" "Pruning repository" > /dev/null

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The 'QNAP-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune -v -s --list --keep-daily=$D --keep-weekly=$W --keep-monthly=$M $REP

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
	bash /home/jfc/scripts/telegram-message.sh "Borg Backup" "Repo: ${TITLE}" "Backup and Prune finished successfully" > /dev/null
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
	bash /home/jfc/scripts/telegram-message.sh "Borg Backup" "Repo: ${TITLE}" "Backup and/or Prune finished with warnings" > /dev/null
else
    info "Backup and/or Prune finished with errors"
	bash /home/jfc/scripts/telegram-message.sh "Borg Backup" "Repo: ${TITLE}" "Backup and/or Prune finished with errors" > /dev/null
fi

exit ${global_exit}
