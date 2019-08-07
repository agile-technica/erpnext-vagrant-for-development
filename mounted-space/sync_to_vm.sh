#!/usr/bin/env bash

rsync -r --inplace --progress /mounted-space/app/ /home/vagrant/app/ 

cd /home/vagrant/app/frappe-bench/ && bench migrate 

cd /mounted-space/