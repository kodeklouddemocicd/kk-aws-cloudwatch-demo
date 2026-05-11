## this script test stress, since the yum package mananger stress didnt activate test on old >> i added amazon epel before stress test
## ___ what to do __
## 1. go to a new ec2 connect keep database random data coming in 
## 2. cd 
## 3. vi stress_test.sh >> input the script 
## 4. bash stress_test.sh 
## follow the rest of the lesson 


#!/bin/bash

echo "Installing EPEL repository..."
sudo amazon-linux-extras install epel -y

echo "Installing stress tool..."
sudo yum install -y stress

echo "Checking if stress installed..."
if ! command -v stress &> /dev/null
then
    echo "ERROR: stress did not install."
    exit 1
fi

echo "Starting Disk Stress Test..."
dd if=/dev/zero of=/tmp/testfile bs=1M count=100 iflag=fullblock
rm -f /tmp/testfile

echo "Starting CPU Stress Test..."
stress --cpu 2 --timeout 60

echo "Starting Memory Stress Test..."
stress --vm 2 --vm-bytes 128M --timeout 60

echo "Stress testing complete."
