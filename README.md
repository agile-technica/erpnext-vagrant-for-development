# erpnext-vagrant-for-development
Just a simple vagrant setup for development purpose so that it's easier to get instant feedback

The frappe and erpnext codes will be checked out under /mounted-space/

## Pre-requisite
install the vagrant volume plugin

On your terminal: vagrant plugin install vagrant-disksize


## To Run:
1. Open your terminal
2. vagrant up

## To Clean Up:
1. Make sure that you have completed your changes in the app directory if you made any 
2. Open your terminal
3. ./destroy.sh (in WINDOWS just delete the app folder and vagrant destroy)
This will destroy the virtual machine
Then move the app folder into one with timestamp postfix. 
This way if you forgot to push any changes, it's not all gone.

## How to work with the VM:
1. After provisioning, do vagrant ssh, then run /mounted-space/sync.sh
    This will run unison to sync everything to the mounted space
2. Work in the mounted space, then you can run sync again to get your files to the frappe working directory
3. Or, you can use rsync as well to sync between your host directory and the frappe VM

## Why don't we just mount the code directory as it used to be?
Well, it works well for vanilla installation under Windows and it does work when you create new apps.
However if we do a frappe get-app, there are some os.rename operation that needs to be done. 
This does not work under Windows, even with the full administrative permissions. Probably since it's a shared VM drive.