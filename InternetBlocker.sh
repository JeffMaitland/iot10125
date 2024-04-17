#!/bin/bash
# declare couter for user
numberOfUser = 0

# retrive the user in IT group from long Assignmen 1 
ITMembers=$(grep '^IT:' /etc/group | awk -F":" '{print $NF}')

IFS=',' read -ra users <<< "$ITMembers"
for user in "${users[@]}"; do
  echo "$user"

# using the line of command to creating a new iptables rule to allow incoming HTTPS packets
  sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner "$user" -j ACCEPT

  ((numberOfUser++))
done
# adding a local web server
	sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT

# deleting all the rules
sudo iptables -t filter -A OUTPUT -p tcp --dport 8003 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 1979 -j DROP

#prit the messege 
echo "Members in the IT group: $numberOfUser"
