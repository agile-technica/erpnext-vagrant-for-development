# erpnext-vagrant-for-development
Just a simple vagrant setup for development purpose so that it's easier to get instant feedback

The frappe and erpnext codes will be checked out under /mounted-space/

## Pre-requisite
install the vagrant volume plugin

On your terminal: vagrant plugin install vagrant-disksize


## To Run:
1. Open your terminal (WINDOWS user ==> use administrative CMD, otherwise Yarn symlink is not going to work)
2. vagrant up

## To Clean Up:
1. Make sure that you have completed your changes in the app directory if you made any 
2. Open your terminal
3. ./destroy.sh (in WINDOWS just delete the app folder and vagrant destroy)
This will destroy the virtual machine
Then move the app folder into one with timestamp postfix. 
This way if you forgot to push any changes, it's not all gone.
