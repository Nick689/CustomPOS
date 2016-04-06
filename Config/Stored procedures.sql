DELIMITER $$
DROP PROCEDURE IF EXISTS mybasechk$$
CREATE PROCEDURE mybasechk()
BEGIN
DECLARE done, refid  INT DEFAULT 0;
DECLARE entree,vente,quant DECIMAL(10,3);
DECLARE cur1 CURSOR FOR SELECT refint,qte FROM mybase.entreedet;
DECLARE cur2 CURSOR FOR SELECT refint,qte FROM mybase.factdet;
DECLARE cur3 CURSOR FOR SELECT refint,qte,invtheo,invreel FROM mybase.stk;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
SET SQL_SAFE_UPDATES = 0;
UPDATE mybase.stk SET `invtheo` = 0,`invreel` = 0;
SET SQL_SAFE_UPDATES = 1;
OPEN cur1;
loop1: LOOP
	FETCH cur1 INTO refid, entree;
	IF done THEN LEAVE loop1; END IF;
	UPDATE mybase.stk SET `invtheo`=`invtheo`+entree WHERE `refint`=refid;
END LOOP loop1;
CLOSE cur1;
SET done=0;
OPEN cur2;
loop2: LOOP
	FETCH cur2 INTO refid, vente;
	IF done THEN LEAVE loop2; END IF;
	UPDATE mybase.stk SET `invreel`=`invreel`+vente WHERE `refint`=refid;
END LOOP loop2;
CLOSE cur2;
SET done=0;
OPEN cur3;
loop3: LOOP
	FETCH cur3 INTO refid,quant,entree,vente;
	IF done THEN LEAVE loop3; END IF;
	UPDATE mybase.stk SET `invtheo`=entree-vente, `invreel`=quant-entree+vente WHERE `refint`=refid;
END LOOP loop3;
CLOSE cur3;
END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS mybasesoldes$$
CREATE PROCEDURE mybasesoldes()
BEGIN
DECLARE done,cli,tot,rend INT DEFAULT 0;
DECLARE cur1 CURSOR FOR SELECT numclient,ttc FROM mybase.fact WHERE typefact='Crédit';
DECLARE cur2 CURSOR FOR SELECT numclient,montant,rendu FROM mybase.regl WHERE montant>0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
SET SQL_SAFE_UPDATES = 0;
UPDATE mybase.customer SET `solde` = 0;
SET SQL_SAFE_UPDATES = 1;
OPEN cur1;
loop1: LOOP
	FETCH cur1 INTO cli,tot;
	IF done THEN LEAVE loop1; END IF;
	UPDATE mybase.customer SET `solde`=`solde`+tot WHERE `id`=cli;
END LOOP loop1;
CLOSE cur1;
SET done = 0;
OPEN cur2;
loop2: LOOP
	FETCH cur2 INTO cli,tot,rend;
	IF done THEN LEAVE loop2; END IF;
	UPDATE mybase.customer SET `solde`=`solde`+rend-tot WHERE `id`=cli;
END LOOP loop2;
CLOSE cur2;
END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS mybasefdj$$
CREATE PROCEDURE mybasefdj(IN jour DATE)
BEGIN
DECLARE done,p1,p2,p3,p4,esp,chq,cb,vir,rend,tax INT DEFAULT 0;
DECLARE qt,ht,ht0,ht1,ht2 DECIMAL(10,3) DEFAULT 0.000;
DECLARE m1,m2,m3,m4,util VARCHAR(10) DEFAULT 0;
DECLARE cur1 CURSOR FOR SELECT utilisateur FROM mybase.regl WHERE `dateregl`=jour;
DECLARE cur2 CURSOR FOR SELECT utilisateur,pay1,pay2,pay3,pay4,mode1,mode2,mode3,mode4,rendu FROM mybase.fact WHERE DATE(`datefact`)=jour;
DECLARE cur3 CURSOR FOR SELECT counter,id FROM mybase.utilisateur ORDER BY id;
DECLARE cur4 CURSOR FOR SELECT id,print FROM mybase.utilisateur ORDER BY print;
DECLARE cur5 CURSOR FOR SELECT tva,htnet,qte FROM mybase.factdet WHERE `datefact`=jour;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
SET SQL_SAFE_UPDATES = 0;
UPDATE mybase.utilisateur SET `counter`=0,`vteesp`=0,`vtechq`=0,`vtecb`=0,`vtevir`=0,`print`=0;
SET SQL_SAFE_UPDATES = 1;
OPEN cur1;
loop1: LOOP
	FETCH cur1 INTO util;
	IF done THEN LEAVE loop1; END IF;
	UPDATE mybase.utilisateur SET `counter`=`counter`+1 WHERE `id`=util;
END LOOP loop1;
CLOSE cur1;
SET done=0;
OPEN cur2;
loop2: LOOP
	FETCH cur2 INTO util,p1,p2,p3,p4,m1,m2,m3,m4,rend;
	IF done THEN LEAVE loop2; END IF;
	SET esp=0,chq=0,cb=0,vir=0;
	CASE m1
	WHEN 'ESP' THEN SET esp=p1;
	WHEN 'CHQ' THEN SET chq=p1;
	WHEN 'CB' THEN SET cb=p1;
	WHEN 'VIR' THEN SET vir=p1;
	WHEN 'MDT' THEN SET vir=p1;
	ELSE BEGIN END;
	END CASE;
	CASE m2
	WHEN 'CHQ' THEN SET chq=chq+p2;
	WHEN 'CB' THEN SET cb=cb+p2;
	WHEN 'VIR' THEN SET vir=vir+p2;
	WHEN 'MDT' THEN SET vir=vir+p2;
	ELSE BEGIN END;
	END CASE;
	CASE m3
	WHEN 'CB' THEN SET cb=cb+p3;
	WHEN 'CHQ' THEN SET chq=chq+p3;
	WHEN 'VIR' THEN SET vir=vir+p3;
	WHEN 'MDT' THEN SET vir=vir+p3;
	ELSE BEGIN END;
	END CASE;
	CASE m4
	WHEN 'VIR' THEN SET vir=vir+p4;
	WHEN 'CHQ' THEN SET chq=chq+p4;
	WHEN 'CB' THEN SET cb=cb+p4;
	WHEN 'MDT' THEN SET vir=vir+p4;
	ELSE BEGIN END;
	END CASE;
	SET esp=esp-rend;
	UPDATE mybase.utilisateur SET `counter`=`counter`+1,`vteesp`=`vteesp`+esp,`vtechq`=`vtechq`+chq,`vtecb`=`vtecb`+cb,`vtevir`=`vtevir`+vir WHERE `id`=util;
END LOOP loop2;
CLOSE cur2;
SET done=0;
SET p1=0;
OPEN cur3;
loop3: LOOP
	FETCH cur3 INTO p2,util;
	IF done THEN LEAVE loop3; END IF;
	IF p2>0 THEN SET p1=p1+1; UPDATE mybase.utilisateur SET `print`=p1 WHERE `id`=util; END IF;
END LOOP loop3;
CLOSE cur3;
SET done=0;
OPEN cur4;
loop4: LOOP
	FETCH cur4 INTO util,p3;
	IF done THEN LEAVE loop4; END IF;
	CASE p3
	WHEN 1 THEN UPDATE mybase.utilisateur SET `freecell`=14 WHERE `id`=util;
	WHEN 2 THEN UPDATE mybase.utilisateur SET `freecell`=51 WHERE `id`=util;
	WHEN 3 THEN UPDATE mybase.utilisateur SET `freecell`=88 WHERE `id`=util;
	WHEN 4 THEN UPDATE mybase.utilisateur SET `freecell`=125 WHERE `id`=util;
	ELSE BEGIN END;
	END CASE;
END LOOP loop4;
CLOSE cur4;
SET done=0;
OPEN cur5;
loop5: LOOP
	FETCH cur5 INTO tax,ht,qt;
	IF done THEN LEAVE loop5; END IF;
	CASE tax
	WHEN 0 THEN SET ht0=ht0+qt*ht;
	WHEN 1 THEN SET ht1=ht1+qt*ht;
	WHEN 2 THEN SET ht2=ht2+qt*ht;
	ELSE BEGIN END;
	END CASE;
END LOOP loop5;
CLOSE cur5;
UPDATE mybase.output SET `dec1`=ht1,`dec2`=ht2,`dec3`=ht0 WHERE `id`=1;
END $$
DELIMITER ;
