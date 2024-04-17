#!/bin/bash

# Set a counter for users
userCounter=0

# Get users from the IT group
ITGroupMembers=$(grep '^IT:' /etc/group | awk -F":" '{print $NF}')

# Process every IT group members
IFS=',' read -ra users <<< "$ITGroupMembers"
for user in "${users[@]}"; do
  # Show user
  #echo "$user"

  # Allow incoming HTTPS packets
  sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $user -j ACCEPT

  ((userCounter++))
done

# Allow access to the local web server
sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT

# Dropping all special access
sudo iptables -t filter -A OUTPUT -p tcp --dport 8003 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 1979 -j DROP

echo "Number of users granted internet access: $userCounter"
