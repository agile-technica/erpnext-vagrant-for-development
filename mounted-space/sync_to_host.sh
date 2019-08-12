#!/usr/bin/env bash

SECONDS=0 ;

if [ "$1" != "" ]; then
    echo "Sync specific frappe app only"
    rsync -ru --exclude='.git/' --exclude='bench.egg-info/' --exclude='.idea/' --exclude='pids/' --inplace --progress /home/vagrant/app/frappe-bench/apps/"$1"/ /mounted-space/app/frappe-bench/apps/"$1"/ 
else
    echo "Sync all"
    rsync -ru --exclude='.git/' --exclude='bench.egg-info/' --exclude='.idea/' --exclude='pids/' --inplace --progress  /home/vagrant/app/ /mounted-space/app/
fi

echo "Elapsed time:" $SECONDS "seconds"