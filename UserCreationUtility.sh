#!/bin/bash

# Check if the file is provided
if ! test -f $1; then
  echo "It is required a file"
  exit 1
fi

# Set counters
new_users=0
new_groups=0

while IFS="," read -r firt_name last_name department
do

  # Create username follows the naming standard specified
  user_name=${firt_name:0:1}${last_name:0:7}

  # To remove special characters at the end
  department=$(echo "${department//[$'\t\r\n ']}")
  #echo "User $user_name and department $department"

  # Check if user exists
  if grep -q "^$user_name:" /etc/passwd ; then
    # Error message is shown when a user already exists
    echo "Error: user $user_name already exists"
  else
    # Create the user
    sudo useradd "$user_name"
    echo "User $user_name have been created"

    # new_users counter increased
    ((new_users++))

    # Check if group exists
    if ! grep -q "^$department:" /etc/group ; then
      # Create the group
      sudo groupadd "$department"
      echo "Group $department have been created"

      # new_groups counter increased
      ((new_groups++))
    fi

    # Error message is shown when a group already exists
    echo "User $user_name have been added to the group $department"
    sudo usermod -a -G "$department" "$user_name"
  fi

  # Make the users primary group their department group
  #sudo usermod -g "$department" "$user_name"
  #echo "User $user_name added to group $department"

# Read the csv file excluding the header line
done < <(tail -n +2 $1)

# Final message is shown with the correct details
echo
echo "Total user created: $new_users"
echo "Total groups created: $new_groups"
