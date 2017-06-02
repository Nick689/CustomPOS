## POS
![POS](https://github.com/Nick689/CustomPOS/blob/master/Preview/Facturation.png)

## Invoice view
![Invoice view](https://github.com/Nick689/CustomPOS/blob/master/Preview/Affichage%20facture.png)

## Item list
![Item list](https://github.com/Nick689/CustomPOS/blob/master/Preview/Liste%20articles.png)

## Invoice list
![Invoice list](https://github.com/Nick689/CustomPOS/blob/master/Preview/Liste%20factures.png)

## Invoice PRINT
![PRINT](https://github.com/Nick689/CustomPOS/blob/master/Preview/Invoice.png)

## Customers list
![Clients](https://github.com/Nick689/CustomPOS/blob/master/Preview/Clients.jpg)

## Customer balance
![balance](https://github.com/Nick689/CustomPOS/blob/master/Preview/Balance.png)


## Product database format
*  `refint` mediumint(7) NOT NULL AUTO_INCREMENT,
*  `refmag` varchar(13) NOT NULL,
*  `codebar` varchar(13) DEFAULT NULL,
*  `reffourn` varchar(13) DEFAULT NULL,
*  `ref5` varchar(13) DEFAULT NULL,
*  `ref6` varchar(13) DEFAULT NULL,
*  `cat` enum('00.NA','...') NOT NULL DEFAULT '00.NA',
*  `design` varchar(40) NOT NULL,
*  `product` varchar(40) DEFAULT NULL,
*  `inv2015` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `fourn` smallint(5) DEFAULT NULL,
*  `annu` decimal(10,1) NOT NULL DEFAULT '0.0',
*  `seuil` decimal(10,1) NOT NULL DEFAULT '0.0',
*  `qte` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `invtheo` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `invreel` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `invchk` tinyint(1) DEFAULT NULL,
*  `regime` enum('LIBRE','PGC','PPN','RS') DEFAULT 'LIBRE',
*  `tva` tinyint(1) NOT NULL DEFAULT '1',
*  `remmax` decimal(4,3) NOT NULL DEFAULT '0.000',
*  `derrev` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `revpond` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `ht` decimal(10,3) NOT NULL DEFAULT '0.000',
*  `ttcmax1` int(10) DEFAULT NULL,
*  `ttcmax2` int(10) DEFAULT NULL,
*  `colis` varchar(13) DEFAULT NULL,
*  `poids` decimal(5,3) DEFAULT NULL,
*  `vol1` decimal(7,5) DEFAULT NULL,
*  `vol2` decimal(7,5) DEFAULT NULL,
*  `scenar` tinyint(1) NOT NULL DEFAULT '1',
