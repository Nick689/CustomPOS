POS
![POS](https://github.com/Nick689/CustomPOS/blob/master/Preview/Facturation.png)

Invoice view
![Invoice view](https://github.com/Nick689/CustomPOS/blob/master/Preview/Affichage%20facture.png)

Item list
![Item list](https://github.com/Nick689/CustomPOS/blob/master/Preview/Liste%20articles.png)

Invoice list
![Invoice list](https://github.com/Nick689/CustomPOS/blob/master/Preview/Liste%20factures.png)

Invoice PRINT/PDF
![PDF](https://github.com/Nick689/CustomPOS/blob/master/Preview/17618.png)

Customer balance
![balance](https://github.com/Nick689/CustomPOS/blob/master/Preview/Balance.png)


ProductPage
1  `refint` mediumint(7) NOT NULL AUTO_INCREMENT,
2  `refmag` varchar(13) NOT NULL,
3  `codebar` varchar(13) DEFAULT NULL,
4  `reffourn` varchar(13) DEFAULT NULL,
5  `ref5` varchar(13) DEFAULT NULL,
6  `ref6` varchar(13) DEFAULT NULL,
7  `cat` enum('00.NA','...') NOT NULL DEFAULT '00.NA',
8  `design` varchar(40) NOT NULL,
9  `product` varchar(40) DEFAULT NULL,
10  `inv2015` decimal(10,3) NOT NULL DEFAULT '0.000',
11  `fourn` smallint(5) DEFAULT NULL,
12  `annu` decimal(10,1) NOT NULL DEFAULT '0.0',
13  `seuil` decimal(10,1) NOT NULL DEFAULT '0.0',
14  `qte` decimal(10,3) NOT NULL DEFAULT '0.000',
15  `invtheo` decimal(10,3) NOT NULL DEFAULT '0.000',
16  `invreel` decimal(10,3) NOT NULL DEFAULT '0.000',
17  `invchk` tinyint(1) DEFAULT NULL,
18  `regime` enum('LIBRE','PGC','PPN','RS') DEFAULT 'LIBRE',
19  `tva` tinyint(1) NOT NULL DEFAULT '1',
20  `remmax` decimal(4,3) NOT NULL DEFAULT '0.000',
21  `derrev` decimal(10,3) NOT NULL DEFAULT '0.000',
22  `revpond` decimal(10,3) NOT NULL DEFAULT '0.000',
23  `ht` decimal(10,3) NOT NULL DEFAULT '0.000',
24  `ttcmax1` int(10) DEFAULT NULL,
25  `ttcmax2` int(10) DEFAULT NULL,
26  `colis` varchar(13) DEFAULT NULL,
27  `poids` decimal(5,3) DEFAULT NULL,
28  `vol1` decimal(7,5) DEFAULT NULL,
29  `vol2` decimal(7,5) DEFAULT NULL,
30  `scenar` tinyint(1) NOT NULL DEFAULT '1',
