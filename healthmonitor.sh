#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="system_health.log"

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Check CPU usage
check_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        log_message "WARNING: High CPU usage detected: ${cpu_usage}%"
    else
        log_message "INFO: CPU usage: ${cpu_usage}%"
    fi
}

# Check memory usage
check_memory_usage() {
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        log_message "WARNING: High memory usage detected: ${memory_usage}%"
    else
        log_message "INFO: Memory usage: ${memory_usage}%"
    fi
}

# Check disk usage
check_disk_usage() {
    disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if (( disk_usage > DISK_THRESHOLD )); then
        log_message "WARNING: High disk usage detected: ${disk_usage}%"
    else
        log_message "INFO: Disk usage: ${disk_usage}%"
    fi
}

# Check running processes
check_running_processes() {
    processes=$(ps aux | wc -l)
    log_message "INFO: Number of running processes: ${processes}"
}

# Main function
main() {
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
}

main
