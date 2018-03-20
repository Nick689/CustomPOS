# INSTALL PROCEDURE (on Debian linux)

## DIAGNOSTIC TOOLS (for getting information or access, it will not install anything)

- Shell command for local or ssh connection:
```
mysql -u user -p
```
- Shell command for remote connection (sudo needed some time)
```
mysql -h serverip -u user -p
```
- Shell command to see wich program is listenning on a given port:
```
sudo netstat -anp | grep portnumber
```
- SQL command to see all database users: (need ALL PRIVILEGES)
```
select user,host from mysql.user;
```

## STEP1: DATABASE DUMP:
default mysqldump setting is OK, no option are needed

### if you have mysql remote access with privilege on all table:
```
mysqldump -h serverip -P port -u root -p databasename > dump.sql
```

### if you have only ssh access:
```
ssh user@serverIP mysqldump -u user -p databasename > dump.sql
```
 
 
### In both case dump.sql is now in your /home


## STEP 2: SSH SETUP

### sudo and packages install
```
apt-get install sudo (not installed on debian 9 by default) 
add sudoers (there is some issue with root access over ssh):
adduser username
adduser username sudo
apt-get install openssh-server (if not already done)
apt-get install ntp (install NTP server, customPOS use client date, every client must be up to date) 
nano /etc/ntp.conf (if you want to change NTP pool)
systemctl enable ntp (to active automaticly NTP server on reboot)
ntpq -p (to check status of NTP server)
```

### SSH CONFIG: (on client)
```
ssh-keygen -t rsa            (keep in mind passphrase)
ssh-copy-id user@serverip
ssh-add             (passphrase will be requested)
```

### SERVER CONFIG: (on client over ssh)
- connect to the server: ssh use@serverip
- config ssh for more security: sudo nano /etc/ssh/sshd_config
```
Port portnumber (default port 22 is not advised)
Protocol 2
PubkeyAuthentication yes
PermitRootLogin no
RSAAuthentication no
UsePAM no
KerberosAuthentication no
GSSAPIAuthentication no
PasswordAuthentication no
ChallengeResponseAuthentication no
MaxAuthTries 10
ClientAliveInterval 600
ClientAliveCountMax 0
```

- restart ssh to make changes: sudo /etc/init.d/ssh reload

- reconnect with: ssh user@serverip -p portnumber

- server config for SSD: sudo nano /etc/fstab
```
tmpfs      /tmp            tmpfs        defaults,size=1g           0    0
tmpfs /var/log tmpfs defaults,nosuid,nodev,noatime,mode=0755,size=5% 0 0
sudo nano /etc/sysctl.conf
vm.swappiness=5
```


## STEP 3: MARIADB INSTALL: (over ssh)
sudo apt-get install mariadb-server

sudo mysql_secure_installation

sudo nano /etc/mysql/mariadb.cnf
```
[client-server]
port=????port number

[mysqld]
character_set_server=latin1
sql_mode=STRICT_ALL_TABLES
default-storage-engine=InnoDB
datadir=/var/lib/mysql/
temp-pool
loose-innodb_file_per_table
innodb_buffer_pool_instances=2
innodb_buffer_pool_size=4G
```
sudo /etc/init.d/mysql reload

### STEP 4: FIRST CONNECTION AND DATABASE CREATION: (over ssh or direct access)
sudo mysql -u root -p
```
CREATE DATABASE custompos;
CREATE USER  'root'@'serverip' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON custompos.* TO 'root'@'serverip' WITH GRANT OPTION;
exit
```

### STEP 5: DATABASE COPY:

- Method 1: (need mysql remote access with all privilege)
```
mysql -h host -u user_name -p custompos < dump.sql
```

- Method 2 via ssh/scp:
-- transfer database via ssh/scp:
--- cd to where is your dump file on client computer
--- scp -P sshportnumber dump.sql user@serverIP:/home/user/


-- Now your dump file is accesible on server, you can load database like this:
--- cd to dump file location on server (/home/user/)
--- sudo mysql -u root -p custompos < dump.sql

### STEP 6: STORED PROCEDURES INSTALL:
copy/paste via ssh the file content of stored.procedure.sql directly into an granted mysql session (no file copy needed)

### STEP 7: CREATE AND GRANT ADMINISTRATOR: (direct database access)
```
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON production.customer TO 'admin'@'localhost';
GRANT SELECT,UPDATE,DELETE ON production.devis TO 'admin'@'localhost';
GRANT ALL ON production.devisdet TO 'admin'@'localhost';
GRANT SELECT,UPDATE,DELETE ON production.entree TO 'admin'@'localhost';
GRANT ALL ON production.entreedet TO 'admin'@'localhost';
GRANT SELECT,UPDATE,DELETE ON production.fact TO 'admin'@'localhost';
GRANT ALL ON production.factdet TO 'admin'@'localhost';
GRANT ALL ON production.fourn TO 'admin'@'localhost';
GRANT SELECT,UPDATE,DELETE ON production.regl TO 'admin'@'localhost';
GRANT ALL ON production.stk TO 'admin'@'localhost';
GRANT SELECT ON production.output TO 'admin'@'localhost';
GRANT ALL ON production.utilisateur TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE production.soldes TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE production.solde TO 'admin'@'localhost';
GRANT EXECUTE ON PROCEDURE production.fdj TO 'admin'@'localhost';
```

### STEP 8: CREATE AND GRANT PRIVILEGED USERS: (for customPOS access)
```
CREATE USER 'user1'@'888.888.888.%' IDENTIFIED BY 'pass1pass2';
GRANT SELECT,UPDATE ON production.customer TO 'user1'@'888.888.888.%'
GRANT SELECT,INSERT ON production.devis TO 'user1'@'888.888.888.%'
GRANT SELECT,INSERT ON production.devisdet TO 'user1'@'888.888.888.%'
GRANT SELECT,INSERT ON production.fact TO 'user1'@'888.888.888.%'
GRANT SELECT,INSERT ON production.factdet TO 'user1'@'888.888.888.%'
GRANT SELECT,INSERT ON production.regl TO 'user1'@'888.888.888.%'
GRANT SELECT,UPDATE ON production.stk TO 'user1'@'888.888.888.%'
GRANT SELECT ON production.utilisateur TO 'user1'@'888.888.888.%'
GRANT EXECUTE ON PROCEDURE production.soldes TO 'user1'@'888.888.888.%'
GRANT EXECUTE ON PROCEDURE production.solde TO 'user1'@'888.888.888.%'
```

### STEP 9: CREATE AND GRANT RESTRICTED USERS: (for customPOS access)
```
CREATE USER 'user2'@'888.888.888.%' IDENTIFIED BY 'pass1pass2;
GRANT SELECT,UPDATE ON production.customer TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.devis TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.devisdet TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.entree TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.entreedet TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.fact TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.factdet TO 'user2'@'888.888.888.%'
GRANT SELECT ON production.fourn TO 'user2'@'888.888.888.%'
GRANT SELECT,INSERT ON production.regl TO 'user2'@'888.888.888.%'
GRANT SELECT,UPDATE ON production.stk TO 'user2'@'888.888.888.%'
GRANT SELECT ON production.output TO 'user2'@'888.888.888.%'
GRANT SELECT ON production.utilisateur TO 'user2'@'888.888.888.%'
GRANT UPDATE (freecell) ON production.utilisateur TO 'user2'@'888.888.888.%'
GRANT EXECUTE ON PROCEDURE production.soldes TO 'user2'@'888.888.888.%'
GRANT EXECUTE ON PROCEDURE production.solde TO 'user2'@'888.888.888.%'
GRANT EXECUTE ON PROCEDURE production.fdj TO 'user2'@'888.888.888.%'
```
