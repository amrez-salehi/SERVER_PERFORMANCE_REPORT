#!/bin/bash

# =====================================

# server-stats.sh

# Basic Linux Server Performance Stats

# =====================================

echo "====================================="
echo "      SERVER PERFORMANCE REPORT"
echo "====================================="
echo "Generated on: $(date)"
echo

# ---- OS and Uptime ----

echo ">>> System Information"
echo "Hostname: $(hostname)"
echo "OS Version: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
echo

# ---- CPU Usage ----

echo ">>> CPU Usage"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "Total CPU Usage: $CPU_USAGE%"
echo

# ---- Memory Usage ----

echo ">>> Memory Usage"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERC=$((MEM_USED * 100 / MEM_TOTAL))
echo "Total Memory: ${MEM_TOTAL} MB"
echo "Used Memory:  ${MEM_USED} MB"
echo "Free Memory:  ${MEM_FREE} MB"
echo "Memory Usage: ${MEM_PERC}%"
echo

# ---- Disk Usage ----

echo ">>> Disk Usage"
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_AVAIL=$(df -h --total | grep total | awk '{print $4}')
DISK_PERC=$(df -h --total | grep total | awk '{print $5}')
echo "Total Disk Space: $DISK_TOTAL"
echo "Used Disk Space:  $DISK_USED"
echo "Available Space:  $DISK_AVAIL"
echo "Disk Usage:       $DISK_PERC"
echo

# ---- Top 5 Processes by CPU ----

echo ">>> Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo

# ---- Top 5 Processes by Memory ----

echo ">>> Top 5 Processes by Memory Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo

# ---- Stretch Goal (Optional Extra Info) ----

echo ">>> Logged-in Users"
who
echo

echo ">>> Failed Login Attempts (Last 10)"
if command -v lastb >/dev/null 2>&1; then
sudo lastb | head -n 10
else
echo "Command 'lastb' not found or requires root privileges."
fi
echo

echo "====================================="
echo "         END OF REPORT"
echo "====================================="
