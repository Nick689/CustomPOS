CREATE DATABASE  IF NOT EXISTS `mybase` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mybase`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) DEFAULT NULL,
  `typeclient` enum('Particulier','Administration','Revendeur','Gestion','Jardinier') NOT NULL DEFAULT 'Particulier',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `tahiti` varchar(10) DEFAULT NULL,
  `bp` varchar(30) DEFAULT NULL,
  `rem` decimal(10,3) NOT NULL DEFAULT '0.000',
  `credit` tinyint(1) NOT NULL DEFAULT '0',
  `plafond` int(10) NOT NULL DEFAULT '0',
  `echeance` enum('Fin du mois','1 mois','2 mois','3 mois') NOT NULL DEFAULT 'Fin du mois',
  `contact1` varchar(30) DEFAULT NULL,
  `contact2` varchar(30) DEFAULT NULL,
  `contact3` varchar(30) DEFAULT NULL,
  `contact4` varchar(30) DEFAULT NULL,
  `contact5` varchar(30) DEFAULT NULL,
  `solde` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=1079 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `customer` VALUES (100,'Client divers','Particulier',1,'','',NULL,NULL,0.000,0,0,'Fin du mois',NULL,NULL,NULL,NULL,'',0),(400,'DIVERS JARDINIER-AGRI ???','Jardinier',1,'','',NULL,NULL,0.100,0,0,'Fin du mois',NULL,NULL,NULL,NULL,'',0),(500,'DIVERS COLLECTIVITÉ ???','Administration',1,NULL,NULL,NULL,NULL,0.000,1,500000,'Fin du mois',NULL,NULL,NULL,NULL,NULL,0);
DROP TABLE IF EXISTS `devis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devis` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datedev` date NOT NULL,
  `utilisateur` varchar(13) NOT NULL,
  `numclient` smallint(5) unsigned NOT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `bc` varchar(13) DEFAULT NULL,
  `base1` int(10) DEFAULT NULL,
  `base2` int(10) DEFAULT NULL,
  `base3` int(10) DEFAULT NULL,
  `tva1` int(10) DEFAULT NULL,
  `tva2` int(10) DEFAULT NULL,
  `tva3` int(10) DEFAULT NULL,
  `ttc` int(10) NOT NULL,
  `facture` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=894 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `devisdet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devisdet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `devis` int(10) unsigned NOT NULL,
  `refint` mediumint(7) DEFAULT NULL,
  `refmag` varchar(13) DEFAULT NULL,
  `design` varchar(40) DEFAULT NULL,
  `qte` decimal(10,3) NOT NULL DEFAULT '1.000',
  `txtva` decimal(10,3) DEFAULT NULL,
  `remise` decimal(10,3) DEFAULT NULL,
  `htpub` decimal(10,3) DEFAULT NULL,
  `htnet` decimal(10,3) DEFAULT NULL,
  `ttcmax1` int(10) DEFAULT NULL,
  `ttcmax2` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `devis` (`devis`)
) ENGINE=InnoDB AUTO_INCREMENT=6586 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `entree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entree` (
  `entree` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `dateentr` date NOT NULL,
  `fourn` smallint(5) DEFAULT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `fact` varchar(30) DEFAULT NULL,
  `totrev` int(10) DEFAULT NULL,
  PRIMARY KEY (`entree`)
) ENGINE=InnoDB AUTO_INCREMENT=380 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `entreedet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=1889 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `fact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fact` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `datefact` datetime NOT NULL,
  `utilisateur` varchar(13) NOT NULL,
  `numclient` smallint(5) unsigned NOT NULL,
  `typeclient` enum('Particulier','Administration','Revendeur','Gestion','Jardinier') NOT NULL DEFAULT 'Particulier',
  `nom` varchar(30) DEFAULT NULL,
  `lieu` varchar(30) DEFAULT NULL,
  `transport` varchar(30) DEFAULT NULL,
  `bc` varchar(13) DEFAULT NULL,
  `ttc` int(10) NOT NULL,
  `tva1` int(10) DEFAULT NULL,
  `tva2` int(10) DEFAULT NULL,
  `tva3` int(10) DEFAULT NULL,
  `pay1` int(10) DEFAULT NULL,
  `pay2` int(10) DEFAULT NULL,
  `pay3` int(10) DEFAULT NULL,
  `pay4` int(10) DEFAULT NULL,
  `mode1` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode2` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode3` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `mode4` enum('ESP','CHQ','CB','VIR','MDT') DEFAULT NULL,
  `rendu` smallint(5) DEFAULT NULL,
  `typefact` enum('COMPTANT','CRÉDIT') NOT NULL,
  `echeance` date DEFAULT NULL,
  `lettre` varchar(30) NOT NULL DEFAULT '',
  `archivee` tinyint(1) DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `chq1` int(10) DEFAULT NULL,
  `chq2` int(10) DEFAULT NULL,
  `chq3` int(10) DEFAULT NULL,
  `chq4` int(10) DEFAULT NULL,
  `bl` varchar(13) DEFAULT NULL,
  `base1` int(10) DEFAULT NULL,
  `base2` int(10) DEFAULT NULL,
  `base3` int(10) DEFAULT NULL,
  `ht` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numclient` (`numclient`)
) ENGINE=InnoDB AUTO_INCREMENT=17618 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `factdet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factdet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `facture` bigint(20) unsigned NOT NULL,
  `datefact` date DEFAULT NULL,
  `numclient` smallint(5) unsigned DEFAULT NULL,
  `nom` varchar(30) DEFAULT NULL,
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
  KEY `refint` (`refint`)
) ENGINE=InnoDB AUTO_INCREMENT=18701 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `fourn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fourn` (
  `id` smallint(5) NOT NULL,
  `nom` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `fourn` VALUES (101,'FOURN1'),(102,'FOURN2'),(103,'FOURN3');
DROP TABLE IF EXISTS `output`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `output` (
  `id` tinyint(1) unsigned NOT NULL,
  `entier1` int(10) DEFAULT NULL,
  `entier2` int(10) DEFAULT NULL,
  `entier3` int(10) DEFAULT NULL,
  `dec1` decimal(10,3) DEFAULT NULL,
  `dec2` decimal(10,3) DEFAULT NULL,
  `dec3` decimal(10,3) DEFAULT NULL,
  `letter` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `output` VALUES (1,NULL,NULL,NULL,223723.278,4424.779,5926.000,NULL);
DROP TABLE IF EXISTS `regl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `numclient` (`numclient`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `stk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stk` (
  `refint` mediumint(7) NOT NULL AUTO_INCREMENT,
  `refmag` varchar(13) NOT NULL,
  `codebar` varchar(13) DEFAULT NULL,
  `reffourn` varchar(13) DEFAULT NULL,
  `ref5` varchar(13) DEFAULT NULL,
  `ref6` varchar(13) DEFAULT NULL,
  `cat` enum('10.Mobilier','11.Range-Embal-Conserv','12.Cuisine','13.Nettoyage-Hygiène','14.Electromenager','15.High-Tech','16.Fourniture.Maison','17.Animalerie','18.R','20.Matériaux-Construction','21.Peinture-Enduit','22.Electricité-Eclairage','23.Outil-Brico-Lev-Protec','24.Quincail-Plomberie','25.R','26.R','30.Lubrifiant-Prod.Auto','31.Batterie','32.Chargeur-Convertisseur','33.R','40.Mer','41.R','50.Loisirs','51.Divers','60.Service.Int','61.Service.Ext','70.Spécial','00.NA','80.Jardinage','90.Conso.Acc.Machine','91.Machine-Entière','92.Pcs.Kawasaki','93.Pcs.Mitsubishi','94.Pcs.Shindaiwa','95.Pcs.Echo','96.Pcs.Kurin','97.R','98.Pcs.Autre') NOT NULL DEFAULT '00.NA',
  `design` varchar(40) NOT NULL,
  `product` varchar(40) DEFAULT NULL,
  `inv2015` decimal(10,3) NOT NULL DEFAULT '0.000',
  `fourn` smallint(5) DEFAULT NULL,
  `annu` decimal(10,1) NOT NULL DEFAULT '0.0',
  `seuil` decimal(10,1) NOT NULL DEFAULT '0.0',
  `qte` decimal(10,3) NOT NULL DEFAULT '0.000',
  `invtheo` decimal(10,3) NOT NULL DEFAULT '0.000',
  `invreel` decimal(10,3) NOT NULL DEFAULT '0.000',
  `invchk` tinyint(1) DEFAULT NULL,
  `regime` enum('LIBRE','PGC','PPN','RS') DEFAULT 'LIBRE',
  `tva` tinyint(1) NOT NULL DEFAULT '1',
  `remmax` decimal(4,3) NOT NULL DEFAULT '0.000',
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
  PRIMARY KEY (`refint`),
  UNIQUE KEY `refmag` (`refmag`),
  UNIQUE KEY `codebar` (`codebar`),
  UNIQUE KEY `reffourn` (`reffourn`),
  UNIQUE KEY `ref5` (`ref5`),
  UNIQUE KEY `ref6` (`ref6`)
) ENGINE=InnoDB AUTO_INCREMENT=1071 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `stk` VALUES (1,'FT',NULL,NULL,NULL,NULL,'60.Service.Int','FRET',NULL,0.000,101,0.0,0.0,0.0,0.0,0.0,NULL,'LIBRE',2,0.000,0.000,0.000,88.496,NULL,NULL,NULL,NULL,NULL,NULL,-1),(234,'ASSP','80576050098','3010AF06A',NULL,NULL,'12.Cuisine','ASSIETTE 23CM PLATE',NULL,29.000,102,0.0,0.0,29.000,29.000,0.000,NULL,'LIBRE',1,0.000,100.000,100.000,200.000,NULL,NULL,NULL,0.472,NULL,NULL,1),(23,'ASSC','3550190401615','3011AF06A',NULL,NULL,'12.Cuisine','ASSIETTE 23CM CREUSE',NULL,100.000,102,0.0,0.0,100.000,100.000,0.000,NULL,'LIBRE',1,0.000,100.000,100.000,200.000,NULL,NULL,NULL,NULL,NULL,NULL,1);
DROP TABLE IF EXISTS `utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `utilisateur` VALUES ('root','root',1,1,1,1,1,1,1,1,1,0,88,0,0,0,0,0);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

