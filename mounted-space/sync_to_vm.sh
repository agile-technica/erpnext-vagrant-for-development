#!/usr/bin/env bash

rsync -ru --exclude='.git/' --exclude='bench.egg-info/' --exclude='.idea/' --exclude='pids/' --inplace --progress /mounted-space/app/ /home/vagrant/app/ 

cd /home/vagrant/app/frappe-bench/ && bench migrate 

cd /mounted-space/