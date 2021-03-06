﻿CREATE TABLE `customer` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nom` varchar(40) DEFAULT NULL,
  `typeclient` enum('type1','Administration','type3','type4',) NOT NULL DEFAULT 'type1',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `RC` varchar(10) DEFAULT NULL,
  `bp` varchar(30) DEFAULT NULL,
  `rem` decimal(10,3) NOT NULL DEFAULT '0.000',
  `credit` tinyint(1) NOT NULL DEFAULT '0',
  `plafond` int(10) NOT NULL DEFAULT '0',
  `echeance` enum('Fin du mois','1 mois','2 mois','3 mois') NOT NULL DEFAULT 'Fin du mois',
  `dirigeant` varchar(40) DEFAULT NULL,
  `bureau` varchar(40) DEFAULT NULL,
  `compta` varchar(40) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `contact` varchar(40) DEFAULT NULL,
  `solde` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;

CREATE TABLE `devis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datedev` date NOT NULL,
  `utilisateur` varchar(13) NOT NULL,
  `numclient` smallint(5) unsigned NOT NULL,
  `nom` varchar(40) DEFAULT NULL,
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `bc` varchar(30) DEFAULT NULL,
  `base1` int(10) NOT NULL,
  `base2` int(10) NOT NULL,
  `base3` int(10) NOT NULL,
  `tva1` int(10) NOT NULL,
  `tva2` int(10) NOT NULL,
  `tva3` int(10) NOT NULL,
  `ttc` int(10) NOT NULL,
  `ht` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `numclient` (`numclient`),
  KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `devisdet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `devis` int(10) unsigned NOT NULL,
  `refint` mediumint(7) NOT NULL,
  `refmag` varchar(13) DEFAULT NULL,
  `design` varchar(40) DEFAULT NULL,
  `qte` decimal(10,3) DEFAULT NULL,
  `txtva` decimal(10,3) DEFAULT NULL,
  `remise` decimal(10,3) DEFAULT NULL,
  `htpub` decimal(10,3) DEFAULT NULL,
  `htnet` decimal(10,3) DEFAULT NULL,
  `ttcmax1` int(10) DEFAULT NULL,
  `ttcmax2` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `devis` (`devis`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `entree` (
  `entree` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `dateentr` date NOT NULL,
  `fourn` smallint(5) DEFAULT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `fact` varchar(30) DEFAULT NULL,
  `totrev` int(10) DEFAULT NULL,
  PRIMARY KEY (`entree`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `entreedet` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entree` smallint(5) unsigned NOT NULL,
  `dateentr` date NOT NULL,
  `refint` mediumint(7) NOT NULL,
  `design` varchar(30) DEFAULT NULL,
  `qte` decimal(10,3) NOT NULL,
  `rev` decimal(10,3) NOT NULL,
  `ht` decimal(10,3) NOT NULL,
  `ancqte` decimal(10,3) NOT NULL,
  `ancrevpond` decimal(10,3) NOT NULL,
  `ancht` decimal(10,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entree` (`entree`),
  KEY `refint` (`refint`) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `fact` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `datefact` datetime NOT NULL,
  `utilisateur` varchar(13) NOT NULL,
  `numclient` smallint(5) unsigned NOT NULL,
  `typeclient` enum('type1','Administration','type3','type4',) NOT NULL DEFAULT 'type1',
  `nom` varchar(40) NOT NULL,
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `bc` varchar(30) DEFAULT NULL,
  `ttc` int(10) NOT NULL,
  `tva1` int(10) NOT NULL DEFAULT '0',
  `tva2` int(10) NOT NULL DEFAULT '0',
  `tva3` int(10) NOT NULL DEFAULT '0',
  `pay1` int(10) NOT NULL DEFAULT '0',
  `pay2` int(10) NOT NULL DEFAULT '0',
  `pay3` int(10) NOT NULL DEFAULT '0',
  `pay4` int(10) NOT NULL DEFAULT '0',
  `mode1` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode2` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode3` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode4` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `rendu` int(10) NOT NULL DEFAULT '0',
  `typefact` enum('COMPTANT','CREDIT') NOT NULL,
  `echeance` date DEFAULT NULL,
  `lettre` varchar(30) NOT NULL DEFAULT '',
  `archivee` tinyint(1) DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `chq1` int(10) DEFAULT NULL,
  `chq2` int(10) DEFAULT NULL,
  `chq3` int(10) DEFAULT NULL,
  `chq4` int(10) DEFAULT NULL,
  `bl` varchar(30) DEFAULT NULL,
  `base1` int(10) NOT NULL DEFAULT '0',
  `base2` int(10) NOT NULL DEFAULT '0',
  `base3` int(10) NOT NULL DEFAULT '0',
  `ht` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `numclient` (`numclient`),
  KEY `nom` (`nom`),
  KEY `ttc` (`ttc`),
  KEY `datefact` (`datefact`),
  KEY `solde` (`numclient`,`typefact`,`lettre`(1),`ttc`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=latin1;

CREATE TABLE `factdet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `facture` bigint(20) unsigned NOT NULL,
  `datefact` date DEFAULT NULL,
  `numclient` smallint(5) unsigned DEFAULT NULL,
  `nom` varchar(40) DEFAULT NULL,
  `refint` mediumint(7) DEFAULT NULL,
  `refmag` varchar(13) DEFAULT NULL,
  `design` varchar(40) DEFAULT NULL,
  `qte` decimal(10,3) DEFAULT NULL,
  `txtva` decimal(10,3) DEFAULT NULL,
  `remise` decimal(10,3) DEFAULT NULL,
  `htpub` decimal(10,3) DEFAULT NULL,
  `htnet` decimal(10,3) DEFAULT NULL,
  `ttcmax1` int(10) DEFAULT NULL,
  `ttcmax2` int(10) DEFAULT NULL,
  `revpond` decimal(10,3) DEFAULT NULL,
  `tva` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `facture` (`facture`),
  KEY `datefact` (`datefact`),
  KEY `refint` (`refint`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `fourn` (
  `id` smallint(5) NOT NULL,
  `nom` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `regl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dateregl` date NOT NULL,
  `numclient` smallint(5) unsigned NOT NULL,
  `paymode` enum('ESP','CHQ','CB','VIR','MDT') NOT NULL,
  `montant` int(10) NOT NULL,
  `numfact` bigint(20) unsigned NOT NULL,
  `lettre` varchar(30) NOT NULL DEFAULT '',
  `utilisateur` varchar(13) NOT NULL,
  `nom` varchar(30) NOT NULL,
  `rendu` int(10) NOT NULL DEFAULT '0',
  `chq` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `solde` (`numclient`,`montant`,`rendu`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `stk` (
  `refint` mediumint(7) NOT NULL AUTO_INCREMENT,
  `refmag` varchar(13) NOT NULL,
  `codebar` varchar(13) DEFAULT NULL,
  `reffourn` varchar(13) DEFAULT NULL,
  `ref5` varchar(13) DEFAULT NULL,
  `ref6` varchar(13) DEFAULT NULL,
  `cat` enum('01.cat1','99.cat99') NOT NULL DEFAULT '01.cat1',
  `design` varchar(40) NOT NULL,
  `product` varchar(40) DEFAULT NULL,
  `inv2015` decimal(10,3) NOT NULL DEFAULT '0.000',
  `fourn` smallint(5) DEFAULT NULL,
  `annu` decimal(10,1) NOT NULL DEFAULT '0.0',
  `seuil` decimal(10,1) NOT NULL DEFAULT '0.0',
  `qte` decimal(10,3) NOT NULL DEFAULT '0.000',
  `theo` decimal(10,3) DEFAULT NULL,
  `ecart` decimal(10,3) DEFAULT NULL,
  `invchk` tinyint(1) DEFAULT NULL,
  `regime` enum('LIBRE','PGC','PPN','RS') DEFAULT 'LIBRE',
  `tva` tinyint(1) NOT NULL DEFAULT '1',
  `remmax` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `derrev` decimal(10,3) NOT NULL DEFAULT '0.000',
  `revpond` decimal(10,3) NOT NULL DEFAULT '0.000',
  `ht` decimal(10,3) NOT NULL DEFAULT '0.000',
  `ttcmax1` int(10) DEFAULT NULL,
  `ttcmax2` int(10) DEFAULT NULL,
  `colis` varchar(13) DEFAULT NULL,
  `poids` decimal(5,3) DEFAULT NULL,
  `vol1` decimal(7,5) DEFAULT NULL,
  `vol2` decimal(7,5) DEFAULT NULL,
  `scenar` tinyint(1) NOT NULL DEFAULT '1',
  `promo` decimal(5,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`refint`),
  UNIQUE KEY `refmag` (`refmag`),
  UNIQUE KEY `codebar` (`codebar`),
  UNIQUE KEY `reffourn` (`reffourn`),
  UNIQUE KEY `ref5` (`ref5`),
  UNIQUE KEY `ref6` (`ref6`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `utilisateur` (
  `id` varchar(5) NOT NULL,
  `nom` varchar(13) NOT NULL,
  `factcomptant` tinyint(1) NOT NULL,
  `factcredit` tinyint(1) NOT NULL,
  `devis` tinyint(1) NOT NULL,
  `stat` tinyint(1) NOT NULL,
  `regl` tinyint(1) NOT NULL,
  `clientmod` tinyint(1) NOT NULL,
  `entree` tinyint(1) NOT NULL,
  `printfact` tinyint(1) NOT NULL,
  `fdj` tinyint(1) NOT NULL,
  `counter` smallint(5) DEFAULT NULL,
  `freecell` smallint(5) DEFAULT NULL,
  `vteesp` int(10) DEFAULT NULL,
  `vtechq` int(10) DEFAULT NULL,
  `vtecb` int(10) DEFAULT NULL,
  `vtevir` int(10) DEFAULT NULL,
  `print` int(10) DEFAULT NULL,
  `ft` tinyint(1) DEFAULT NULL,
  `qty` tinyint(1) DEFAULT NULL,
  `chkinv` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

