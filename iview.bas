option explicit

global IVListener as object
global IVRange as object

sub icleaner
	dim feuille as object
	dim form as object
	dim oRanges
	feuille=ThisComponent.Sheets.getByName("Aff.Facture")
	feuille.getCellRangeByPosition(3,1,3,12).clearContents(flag)
	feuille.getCellRangeByPosition(10,6,19,11).clearContents(flag)
	feuille.getCellRangeByPosition(0,14,35,114).clearContents(flag)
	feuille.getCellByPosition(10,3).value=0
	feuille.getCellByPosition(17,4).value=0
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,0))
end sub

sub iRefresh
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopIVListener
	ThisComponent.Sheets.getByName("Aff.Facture").unprotect(mypass)
	iDisplay
	ThisComponent.Sheets.getByName("Aff.Facture").protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	startIVListener
end sub

sub iDisplay
	on error goto ErrorHandler
	dim feuille as object
	dim result1 as object
	dim result2 as object
	dim statement1 as object
	dim statement2 as object
	dim requete as string
	dim numfacture as long
	dim ligne as integer
	dim convert as double
	dim qte as double
	feuille=ThisComponent.Sheets.getByName("Aff.Facture")
	numfacture=feuille.getCellByPosition(3,0).value
	select case factType(numfacture)
	case "facture"
		icleaner
		statement1=connection.CreateStatement
		statement2=connection.CreateStatement
		result1=statement1.executequery("SELECT * FROM mybase.fact WHERE `id`="+cstr(numfacture))
		result1.next
		if result1.getboolean(26) then 'facture archivée
			msgbox("Facture archivée",64,"Affichage facture")
		else
			feuille.getCellByPosition(3,1).string=result1.getstring(2)'	date
			feuille.getCellByPosition(3,2).value=result1.getstring(4)'	n°client
			feuille.getCellByPosition(3,3).string=result1.getstring(6)'	nom
			feuille.getCellByPosition(3,4).string=result1.getstring(23)'	type
			feuille.getCellByPosition(3,5).string=result1.getstring(24)'	echeance
			feuille.getCellByPosition(3,6).string=result1.getstring(25)'	lettre
			feuille.getCellByPosition(3,7).string=username(result1.getstring(3))'caissier
			feuille.getCellByPosition(3,8).string=result1.getstring(7)'	lieu
			feuille.getCellByPosition(3,9).string=result1.getstring(8)'	bateau
			feuille.getCellByPosition(3,10).string=result1.getstring(32)'	bl
			feuille.getCellByPosition(3,11).string=result1.getstring(27)'	contact
			feuille.getCellByPosition(3,12).string=result1.getstring(9)'	bc
			feuille.getCellByPosition(10,3).value=result1.getstring(10)'	total
			feuille.getCellByPosition(17,4).value=clng(result1.getstring(11))+clng(result1.getstring(12))+clng(result1.getstring(13))'tva
			feuille.getCellByPosition(10,6).value=result1.getstring(14)'	pay1
			feuille.getCellByPosition(10,7).value=result1.getstring(15)'	pay2
			feuille.getCellByPosition(10,8).value=result1.getstring(16)'	pay3
			feuille.getCellByPosition(10,9).value=result1.getstring(17)'	pay4
			feuille.getCellByPosition(15,6).string=result1.getstring(18)'	mode1
			feuille.getCellByPosition(15,7).string=result1.getstring(19)'	mode2
			feuille.getCellByPosition(15,8).string=result1.getstring(20)'	mode3
			feuille.getCellByPosition(15,9).string=result1.getstring(21)'	mode4
			feuille.getCellByPosition(17,6).string=result1.getstring(28)'	chq1
			feuille.getCellByPosition(17,7).string=result1.getstring(29)'	chq2
			feuille.getCellByPosition(17,8).string=result1.getstring(30)'	chq3
			feuille.getCellByPosition(17,9).string=result1.getstring(31)'	chq4
			feuille.getCellByPosition(10,10).value=result1.getstring(22)'	rendu
			result1=statement1.executequery("SELECT * FROM mybase.factdet WHERE `facture`="+cstr(numfacture))
			ligne=14
			while result1.next
				if result1.getboolean(6) then
					feuille.GetCellByPosition(0,ligne).value=result1.getstring(6)'		ref int
					feuille.GetCellByPosition(1,ligne).string=result1.getstring(7)'		ref mag
					feuille.GetCellByPosition(3,ligne).string=result1.getstring(8)'		Désignation
					qte=result1.getstring(9)
					feuille.GetCellByPosition(4,ligne).value=qte
					feuille.GetCellByPosition(7,ligne).value=result1.getstring(10)'		tva
					feuille.GetCellByPosition(8,ligne).value=result1.getstring(12)'		HT pub
					feuille.GetCellByPosition(9,ligne).value=clng(feuille.GetCellByPosition(8,ligne).value*(1+feuille.GetCellByPosition(7,ligne).value))' TTC pub
					feuille.GetCellByPosition(10,ligne).value=result1.getstring(11)'	r.
					feuille.GetCellByPosition(13,ligne).value=clng(result1.getstring(13))+clng(vir(result1.getstring(13))*feuille.GetCellByPosition(7,ligne).value)' ttc net
					feuille.GetCellByPosition(14,ligne).value=feuille.GetCellByPosition(13,ligne).value*qte' total
					result2=statement2.executequery("SELECT * FROM mybase.stk WHERE `refint`="+result1.getstring(6))
					if result2.next then
						feuille.GetCellByPosition(2,ligne).string=result2.getstring(4)'	ref fourn
						feuille.GetCellByPosition(5,ligne).value=result2.getstring(14)'	dispo
						feuille.GetCellByPosition(6,ligne).string=result2.getstring(18)'regime
						feuille.GetCellByPosition(15,ligne).string=result2.getstring(26)'colisage
						if qte>=1 then feuille.GetCellByPosition(17,ligne).value =vir(result2.getstring(28))+vir(result2.getstring(29))*(qte-1) 'vol tot
						if qte>=0 then feuille.GetCellByPosition(19,ligne).value=vir(result2.getstring(27))*qte' poids tot
					end if
					if feuille.GetCellByPosition(5,ligne).value<qte then feuille.GetCellByPosition(20,ligne).string="STOCK INSUFFISANT"
				else 'com detect
					feuille.GetCellByPosition(3,ligne).string=result1.getstring(8)' 	Désignation
				end if
				ligne=ligne+1
			wend
		end if
		ThisComponent.CurrentController.ActiveSheet=feuille
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(1,14))
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,0))
	case "devis"
		icleaner
		statement1=connection.CreateStatement
		statement2=connection.CreateStatement
		result1=statement1.executequery("SELECT * FROM mybase.devis WHERE `id`="+cstr(numfacture))
		result1.next
		feuille.getCellByPosition(3,1).string=result1.getstring(2)'	date
		feuille.getCellByPosition(3,2).value=result1.getstring(4)'	n°client
		feuille.getCellByPosition(3,3).string=result1.getstring(5)'	nom
		feuille.getCellByPosition(3,4).string="DEVIS"'				type
		feuille.getCellByPosition(3,7).string=username(result1.getstring(3))'caissier
		feuille.getCellByPosition(3,8).string=result1.getstring(6)'	lieu
		feuille.getCellByPosition(3,9).string=result1.getstring(7)'	bateau
		feuille.getCellByPosition(3,11).string=result1.getstring(8)'contact
		feuille.getCellByPosition(3,12).string=result1.getstring(9)'bc
		feuille.getCellByPosition(10,3).value=result1.getstring(16)'ttc
		feuille.getCellByPosition(17,4).value=clng(result1.getstring(13))+clng(result1.getstring(14))+clng(result1.getstring(15))'tva
		result1=statement1.executequery("SELECT * FROM mybase.devisdet WHERE `devis`="+cstr(numfacture))
		ligne=14
		while result1.next
			if result1.getboolean(3) then
				feuille.GetCellByPosition(0,ligne).value=result1.getstring(3)'	ref int
				feuille.GetCellByPosition(1,ligne).string=result1.getstring(4)'	ref mag
				feuille.GetCellByPosition(3,ligne).string=result1.getstring(5)'	désignation
				qte=result1.getstring(6)
				feuille.GetCellByPosition(4,ligne).value=qte
				feuille.GetCellByPosition(7,ligne).value=result1.getstring(7)'	txtva
				feuille.GetCellByPosition(8,ligne).value=result1.getstring(9)'	HT pub
				feuille.GetCellByPosition(9,ligne).value=clng(feuille.GetCellByPosition(8,ligne).value*(1+feuille.GetCellByPosition(7,ligne).value))'TTC pub
				feuille.GetCellByPosition(10,ligne).value=result1.getstring(8)	'r.
				feuille.GetCellByPosition(13,ligne).value=clng(result1.getstring(10))+clng(vir(result1.getstring(10))*feuille.GetCellByPosition(7,ligne).value)'ttc net
				feuille.GetCellByPosition(14,ligne).value=feuille.GetCellByPosition(13,ligne).value*qte
				result2=statement2.executequery("SELECT * FROM mybase.stk WHERE `refint`="+result1.getstring(3))								'total
				if result2.next then
					feuille.GetCellByPosition(2,ligne).string=result2.getstring(4)'	ref fourn
					feuille.GetCellByPosition(5,ligne).value=result2.getstring(14)'	dispo
					feuille.GetCellByPosition(6,ligne).string=result2.getstring(18)'regime
					feuille.GetCellByPosition(15,ligne).string=result2.getstring(26)'colisage
					if qte>=1 then feuille.GetCellByPosition(17,ligne).value =vir(result2.getstring(28))+vir(result2.getstring(29))*(qte-1)' vol tot
					feuille.GetCellByPosition(19,ligne).value=vir(result2.getstring(27))*qte' poids tot
				end if
				if feuille.GetCellByPosition(5,ligne).value<qte then feuille.GetCellByPosition(20,ligne).string="STOCK INSUFFISANT"
			else 'com detect
				feuille.GetCellByPosition(3,ligne).string=result1.getstring(5)'	Désignation
			end if
			ligne=ligne+1
		wend
		ThisComponent.CurrentController.ActiveSheet=feuille
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(1,14))
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,0))
	case "inexistant"
		msgbox("Facture non trouvée",64,"Impression")
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,0))
	end select
	exit sub' global const l =" @	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub startIVListener
	if errormode then exit sub' global const l =" @
	IVRange=ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0)
	IVListener=CreateUnoListener("IV_","com.sun.star.util.XModifyListener")
	IVRange.addModifyListener(IVListener)
end sub

Sub stopIVListener
	On Error Resume Next
	IVRange.removeModifyListener(IVListener)
End Sub

Sub IV_modified
	if ThisComponent.CurrentController.ActiveSheet.name<>"Aff.Facture" then exit sub' global const l =" @
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopIVListener
	ThisComponent.Sheets.getByName("Aff.Facture").unprotect(mypass)
	iDisplay
	ThisComponent.Sheets.getByName("Aff.Facture").protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	startIVListener
End Sub

Sub IV_disposing
End Sub

sub PdfButton
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	select case factType(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value)
		case "devis": printdevisA4(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value,2)
		case "facture": printfactA4(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value,2)
		case "inexistant": msgbox("Facture non trouvée",64,"Impression")
	end select
	exit sub' global const l =" @
	ErrorHandler:
		msgbox("Un problème inconnu est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub A4button
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	select case factType(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value)
		case "devis": printdevisA4(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value,3)
		case "facture": printfactA4(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value,3)
		case "inexistant": msgbox("Facture non trouvée",64,"Impression")
	end select
	exit sub' global const l =" @
	ErrorHandler:
		msgbox("Un problème inconnu est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub ticketbutton
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	select case factType(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value)
		case "devis": printdevisTM(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value)
		case "facture": printfactTM(ThisComponent.CurrentController.ActiveSheet.getCellByPosition(3,0).Value)
		case "inexistant": msgbox("Facture non trouvée",64,"Impression")
	end select
	exit sub' global const l =" @
	ErrorHandler:
		msgbox("Un problème inconnu est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub icopy
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim requete as string
	dim statement1 as object
	dim result1 as object
	dim statement2 as object
	dim result2 as object
	dim numclient as string
	dim numfacture as long
	dim impaye as long
	dim plafond as long
	dim echeance as date
	dim i as integer
	dim refint as integer
	dim qte as double
	dim htnet as double
	dim totht as double
	dim outdated as boolean
	dim locked as new com.sun.star.util.CellProtection
	dim unlocked as new com.sun.star.util.CellProtection
	locked.islocked=true
	unlocked.islocked=false
	feuille=ThisComponent.Sheets.getByName("Facturation")
	if msgbox("La facturation en cours sera interrompue !",65,"Duplication facture")<>1 then exit sub' global const l =" @
	numfacture=ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0).value
	select case factType(numfacture)
	case "inexistant"
		msgbox("Facture non trouvée")
	case "devis"
		stopPosListener
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.CurrentController.ActiveSheet=feuille
		ThisComponent.lockcontrollers
		feuille.unprotect(mypass)
		poscleaner
		statement1=connection.CreateStatement
		result1=statement1.executequery("SELECT * FROM mybase.devis WHERE `id`="+cstr(numfacture))
		result1.next
		numclient=result1.getstring(4)
		outdated=(date-dateFromSQL(result1.getstring(2))>quotevalidity)
		feuille.getCellByPosition(3,0).value=numclient				'n°client
		feuille.getCellByPosition(27,5).value=numclient				'n°client
		feuille.getCellByPosition(3,1).string=result1.getstring(5)	'nom
		feuille.getCellByPosition(3,5).string=result1.getstring(6)	'lieu
		feuille.getCellByPosition(3,6).string=result1.getstring(7)	'bateau
		feuille.getCellByPosition(3,8).string=result1.getstring(8)	'contact
		result1=statement1.executequery("SELECT * FROM mybase.customer WHERE `id`="+numclient)
		if result1.next then
			if result1.getboolean(4) then	'unlock name
				feuille.getCellByPosition(3,1).cellprotection=unlocked
				feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=false
				feuille.getCellByPosition(27,7).value=1
			else
				feuille.getCellByPosition(3,1).cellprotection=locked
				feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=true
				feuille.getCellByPosition(27,7).value=0
			end if
			feuille.getCellByPosition(3,2).string=result1.getstring(3)'	type client
			feuille.getCellByPosition(3,3).value=result1.getint(18)'		solde
			feuille.getCellByPosition(27,0).value=result1.getstring(9)'	r.
			feuille.getCellByPosition(27,1).value=result1.getint(11)'		plafond
			feuille.getCellByPosition(27,2).value=result1.getint(10)'		credit
			feuille.getCellByPosition(27,4).string=result1.getstring(12)'	echeance
		else
			feuille.getCellRangeByPosition(3,0,3,12).clearContents(flag)
			feuille.getCellByPosition(3,1).string="non trouvé"
			feuille.getCellByPosition(27,5).value=0
		end if
		result1=statement1.executequery("SELECT * FROM mybase.devisdet WHERE devis="+cstr(numfacture))
		i=13
		while result1.next
			i=i+1
			refint=result1.getstring(3)
			if refint then
				statement2=connection.CreateStatement
				result2=statement2.executequery("SELECT * FROM mybase.stk WHERE `refint`="+refint)
				if result2.next then
					feuille.getCellByPosition(0,i).value=refint
					feuille.getCellByPosition(1,i).string=result2.getstring(2)'	ref mag
					feuille.getCellByPosition(2,i).string=result2.getstring(4)'	ref fourn
					feuille.getCellByPosition(3,i).string=result1.getstring(5)'	Désignation
					qte=result1.getstring(6)
					feuille.getCellByPosition(4,i).value=qte'					qté cmd
					feuille.getCellByPosition(5,i).value=qte'					qté cmd
					feuille.getCellByPosition(6,i).value=result2.getstring(14)'	qté dispo
					feuille.getCellByPosition(7,i).string=result2.getstring(18)'régime
					feuille.getCellByPosition(8,i).value=result2.getint(19)'	n°tva
					feuille.getCellByPosition(10,i).value=result2.getstring(23)'ht pub
					if outdated then
						feuille.getCellByPosition(12,i).value=0'	r.
						feuille.getCellByPosition(13,i).value=0'	r.
						htnet=result2.getstring(23)
					else
						feuille.getCellByPosition(12,i).value=result1.getstring(8)'	r.
						feuille.getCellByPosition(13,i).value=result1.getstring(8)'	r.
						htnet=result1.getstring(10)
					end if
					totht=htnet*qte
					feuille.getCellByPosition(14,i).value=result2.getstring(20)'Rmax
					feuille.getCellByPosition(15,i).value=htnet'				htnet
					feuille.getCellByPosition(18,i).string=result2.getstring(26)'colisage
					feuille.getCellByPosition(19,i).value=result2.getstring(28)'vol1
					feuille.getCellByPosition(20,i).value=result2.getstring(29)'vol2
					if qte>1 then
						feuille.getCellByPosition(21,i).value=feuille.getCellByPosition(19,i).value+feuille.getCellByPosition(20,i).value*(qte-1)'vol tot
					else
						feuille.getCellByPosition(21,i).value=feuille.getCellByPosition(19,i).value*qte'vol tot
					end if
					feuille.getCellByPosition(22,i).value=result2.getstring(27)'poids Unit
					feuille.getCellByPosition(23,i).value=feuille.getCellByPosition(22,i).value*qte'poids tot
					if qte>vir(result2.getstring(14)) then feuille.getCellByPosition(24,i).string="STOCK INSUFFISANT"
					feuille.getCellByPosition(33,i).value=result2.getstring(24)'max1
					feuille.getCellByPosition(34,i).value=result2.getstring(25)'max2
					feuille.getCellByPosition(35,i).value=result2.getstring(22)'revpond
					feuille.getCellByPosition(36,i).value=result2.getstring(30)'mode
					select case result2.getint(19)'								TVA
						case 0
							feuille.getCellByPosition(9,i).value=0'				% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)'	ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)'	tot ttc
							feuille.getCellByPosition(29,i).value=clng(totht)'	base tva
						case 1
							feuille.getCellByPosition(9,i).value=tva1'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva1)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva1)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva1)'tot ttc
							feuille.getCellByPosition(26,i).value=clng(totht)'base tva
							feuille.getCellByPosition(30,i).value=clng(totht*tva1)'tva
						case 2
							feuille.getCellByPosition(9,i).value=tva2'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva2)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva2)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva2)'tot ttc
							feuille.getCellByPosition(27,i).value=clng(totht)'base tva
							feuille.getCellByPosition(31,i).value=clng(totht*tva2)'tva
						case 3
							feuille.getCellByPosition(9,i).value=tva3'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva3)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva3)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva3)'tot ttc
							feuille.getCellByPosition(28,i).value=clng(totht)'base tva
							feuille.getCellByPosition(32,i).value=clng(totht*tva3)'tva
					end select
				end if
			else 'com
				feuille.getCellByPosition(3,i).string=result1.getstring(5)'	Désignation
			end if
		wend
		ThisComponent.calculateAll
		creditControl
		feuille.protect(mypass)
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.unlockcontrollers
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,14))
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,13))
		startposListener
		if outdated then msgbox("Validité du devis échue."+chr(13)+"Les prix ont été mis à jour",64,"Duplication")
	case "facture"
		stopPosListener
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.CurrentController.ActiveSheet=feuille
		ThisComponent.lockcontrollers
		feuille.unprotect(mypass)
		poscleaner
		statement1=connection.CreateStatement
		result1=statement1.executequery("SELECT * FROM mybase.fact WHERE `id`="+cstr(numfacture))
		result1.next
		numclient=result1.getstring(4)
		outdated=(date-dateFromSQL(result1.getstring(2))>quotevalidity)
		feuille.getCellByPosition(3,0).value=numclient				'n°client
		feuille.getCellByPosition(27,5).value=numclient				'n°client
		feuille.getCellByPosition(3,1).string=result1.getstring(6)	'nom
		feuille.getCellByPosition(3,5).string=result1.getstring(7)	'lieu
		feuille.getCellByPosition(3,6).string=result1.getstring(8)	'bateau
		feuille.getCellByPosition(3,8).string=result1.getstring(27)	'contact
		result1=statement1.executequery("SELECT * FROM mybase.customer WHERE `id`="+numclient)
		if not result1.next then
			numclient=defaultcust
			result1=statement1.executequery("SELECT * FROM mybase.customer WHERE `id`="+numclient)
			result1.next
			feuille.getCellByPosition(3,0).value=numclient'	n°client
			feuille.getCellByPosition(27,5).value=numclient'n°client
			feuille.getCellByPosition(3,1).string=result1.getstring(2)'client divers
			feuille.getCellByPosition(3,5).string=""'		lieu
			feuille.getCellByPosition(3,6).string=""'		bateau
			feuille.getCellByPosition(3,8).string=""'		contact
		end if
		if result1.getboolean(4) then	'unlock name
			feuille.getCellByPosition(3,1).cellprotection=unlocked
			feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=false
			feuille.getCellByPosition(27,7).value=1
		else
			feuille.getCellByPosition(3,1).cellprotection=locked
			feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=true
			feuille.getCellByPosition(27,7).value=0
		end if
		feuille.getCellByPosition(3,2).string=result1.getstring(3)'	type client
		feuille.getCellByPosition(3,3).value=result1.getint(18)'	solde
		feuille.getCellByPosition(27,0).value=result1.getstring(9)'	r.
		feuille.getCellByPosition(27,1).value=result1.getint(11)'	plafond
		feuille.getCellByPosition(27,2).value=result1.getint(10)'	credit
		feuille.getCellByPosition(27,4).string=result1.getstring(12)'echeance
		result1=statement1.executequery("SELECT * FROM mybase.factdet WHERE facture="+cstr(numfacture))
		i=13
		while result1.next
			i=i+1
			refint=result1.getstring(6)
			if refint then
				statement2=connection.CreateStatement
				result2=statement2.executequery("SELECT * FROM mybase.stk WHERE `refint`="+refint)
				if result2.next then
					feuille.getCellByPosition(0,i).value=refint
					feuille.getCellByPosition(1,i).string=result2.getstring(2)'	ref mag
					feuille.getCellByPosition(2,i).string=result2.getstring(4)'	ref fourn
					feuille.getCellByPosition(3,i).string=result1.getstring(8)'	Désignation
					qte=result1.getstring(9)
					feuille.getCellByPosition(4,i).value=qte'					qté cmd
					feuille.getCellByPosition(5,i).value=qte'					qté cmd
					feuille.getCellByPosition(6,i).value=result2.getstring(14)'	qté dispo
					feuille.getCellByPosition(7,i).string=result2.getstring(18)'régime
					feuille.getCellByPosition(8,i).value=result2.getint(19)'	n°tva
					feuille.getCellByPosition(10,i).value=result2.getstring(23)'ht pub
					if outdated then
						feuille.getCellByPosition(12,i).value=0'	r.
						feuille.getCellByPosition(13,i).value=0'	r.
						htnet=result2.getstring(23)
					else
						feuille.getCellByPosition(12,i).value=result1.getstring(11)'r.
						feuille.getCellByPosition(13,i).value=result1.getstring(11)'r.
						htnet=result1.getstring(13)
					end if
					totht=htnet*qte
					feuille.getCellByPosition(14,i).value=result2.getstring(20)'Rmax
					feuille.getCellByPosition(15,i).value=htnet'				htnet
					feuille.getCellByPosition(18,i).string=result2.getstring(26)'colisage
					feuille.getCellByPosition(19,i).value=result2.getstring(28)'vol1
					feuille.getCellByPosition(20,i).value=result2.getstring(29)'vol2
					if qte>1 then
						feuille.getCellByPosition(21,i).value=feuille.getCellByPosition(19,i).value+feuille.getCellByPosition(20,i).value*(qte-1)'vol tot
					else
						feuille.getCellByPosition(21,i).value=feuille.getCellByPosition(19,i).value*qte'vol tot
					end if
					feuille.getCellByPosition(22,i).value=result2.getstring(27)'poids Unit
					feuille.getCellByPosition(23,i).value=feuille.getCellByPosition(22,i).value*qte'poids tot
					if qte>vir(result2.getstring(14)) then feuille.getCellByPosition(24,i).string="STOCK INSUFFISANT"
					feuille.getCellByPosition(33,i).value=result2.getstring(24)'max1
					feuille.getCellByPosition(34,i).value=result2.getstring(25)'max2
					feuille.getCellByPosition(35,i).value=result2.getstring(22)'revpond
					feuille.getCellByPosition(36,i).value=result2.getstring(30)'mode
					select case result2.getint(19)'								TVA
						case 0
							feuille.getCellByPosition(9,i).value=0'				% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)'	ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)'	tot ttc
							feuille.getCellByPosition(29,i).value=clng(totht)'	base tva
						case 1
							feuille.getCellByPosition(9,i).value=tva1'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva1)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva1)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva1)'tot ttc
							feuille.getCellByPosition(26,i).value=clng(totht)'base tva
							feuille.getCellByPosition(30,i).value=clng(totht*tva1)'tva
						case 2
							feuille.getCellByPosition(9,i).value=tva2'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva2)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva2)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva2)'tot ttc
							feuille.getCellByPosition(27,i).value=clng(totht)'base tva
							feuille.getCellByPosition(31,i).value=clng(totht*tva2)'tva
						case 3
							feuille.getCellByPosition(9,i).value=tva3'			% tva
							feuille.getCellByPosition(11,i).value=clng(feuille.getCellByPosition(10,i).value)+clng(feuille.getCellByPosition(10,i).value*tva3)'ttc pub
							feuille.getCellByPosition(16,i).value=clng(htnet)+clng(htnet*tva3)'ttc net
							feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva3)'tot ttc
							feuille.getCellByPosition(28,i).value=clng(totht)'base tva
							feuille.getCellByPosition(32,i).value=clng(totht*tva3)'tva
					end select
				end if
			else 'com
				feuille.getCellByPosition(3,i).string=result1.getstring(8)'	Désignation
			end if
		wend
		ThisComponent.calculateAll
		creditControl
		feuille.protect(mypass)
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.unlockcontrollers
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,14))
		ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,13))
		startposListener
		if outdated then msgbox("Validité du devis échue."+chr(13)+"Les prix ont été mis à jour",64,"Duplication")
	end select
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub
