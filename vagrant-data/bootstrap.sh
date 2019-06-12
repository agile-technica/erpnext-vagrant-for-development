#!/usr/bin/env bash

#we'll use localhost, but if need be we can also use host file later on
NEWSITENAME="erpnextdev.agiletechnica.com"
ERPNEXT_GIT="https://github.com/agile-technica/erpnext.git"
FRAPPE_GIT="https://github.com/agile-technica/frappe.git"

#force ipv4 for apt so that we don't wait for timeouts
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

sudo apt-get install ssh -y
sudo service ssh restart


sudo apt-get install curl -y
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

# set default password
DB_ROOT_PASSWORD="root"

sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DB_ROOT_PASSWORD"

sudo debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password password $DB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password_again password $DB_ROOT_PASSWORD"

sudo apt-get install mariadb-server mariadb-client -y
sudo apt-get install libmysqlclient-dev -y
sudo apt-get install openssh-server -y

#change mariadb config
#setup the virtualhost, here we will use the default in this server
read -r -d '' MARIADBMYCNFCONTENTS << EOF
# MariaDB database server configuration file.
#
# You can copy this file to one of:
# - "/etc/mysql/my.cnf" to set global options,
# - "~/.my.cnf" to set user-specific options.
# 
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

# This will be passed to all mysql clients
# It has been reported that passwords should be enclosed with ticks/quotes
# escpecially if they contain "#" chars...
# Remember to edit /etc/mysql/debian.cnf when changing the socket location.
[client]
port		= 3306
socket		= /var/run/mysqld/mysqld.sock

# Here is entries for some specific programs
# The following values assume you have at least 32M ram

# This was formally known as [safe_mysqld]. Both versions are currently parsed.
[mysqld_safe]
socket		= /var/run/mysqld/mysqld.sock
nice		= 0

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

#
# * Basic Settings
#
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc_messages_dir	= /usr/share/mysql
lc_messages	= en_US
skip-external-locking
#
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address		= 127.0.0.1
#
# * Fine Tuning
#
max_connections		= 100
connect_timeout		= 5
wait_timeout		= 600
max_allowed_packet	= 16M
thread_cache_size       = 128
sort_buffer_size	= 4M
bulk_insert_buffer_size	= 16M
tmp_table_size		= 32M
max_heap_table_size	= 32M
#
# * MyISAM
#
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched. On error, make copy and try a repair.
myisam_recover_options = BACKUP
key_buffer_size		= 128M
#open-files-limit	= 2000
table_open_cache	= 400
myisam_sort_buffer_size	= 512M
concurrent_insert	= 2
read_buffer_size	= 2M
read_rnd_buffer_size	= 1M
#
# * Query Cache Configuration
#
# Cache only tiny result sets, so we can fit more in the query cache.
query_cache_limit		= 128K
query_cache_size		= 64M
# for more write intensive setups, set to DEMAND or OFF
#query_cache_type		= DEMAND
#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# As of 5.1 you can enable the log at runtime!
#general_log_file        = /var/log/mysql/mysql.log
#general_log             = 1
#
# Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.
#
# we do want to know about network errors and such
log_warnings		= 2
#
# Enable the slow query log to see queries with especially long duration
#slow_query_log[={0|1}]
slow_query_log_file	= /var/log/mysql/mariadb-slow.log
long_query_time = 10
#log_slow_rate_limit	= 1000
log_slow_verbosity	= query_plan

#log-queries-not-using-indexes
#log_slow_admin_statements
#
# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
#server-id		= 1
#report_host		= master1
#auto_increment_increment = 2
#auto_increment_offset	= 1
log_bin			= /var/log/mysql/mariadb-bin
log_bin_index		= /var/log/mysql/mariadb-bin.index
# not fab for performance, but safer
#sync_binlog		= 1
expire_logs_days	= 10
max_binlog_size         = 100M
# slaves
#relay_log		= /var/log/mysql/relay-bin
#relay_log_index	= /var/log/mysql/relay-bin.index
#relay_log_info_file	= /var/log/mysql/relay-bin.info
#log_slave_updates
#read_only
#
# If applications support it, this stricter sql_mode prevents some
# mistakes like inserting invalid dates etc.
#sql_mode		= NO_ENGINE_SUBSTITUTION,TRADITIONAL
#
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
default_storage_engine	= InnoDB
# you can't just change log file size, requires special procedure
#innodb_log_file_size	= 50M
innodb_buffer_pool_size	= 256M
innodb_log_buffer_size	= 8M
innodb_file_per_table	= 1
innodb_open_files	= 400
innodb_io_capacity	= 400
innodb_flush_method	= O_DIRECT
#
# * Security Features
#
# Read the manual, too, if you want chroot!
# chroot = /var/lib/mysql/
#
# For generating SSL certificates I recommend the OpenSSL GUI "tinyca".
#
# ssl-ca=/etc/mysql/cacert.pem
# ssl-cert=/etc/mysql/server-cert.pem
# ssl-key=/etc/mysql/server-key.pem

#
# * Galera-related settings
#
[galera]
# Mandatory settings
#wsrep_on=ON
#wsrep_provider=
#wsrep_cluster_address=
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#
# Allow server to accept connections on all interfaces.
#
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

[mysqldump]
quick
quote-names
max_allowed_packet	= 16M

[mysql]
#no-auto-rehash	# faster start of mysql but no tab completion
default-character-set = utf8mb4


[isamchk]
key_buffer		= 16M

#
# * IMPORTANT: Additional settings that can override those from this file!
#   The files must end with '.cnf', otherwise they'll be ignored.
#
!include /etc/mysql/mariadb.cnf
!includedir /etc/mysql/conf.d/

EOF


# write the maria DB data
echo "$MARIADBMYCNFCONTENTS" | sudo tee /etc/mysql/my.cnf

sudo service mysql restart

sudo apt-get -y install git python-dev python-setuptools python-pip libmysqlclient-dev redis-server

sudo apt-get install python-dev -y
sudo apt-get install python-setuptools python-pip virtualenv -y
sudo apt-get install redis-server -y
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

#sudo adduser --disabled-password --quiet --gecos "User" agiletechnica
#SERVERUSER_PASSWORD="agiletechnica"
# set password
#sudo echo "agiletechnica:$SERVERUSER_PASSWORD" | sudo chpasswd

#sudo usermod -aG sudo agiletechnica

mkdir /mounted-space/app

#sudo chown agiletechnica:agiletechnica /mounted-space/app

# run as agiletechnica
git clone https://github.com/frappe/bench /mounted-space/app/bench-repo

cd /mounted-space/app/ && sudo pip install -e bench-repo

sudo npm install -g yarn

sudo chown -R $USER:$GROUP ~/.npm
sudo chown -R $USER:$GROUP ~/.config

#do this so that windows doesn't crap out
export VIRTUALENV_ALWAYS_COPY=1

#move to the mounted app vagrant directory again 
cd /mounted-space/app/

echo "Initializing Frappe-Bench"
echo "bench init --frappe-path $FRAPPE_GIT --frappe-branch master frappe-bench"
bench init --frappe-path $FRAPPE_GIT --frappe-branch master frappe-bench

echo "Checking out ERPNEXT"
cd /mounted-space/app/frappe-bench && bench get-app erpnext $ERPNEXT_GIT --branch master



ADMIN_PASSWORD="administrator"

cd /mounted-space/app/frappe-bench && bench new-site --admin-password $ADMIN_PASSWORD --mariadb-root-password $DB_ROOT_PASSWORD --install-app erpnext --verbose $NEWSITENAME

cd /mounted-space/app/frappe-bench && bench config dns_multitenant on

#update the erpnext git remote so that it's not locked to master only
cd /mounted-space/app/frappe-bench/apps/erpnext
git fetch --unshallow 


read -r -d '' TERMINAL_MESSAGE << EOF
===============================================================================
 Welcome to Agile Technica's ERPNext Development Vagrant                                         
 Server Frappe user name: agiletechnica                                                          
 Server Frappe user password: $SERVERUSER_PASSWORD                                               
 ERPNext administrator password: $ADMIN_PASSWORD                                                 
 Database user: root                                                                             
 Database password: $DB_ROOT_PASSWORD                                                            
 Run using: 
    vagrant ssh
    cd /mounted-space/app/frappe-bench && bench start
 Access from browser: http://localhost:8000

 !If your initial setup keeps failing, just keep retrying, it's because Wekzeug
 detected changes and it decided to reload the server!

===============================================================================

EOF

echo "$TERMINAL_MESSAGE" | sudo tee -a /etc/motd