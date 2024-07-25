#!/bin/bash

SOURCE_DIR="path"
REMOTE_SERVER="user@remoteserver:/backup"   
LOG_FILE="backup.log"

log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1">>$LOG_FILE

}

perform_backup(){
    scp -r "SOURCE_DIR" "REMOTE_SERVER"
    if [ $? -eq 0 ]; then
        log_message "INFO: Backup successful"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup successful"
    else
        log_message "ERROR: Backup failed"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Backup failed"
    fi
}


main(){
    perform_backup
}

main