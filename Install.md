# INSTALL (In construction)
## Server:
- sudo apt-get install mysql-server
- Default MySQL settings works, no need to change anything, except IP and port

## Administrator:
- Install **mysql-workbench** or any mysql manager
- Inject **Dump.sql**
- Inject **Stored procedures.sql**
- Create and grant **new users** like this:
```
CREATE USER 'newuser'@'ip' IDENTIFIED BY 'password';
GRANT SELECT,UPDATE ON mybase.customer TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.devis TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.devisdet TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.entree TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.entreedet TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.fact TO 'newuser'@'ip';
GRANT SELECT,INSERT ON mybase.factdet TO 'newuser'@'ip';
GRANT SELECT ON mybase.fourn TO 'newuser'@'ip';
GRANT SELECT ON mybase.regl TO 'newuser'@'ip';
GRANT SELECT,UPDATE ON mybase.stk TO 'newuser'@'ip';
GRANT SELECT ON mybase.output TO 'newuser'@'ip';
GRANT SELECT ON mybase.utilisateur TO 'newuser'@'ip';
GRANT UPDATE (freecell) ON mybase.utilisateur TO 'newuser'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.soldes TO 'newuser'@'ip';
GRANT EXECUTE ON PROCEDURE mybase.fdj TO 'newuser'@'ip';
FLUSH PRIVILEGES;
```
