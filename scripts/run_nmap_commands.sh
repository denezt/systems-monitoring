#!/bin/bash

# This can also come from another file or database
sites=( 'garagebarge.com' )

for site in ${sites[*]};
do
    ping -c 3 ${site}
    nmap -A -v -T2 ${site}
done
