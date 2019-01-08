#!/usr/bin/env bash

### BASH Script to fix Network Manager dropping connections
### randomly.  GAWD IT'S ANNOYING!!!
###
### Adapted from:
### - https://stackoverflow.com/a/21621163
### - https://stackoverflow.com/a/33540439


if [[ 'root' == `whoami` ]]; then
    ## Y U NO USE restart?!?!?
    ##
    ## ..Apparently, you need to *wait* after stopping
    ##   before you start kicking things with any serious effect.
    ##
    ## Systemd. SUCKS. ROCKS.
    ##
    echo -e "\n  ...executing 'systemctl  stop  network'";
    systemctl  stop  network;
    sleep 1s;
    echo -n "     Network state is: ";  systemctl is-active network;
    
    # https://stackoverflow.com/a/12962098
    # https://stackoverflow.com/a/17788417
    counter=20;
    echo -e "\n  ...Network restarting in $counter seconds:";
    echo -n "    "
    while [[ 0 -lt "$counter" ]]; do
        sleep 1s;
        (( counter -= 1 ));
        echo -n " $counter"
    done

    echo -e "\n\n  ...executing 'systemctl  start  network'";
    systemctl  start  network;
    sleep 1s;
    echo -n "     Network state is: ";  systemctl is-active network;
    
    echo -e "\n  ...Testing network connectivity:";
    sleep 2s;
    ping -c2 8.8.8.8;
    
    exit "$?";
else
   cat << EOF
   
   You must be root to fix Network Manager's shenanigans

EOF
    exit 1;
fi

exit 99;

