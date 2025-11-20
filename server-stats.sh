#!/bin/bash
# server-stats.sh — Basic Linux server performance stats
# Run: chmod +x server-stats.sh && ./server-stats.sh


GREEN="\e[32m"; YELLOW="\e[33m"; NC="\e[0m"


print_header() {
echo -e "${YELLOW}\n==================== $1 ====================${NC}"
}


# 1. CPU Usage
print_header "CPU Usage"
top -bn1 | grep "Cpu(s)" | \
awk '{print "CPU Usage: " 100 - $8 "% (Used), " $8 "% (Idle)"}'


# 2. Memory Usage
print_header "Memory Usage"
free_mem=$(free -m | awk 'NR==2{printf "Used: %sMB, Free: %sMB, Total: %sMB (%.2f%% used)", $3, $4, $2, $3*100/$2 }')
echo "$free_mem"


# 3. Disk Usage
print_header "Disk Usage"
df -h --total | awk '/total/ {printf "Used: %s, Free: %s, Total: %s (%.2f%% used)\n", $3, $4, $2, $3*100/($3+$4)}'


# 4. Top 5 processes by CPU
print_header "Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6


# 5. Top 5 processes by Memory
print_header "Top 5 Processes by Memory Usage"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6


# Stretch Goals
print_header "System Info"
echo "OS Version: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2)"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F 'load average:' '{print $2}')"
echo "Logged in users: $(who | wc -l)"


echo -e "${GREEN}\n✔ Script execution completed.${NC}"