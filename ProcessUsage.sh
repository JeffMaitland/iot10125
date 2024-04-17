#!/bin/bash

# Find the top 5 processes currently running on the system (By CPU%)
processes=$(ps -eo user,pid,%cpu --sort=-%cpu | head -n 6 | tail -n 5)

# Show the user the 5 processes
echo "Top 5 processes currently running on the system: "
echo "$processes"

# Asking user to confirm before killing the processes
read -p "Do you want to kill these 5 processes? (yes/no): " answer

# Using if statement to respond to user answer
if [ "$answer" = "yes" ]; then
    killed_processes=0

    # Using while to create a loop
    while IFS= read -r line; do
        username=$(echo "$line" | awk '{print $1}')
        pid=$(echo "$line" | awk '{print $2}')

        # Check whether the process is started by root
        if [ "$username" != "root" ]; then
            # Kill the process
            kill -9 "$pid"

            # Counter for the number of killed processes
            ((killed_processes++))

            # Show the details
            echo "Username: $username"
            echo "Start Time: $(ps -p $pid -o lstart= --no-headers)"
            echo "Death Time: $(date)" >> ~/ProcessUsageReport-$(date +"%Y-%m-%d").log
            echo "Department: $(id -gn "$username")"
        fi
    done <<< "$processes"

    # Show the number of processes killed
    echo "$killed_processes processes were killed."
fi
