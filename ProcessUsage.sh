#!/bin/bash

# Find the top 5 processes currently running on the system (By CPU%)
processes=$(ps -e -o %p, -o user:20 -o ,%C, -o lstart -o ,%c, -o %mem --sort=-%cpu --no-headers| head -n 5)

echo "The top 5 processes currently running on the system are:"
echo "$processes"

# Ask user for killing processes
read -p "Do you want to kill those processes that were started by any user except root? (y/n): " option

if [ $option == "y" ]
then
  # Set process counter
  num_process=0

  # Read every processes line
  while IFS="," read -r pid user cpu lstart command mem
  do
    # Remove all whitespace
    user="$(echo -e "$user" | tr -d '[:space:]')"

    # Check if user is not root
    if [ $user != "root" ]
    then
      # Get the primary group for user
      primary_group=$(id -gn "$user")

      # Send a SIGKILL signal
      kill -9 "$pid"

      # Increase process counter
      ((num_process++))

      # Log details
      echo -e "User: $user \t Department: $primary_group \t Started Time: $lstart \t Killed Time: $(date)" >> ~/ProcessUsageReport-$(date -d "today" +"%Y-%m-%d.%H.%M").log
    fi
  done <<< "$processes"

  # Show processes killed
  echo "Killed processes: $num_process"
else
  echo "No killed processes"
fi
