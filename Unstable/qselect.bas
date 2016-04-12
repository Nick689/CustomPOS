option explicit

sub qcleaner
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Devis")
	feuille.getCellRangeByPosition(2,1,2,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,9,9,210).clearContents(flag)
	feuille.getCellByPosition(0,6).string=" "
	QPreSelect
end sub

sub QPreSelect
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Devis").getCellByPosition(0,9))
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Devis").getCellByPosition(2,1))
	dim oRanges
	oRanges=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
  	ThisComponent.CurrentController.Select(oRanges)
end sub

sub findQuote
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim requete as string
	dim result as object
	dim feuille as object
	dim statement
	dim ligne as integer
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Devis")
	feuille.getCellByPosition(0,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	statement=connection.CreateStatement
	feuille.getCellRangeByPosition(0,9,9,210).clearContents(flag)
	feuille.getCellByPosition(2,2).string=charfilter(feuille.getCellByPosition(2,2).string)
	feuille.getCellByPosition(2,4).string=charfilter(feuille.getCellByPosition(2,4).string)
	requete="SELECT * FROM mybase.devis WHERE "
	if feuille.getCellByPosition(2,1).value then requete=requete+" `numclient`='"+cstr(feuille.getCellByPosition(2,1).value)+"'"
	if feuille.getCellByPosition(2,2).string<>"" then
		if feuille.getCellByPosition(2,1).value then requete=requete+" AND "
		requete=requete+"`nom` LIKE '"+feuille.getCellByPosition(2,2).string+"%'"
	end if
	if feuille.getCellByPosition(2,3).value then
		if feuille.getCellByPosition(2,1).value or feuille.getCellByPosition(2,2).string<>"" then requete=requete+" AND "
		requete=requete+"`datedev`>='"+dateToSQL(feuille.getCellByPosition(2,3).value)+"'"
	end if
	if feuille.getCellByPosition(2,4).string<>"" then
		if feuille.getCellByPosition(2,1).value or feuille.getCellByPosition(2,2).string<>"" or feuille.getCellByPosition(2,3).value then requete=requete+" AND "
		requete=requete+"`utilisateur`='"+feuille.getCellByPosition(2,4).string+"'"
	end if
	if feuille.getCellByPosition(2,5).string<>"" then
		if feuille.getCellByPosition(2,1).value or feuille.getCellByPosition(2,2).string<>"" or feuille.getCellByPosition(2,3).value or feuille.getCellByPosition(2,4).string<>"" then requete=requete+" AND "
		requete=requete+"`ttc`='"+dot(feuille.getCellByPosition(2,5).value)+"'"
	end if
	ligne=8
	if requete="SELECT * FROM mybase.devis WHERE " then
		msgbox("Au moins 1 critère de recherche est nécessaire",0,"Recherche")
	else
		requete=requete+" ORDER BY `id` DESC LIMIT 200"
		result=statement.executequery(requete)
		while result.next
			ligne=ligne+1
			feuille.getCellByPosition(0,ligne).value=result.getstring(1)	'n°
			feuille.getCellByPosition(1,ligne).value=dateFromSQL(result.getstring(2))	' date
			feuille.getCellByPosition(2,ligne).string=result.getstring(3)	'user
			feuille.getCellByPosition(3,ligne).value=result.getstring(4)	'client
			feuille.getCellByPosition(4,ligne).string=result.getstring(5)	'nom
			feuille.getCellByPosition(5,ligne).string=result.getstring(6)	'lieu
			feuille.getCellByPosition(6,ligne).string=result.getstring(7)	'transport
			feuille.getCellByPosition(7,ligne).value=result.getstring(16)	'ttc
		wend
	end if
	feuille.getCellByPosition(0,6).string=cstr(ligne-8)+" devis trouvé(s)"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	QPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)	
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub findLastQuote
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim result as object
	dim feuille as object
	dim statement
	dim ligne as integer
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Devis")
	feuille.getCellByPosition(0,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(2,1,2,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,9,9,210).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.devis ORDER BY `id` DESC LIMIT 200")
	ligne=8
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1) 'n°devis
		feuille.getCellByPosition(1,ligne).value=dateFromSQL(result.getstring(2)) 'date
		feuille.getCellByPosition(2,ligne).string=result.getstring(3) 'utilisateur
		feuille.getCellByPosition(3,ligne).value=result.getstring(4) 'client
		feuille.getCellByPosition(4,ligne).string=result.getstring(5) 'nom
		feuille.getCellByPosition(5,ligne).string=result.getstring(6) 'lieu
		feuille.getCellByPosition(6,ligne).string=result.getstring(7) 'transport
		feuille.getCellByPosition(7,ligne).value=result.getstring(16) 'ttc
	wend
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(0,6).string=cstr(ligne-8)+" devis trouvé(s)"
	feuille.protect(mypass)
	QPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)	
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub viewSelect
	if errormode then exit sub' global const l =" @
	dim numfacture as long
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Aff.Facture")
	if selectedRow>8 then
		numfacture=ThisComponent.CurrentController.ActiveSheet.getCellByPosition(0,selectedRow).Value
		if numfacture then
			if errormode then exit sub' global const l =" @
			if notconnected then exit sub' global const l =" @
			stopIVListener
			feuille.unprotect(mypass)
			feuille.getCellByPosition(3,0).Value=numfacture
			ThisComponent.enableAutomaticCalculation(false)
			ThisComponent.lockcontrollers
			iDisplay
			feuille.protect(mypass)
			ThisComponent.unlockcontrollers
			ThisComponent.calculateAll
			ThisComponent.enableAutomaticCalculation(true)
			startIVListener
			exit sub' global const l =" @
		end if
	end if
	msgbox("Vous n'avez pas sélectionné de facture !",64,"Affichage")
end sub
