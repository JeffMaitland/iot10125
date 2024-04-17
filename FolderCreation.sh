#!/bin/bash

folders_created=0
departments=("HR" "IT" "Finance" "Executive" "Administrative" "CallCentre")

# Deleted if exist
sudo rm -Rf /EmployeeData

# Creating the EmployeeData root folder
sudo mkdir /EmployeeData
cd /EmployeeData

for department in ${departments[@]}; do
#  echo $department
  sudo mkdir $department

  if [ $department == "Executive" ] || [ $department == "HR" ]
  then
    sudo chmod -R 760 $department
  else
    sudo chmod -R 764 $department
  fi

  sudo chown -R :$department $department
  ((folders_created++))
done

echo $folders_created folders were created
