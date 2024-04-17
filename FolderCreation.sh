#!/bin/bash
#set the counter for each folder create
folderCounter=0
#create a array and count the amount
groups=("HR" "IT" "Finance" "Executive" "Administrative" "CallCentre")
numGroups=${#groups[@]} 

# Deleted if the folder is already exist
sudo rm -Rf /EmployeeData

# Creating the EmployeeData root folder
sudo mkdir /EmployeeData
cd /EmployeeData

# creating a while loop to do the task
times=0
while [ $times -lt $numGroups ]; do
  group=${groups[$times]}
  sudo mkdir $group
  if [ $group != "Executive" ] || [ $group != "HR" ]
  then
    sudo chmod -R 764 $group
  else
    sudo chmod -R 760 $group
  fi
  sudo chown -R :$group $group
  ((times++))
#count the number of file that create
  ((folderCounter++))
done
#print the number of file that create
echo $folderCounter folders were created
