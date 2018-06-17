USE production;


DROP PROCEDURE IF EXISTS chkstk;
DELIMITER //
CREATE PROCEDURE chkstk()
   BEGIN
   SET SQL_SAFE_UPDATES=0;
   UPDATE production.stk SET theo=0, ecart=0;
   UPDATE production.stk INNER JOIN (SELECT refint, IFNULL(SUM(qte),0) AS total FROM production.entreedet GROUP BY refint) AS t USING (refint) SET theo=t.total;
   UPDATE production.stk INNER JOIN (SELECT refint, IFNULL(SUM(qte),0) AS total FROM production.factdet GROUP BY refint) AS t USING (refint) SET ecart=t.total;
   UPDATE production.stk SET theo=theo-ecart, ecart=qte-theo;
   SET SQL_SAFE_UPDATES=1;
   END //
DELIMITER ;


DROP PROCEDURE IF EXISTS balances;
DELIMITER //
CREATE PROCEDURE balances()
   BEGIN
   SET SQL_SAFE_UPDATES=0;
   UPDATE production.customer SET solde=0, buy=0, pay=0;
   UPDATE production.customer INNER JOIN (SELECT numclient, IFNULL(SUM(ttc),0) AS total FROM production.fact WHERE typefact='CREDIT' GROUP BY numclient) AS t ON production.customer.id=t.numclient SET buy=t.total;
   UPDATE production.customer INNER JOIN (SELECT numclient, IFNULL(SUM(montant-rendu),0) AS total FROM production.regl GROUP BY numclient) AS t ON production.customer.id=t.numclient SET pay=t.total;
   UPDATE production.customer SET solde=buy-pay;
   SET SQL_SAFE_UPDATES=1;
   END //
DELIMITER ;


DROP PROCEDURE IF EXISTS balance;
DELIMITER //
CREATE PROCEDURE balance(IN cust INT)
   BEGIN
DECLARE totcredit,totpay INT DEFAULT 0;
SELECT IFNULL(SUM(ttc),0) INTO totcredit FROM production.fact WHERE typefact='CREDIT' AND numclient=cust;
SELECT IFNULL(SUM(montant-rendu),0) INTO totpay FROM production.regl WHERE numclient=cust;
UPDATE production.customer SET solde=totcredit-totpay, buy=totcredit, pay=totpay WHERE id=cust;
   END //
DELIMITER ;


DROP PROCEDURE IF EXISTS fdj2;
DELIMITER //
CREATE PROCEDURE fdj2(IN jour DATE)
BEGIN
DECLARE done,printline INT DEFAULT 0;
DECLARE util VARCHAR(10);
DECLARE cur4 CURSOR FOR SELECT id,print FROM production.utilisateur ORDER BY print;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
SET sql_safe_updates=0, @i=0;
UPDATE production.utilisateur SET counter=0,freecell=0,vteesp=0,vtechq=0,vtecb=0,vtevir=0,print=0;
UPDATE production.utilisateur INNER JOIN (SELECT utilisateur AS id FROM production.regl WHERE dateregl=jour GROUP BY utilisateur UNION SELECT utilisateur FROM production.fact WHERE DATE(datefact)=jour GROUP BY utilisateur) AS t USING(id) SET counter=1, print = @i:=@i+1;
DROP TABLE IF EXISTS tpay;
CREATE TEMPORARY TABLE tpay (`utilisateur` varchar(13),`paymod` enum('ESP','CHQ','CB','VIR','MDT',''),`payvalue` int);
INSERT INTO tpay SELECT utilisateur,mode1,pay1 FROM production.fact WHERE DATE(datefact)=jour;
INSERT INTO tpay SELECT utilisateur,'ESP',-rendu FROM production.fact WHERE DATE(datefact)=jour;
INSERT INTO tpay SELECT utilisateur,mode2,pay2 FROM production.fact WHERE DATE(datefact)=jour;
INSERT INTO tpay SELECT utilisateur,mode3,pay3 FROM production.fact WHERE DATE(datefact)=jour;
INSERT INTO tpay SELECT utilisateur,mode4,pay4 FROM production.fact WHERE DATE(datefact)=jour;
UPDATE production.utilisateur INNER JOIN (SELECT utilisateur AS id, IFNULL(SUM(payvalue),0) AS total FROM tpay WHERE `paymod`='ESP' GROUP BY utilisateur) AS t USING(id) SET vteesp=t.total;
UPDATE production.utilisateur INNER JOIN (SELECT utilisateur AS id, IFNULL(SUM(payvalue),0) AS total FROM tpay WHERE `paymod`='CHQ' GROUP BY utilisateur) AS t USING(id) SET vtechq=t.total;
UPDATE production.utilisateur INNER JOIN (SELECT utilisateur AS id, IFNULL(SUM(payvalue),0) AS total FROM tpay WHERE `paymod`='CB' GROUP BY utilisateur) AS t USING(id) SET vtecb=t.total;
UPDATE production.utilisateur INNER JOIN (SELECT utilisateur AS id, IFNULL(SUM(payvalue),0) AS total FROM tpay WHERE `paymod`='VIR' GROUP BY utilisateur) AS t USING(id) SET vtevir=t.total;
DROP TABLE tpay;
OPEN cur4;
loop4: LOOP
	FETCH cur4 INTO util,printline;
	IF done THEN LEAVE loop4; END IF;
	CASE printline
	WHEN 1 THEN UPDATE production.utilisateur SET freecell=14 WHERE id=util;
	WHEN 2 THEN UPDATE production.utilisateur SET freecell=51 WHERE id=util;
	WHEN 3 THEN UPDATE production.utilisateur SET freecell=88 WHERE id=util;
	WHEN 4 THEN UPDATE production.utilisateur SET freecell=125 WHERE id=util;
	ELSE BEGIN END;
	END CASE;
END LOOP loop4;
CLOSE cur4;
SET sql_safe_updates = 1;
END //
DELIMITER ;



