# erpnext-vagrant-for-development
Just a simple vagrant setup for development purpose so that it's easier to get instant feedback

The frappe and erpnext codes will be checked out under /mounted-space/

## Pre-requisite
install the vagrant volume plugin

### Virtual Box plugins to install 
1. vagrant plugin install vagrant-disksize
2. vagrant plugin install vagrant-vbguest

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
1. After provisioning, do vagrant ssh, then run /mounted-space/
2. Run sync_to_host.sh to sync the main apps for the first time (make sure everything is okay)
3. Install the apps that you want to work with
4. Run sync_to_host.sh to sync those apps again
5. Do you code changes in the /mounted-space/ in your host machine
5. Run sync_to_vm.sh to sync your changes to the VM so that you can see your changes in the website

## Why don't we just mount the code directory as it used to be?
Well, it works well for vanilla installation under Windows and it does work when you create new apps.
However if we do a frappe get-app, there are some os.rename operation that needs to be done. 
This does not work under Windows, even with the full administrative permissions. Probably since it's a shared VM drive.