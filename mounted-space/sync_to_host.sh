#!/usr/bin/env bash

rsync -ru --inplace --exclude='.git/' --exclude='bench.egg-info/' --exclude='.idea/' --exclude='pids/' --progress /home/vagrant/app/ /mounted-space/app/

