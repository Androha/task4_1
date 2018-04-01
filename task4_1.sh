#!/bin/bash
dname=$(dirname "$(readlink -f "$0")")
cd $dname
touch task4_1.out
exec 1>task4_1.out
echo '--Hardware--'
cpu=$(cat /proc/cpuinfo|grep 'model name'| cut  -f 2 )
ram=$(cat /proc/meminfo|grep 'MemTotal'| cut -f 2 -d ':')
brd=$(cat /sys/devices/virtual/dmi/id/board_{vendor,name,version} | paste -s -d ' ')
system=$(cat /sys/devices/virtual/dmi/id/product_serial)

if [[ $system -eq 0 ]]
then
system=Unknown
fi

echo "CPU $cpu"
echo "RAM: $ram"
echo "Motherboard: $brd"
echo "System Serial Number: $system"

echo '--System--'
distrib=$(grep 'DISTRIB_DESCRIPTION' /etc/lsb-release | cut -f 2 -d '"')
kern=$(uname -r)
installdt=$(ls -alct /|tail -1|awk '{print $6, $7, $8}')

hostName=$(uname -n)
uptime=$(uptime -p)
procRunning=$(ps -h|wc -l)
usrs=$(w -h|wc -l)

echo "OS Distribution: $distrib"
echo "Kernel version: $kern"
echo "Installation Date: $installdt"
echo "Hostname: $hostName"
echo "Uptime: $uptime"
echo "Processes running: $procRunning"
echo "User logged in: $usrs"

echo '--Network--'

for int in  $(ls /sys/class/net)
do
addr=$(ifconfig ${int}|grep 'inet addr'| cut -f 2 -d ':'| cut -f 1 -d ' ' )
mask=$(ifconfig ${int}|grep 'Mask'| cut -f 2 -d 'k'| cut -f 2 -d ':')
echo "$int: $addr/$mask"
done

