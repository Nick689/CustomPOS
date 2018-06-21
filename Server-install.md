# INSTALL PROCEDURE (for Debian linux)
for copy/paste on terminal use ctrl+shift+v (you must activate terminal shortcut keys)

# COMMANDS (when install is finished)
SSH CONNECT:	ssh *user@serverip* -p *portnumber*

REMOTE CONNECT:	mysql -h *serverip* -P *mariadbport* -u root -p

DUMP:	mysqldump -h *serverip* -P *mariadbport* -u dump -p custompos > dump.sql

DUMP:	ssh *user@serverip* -p *sshport* mysqldump -u root -p custompos > dump.sql

LOCAL RESTORE:	mysql -u root -p custompos < dump.sql

REMOTE RESTORE:
- on client copy dump file to /home/*user*/dump.sql  then:
  - scp -p *sshport* dump.sql *user@serverip*:/home/*user*/dump.sql
- on server cd /home/*user*/  then:
  - mysql -u root -p custompos < dump.sql

# SSH SETUP
apt-get install openssh-server	(if not already done)

apt-get install sudo 			(root is often brutforced and should be accessible only localy)

adduser *user* 				(if needed)

usermod -aG sudo *user*

nano /etc/sudoers
```
root ALL=(ALL:ALL) ALL
user ALL=(ALL:ALL) ALL
```

### on client
ssh-keygen -t rsa            	(save securely your passphrase)

ssh-copy-id *user@serverip*	(passphrase needed, if no key is found, reload key with:	ssh-add ~/.ssh/id_rsa)

### on server
nano /etc/ssh/sshd_config
```
Port [sshport]
Protocol 2
PubkeyAuthentication yes
PermitRootLogin no		(before activing this, verify if the user access works)
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
### restart ssh server
/etc/init.d/ssh reload

# TIME SERVER (customPOS use client date, they must be up to date)
apt-get install ntp

nano /etc/ntp.conf 	(change for your country NTP pool)

systemctl enable ntp	(for automatic NTP start on boot)

ntpq -p (to check if the server is synchronized)

sudo ntpdate serverip (to check if client can connect to the server)

# MARIADB
apt-get install mariadb-server	(if needed)

remove every *.cnf file in /etc/mysql and subdirectories except:    debian.cnf  debian-start  mariadb.cnf  my.cnf

mysql_secure_installation

nano /etc/mysql/mariadb.cnf
```
[client-server]
port=mariadbport

[mysqld]
character_set_server=latin1
sql_mode=STRICT_ALL_TABLES
default-storage-engine=InnoDB
default_tmp_storage_engine=InnoDB
enforce_storage_engine=InnoDB
datadir=/var/lib/mysql/
temp-pool
loose-innodb_file_per_table
innodb_buffer_pool_instances=2
innodb_buffer_pool_size=4G

[mysqldump]
quick
quote-names
max_allowed_packet      = 16M
```
/etc/init.d/mysql reload

check if mariadb is listening on your chosen port:	netstat -anp | grep *portnumber*

if not you may have duplicate config file

# CREATE DATABASE & TABLES & STORED PROCEDURES
ssh *user@serverip* -p *portnumber*

mysql -u root -p

copy/paste (ctrl+shift+v) the content of tables.sql directly on mysql session

copy/paste (ctrl+shift+v) the content of stored.procedure.sql directly on mysql session

# AUTOMATIC BACKUP (example for weekly backup everyday at 22h00, older files will be overwrited)
create and grant 'dump'@'localhost' :
```
CREATE USER 'dump'@'localhost' IDENTIFIED BY 'password';
GRANT LOCK TABLES,SELECT ON custompos.* TO 'dump'@'localhost';
```
crontab -e
```
0 22 * * 1 mysqldump -u dump -ppassword custompos > /home/user/dump1.sql
0 22 * * 2 mysqldump -u dump -ppassword custompos > /home/user/dump2.sql
0 22 * * 3 mysqldump -u dump -ppassword custompos > /home/user/dump3.sql
0 22 * * 4 mysqldump -u dump -ppassword custompos > /home/user/dump4.sql
0 22 * * 5 mysqldump -u dump -ppassword custompos > /home/user/dump5.sql
0 22 * * 6 mysqldump -u dump -ppassword custompos > /home/user/dump6.sql
0 22 * * 0 mysqldump -u dump -ppassword custompos > /home/user/dump0.sql
```

# USERS & PRIVILEGE
### CREATE AND GRANT ADMINISTRATOR (access via LibreOffice-Base, be carefull with these privileges: accidental mouse move will creat new inserts)
```
CREATE USER 'admin'@'x.x.x.%' IDENTIFIED BY 'password';
GRANT ALL ON custompos.customer TO 'admin'@'x.x.x.%';
GRANT SELECT,UPDATE,DELETE ON custompos.devis TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.devisdet TO 'admin'@'x.x.x.%';
GRANT SELECT,UPDATE,DELETE ON custompos.entree TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.entreedet TO 'admin'@'x.x.x.%';
GRANT SELECT,UPDATE,DELETE ON custompos.fact TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.factdet TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.fourn TO 'admin'@'x.x.x.%';
GRANT SELECT,UPDATE,DELETE ON custompos.regl TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.stk TO 'admin'@'x.x.x.%';
GRANT SELECT ON custompos.output TO 'admin'@'x.x.x.%';
GRANT ALL ON custompos.utilisateur TO 'admin'@'x.x.x.%';
```

### CREATE AND GRANT ASSISTANT (access via LibreOffice-Base, Example to adapt)
```
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE (datefact,utilisateur,numclient,nom,lieu,transport,bc,pay1,pay2,pay3,pay4,mode1,mode2,mode3,mode4,rendu,typefact,echeance,lettre,contact,chq1,chq2,chq3,chq4,bl) ON `custompos`.`fact` TO 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE (design) ON `custompos`.`factdet` TO 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE ON `custompos`.`regl` TO 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE ON `custompos`.`stk` TO 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE ON `custompos`.`customer` TO 'assistant'@'x.x.x.%';
GRANT SELECT,UPDATE (nom,fact) ON `custompos`.`entree` TO 'assistant'@'x.x.x.%';
GRANT SELECT ON `custompos`.`entreedet` TO 'assistant'@'x.x.x.%';
GRANT SELECT ON custompos.output TO 'assistant'@'x.x.x.%';
```

### CREATE AND GRANT PRIVILEGED USERS (for customPOS access)
```
CREATE USER 'user'@'x.x.x.%'  IDENTIFIED BY 'password';
GRANT SELECT,UPDATE ON custompos.customer TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.devis TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.devisdet TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.fact TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.factdet TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.regl TO 'user'@'x.x.x.%' 
GRANT SELECT,UPDATE ON custompos.stk TO 'user'@'x.x.x.%' 
GRANT SELECT ON custompos.utilisateur TO 'user'@'x.x.x.%' 
GRANT UPDATE (freecell) ON custompos.utilisateur TO 'user'@'x.x.x.%' 
GRANT EXECUTE ON PROCEDURE custompos.balances TO 'user'@'x.x.x.%' 
GRANT EXECUTE ON PROCEDURE custompos.balance TO 'user'@'x.x.x.%' 
GRANT EXECUTE ON PROCEDURE custompos.fdj2 TO 'user'@'x.x.x.%' 
```

### CREATE AND GRANT RESTRICTED USERS (for customPOS access)
```
CREATE USER 'user'@'x.x.x.%'  IDENTIFIED BY 'password'
GRANT SELECT,UPDATE ON custompos.customer TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.devis TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.devisdet TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.entree TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.entreedet TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.fact TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.factdet TO 'user'@'x.x.x.%' 
GRANT SELECT ON custompos.fourn TO 'user'@'x.x.x.%' 
GRANT SELECT,INSERT ON custompos.regl TO 'user'@'x.x.x.%' 
GRANT SELECT,UPDATE ON custompos.stk TO 'user'@'x.x.x.%' 
GRANT SELECT ON custompos.output TO 'user'@'x.x.x.%' 
GRANT SELECT ON custompos.utilisateur TO 'user'@'x.x.x.%' 
GRANT EXECUTE ON PROCEDURE custompos.balances TO 'user'@'x.x.x.%' 
GRANT EXECUTE ON PROCEDURE custompos.balance TO 'user'@'x.x.x.%' 
```
