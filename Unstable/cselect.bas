Option Explicit

function lastclient as integer
	dim counter as integer
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Clients")
	counter=5
	while feuille.getCellByPosition(0,counter).Value
		counter=counter+1
	wend
	lastclient=counter
end function

sub ccleaner
	dim feuille as object
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,10,lastclient).clearContents(flag)
	feuille.getCellByPosition(3,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(0,5))
	feuille.protect(mypass)
end sub

sub calculsoldes
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim retour as integer
	dim statement as object
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.getCellByPosition(3,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,10,lastclient).clearContents(flag)
	statement=connection.CreateStatement
	retour=statement.executeUpdate("CALL soldes")
	result=statement.executequery("SELECT * FROM mybase.customer WHERE `typeclient`<>'Gestion' ORDER BY `nom`")
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)'n°client
		feuille.getCellByPosition(1,ligne).string=result.getstring(2)'nom
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)'type
		feuille.getCellByPosition(3,ligne).value=result.getstring(18)'solde
		feuille.getCellByPosition(4,ligne).string=result.getstring(13)'dirigeant
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)'BP
		feuille.getCellByPosition(6,ligne).string=result.getstring(14)'tel
		feuille.getCellByPosition(7,ligne).string=result.getstring(17)'contact
	wend
	feuille.getCellByPosition(3,1).string=cstr(ligne-4)+" clients"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,7,5))
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub balanceButton
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim numclient as integer
	numclient=ThisComponent.CurrentController.ActiveSheet.getCellByPosition(0,selectedRow).Value
	if selectedRow>4 and numclient then
		if numclient then
			if genBalanceError(numclient) then
				goto ErrorHandler
			end if
		else
			msgbox("CALCULER les soldes d'abord")
		end if
	else
		msgbox("Vous n'avez pas sélectionné de client !",64,"Balance client")
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

function genBalanceError(numclient as integer) as boolean
	on error goto ErrorHandler
	dim sourceSheet as object
	dim targetSheet as object
	dim result as object
	dim retour as integer
	dim statement as object
	dim ligne as integer
	dim lastline as integer
	dim startdate as date
	dim startfact as string
	dim echeance as date
	dim previousmonth as date
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim targetDoc
	dim arg(1) As New com.sun.star.beans.PropertyValue
	arg(0).Name="AsTemplate"
	arg(0).Value=true
	arg(1).Name ="Hidden"
	arg(1).Value=true
	sourceSheet=ThisComponent.Sheets.getByName("Clients")
	sourceSheet.getCellByPosition(3,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	targetDoc=StarDesktop.LoadComponentFromUrl(balanceURL, "_blank" , 0, arg)
	targetSheet=targetDoc.Sheets(0)
	if day(date)<15 then
		echeance=dateserial(year(date),month(date),15)' prochaine échéance
		targetSheet.getCellByPosition(3,115).string="TOTAL A PAYER AVANT LE 15 "+ucase(format(echeance,"mmmm"))
	else
		echeance=DateAdd("m",1,(dateserial(year(date),month(date),15)))' prochaine échéance
		targetSheet.getCellByPosition(3,115).string="TOTAL A PAYER AVANT LE 15 "+ucase(format(echeance,"mmmm"))
	end if
	statement=connection.CreateStatement
	retour=statement.executeUpdate("UPDATE mybase.customer SET `solde`= (SELECT SUM(`ttc`) FROM mybase.fact WHERE `numclient`="+numclient+" AND `typefact`='Crédit') + (SELECT SUM(`rendu`-`montant`) FROM mybase.regl WHERE `numclient`="+numclient+") WHERE `id`="+numclient)
	result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`="+numclient)
	result.next
	targetSheet.getCellByPosition(2,8).value=date'	aujourd'hui
	targetSheet.getCellByPosition(3,1).value=numclient
	targetSheet.getCellByPosition(3,2).string=result.getstring(2)'nom
	targetSheet.getCellByPosition(3,3).string=result.getstring(13)'dirigeant
	targetSheet.getCellByPosition(3,4).string=result.getstring(7)'tahiti
	targetSheet.getCellByPosition(3,5).string=result.getstring(8)'bp
	targetSheet.getCellByPosition(4,116).value=result.getstring(18)'solde
	result=statement.executequery("SELECT `datefact` FROM mybase.fact WHERE `numclient`="+numclient+" AND `typefact`='CRÉDIT' AND `lettre`='' ORDER BY `id`")
	previousmonth=DateAdd("m",-1,(dateserial(year(date),month(date),1)))
	if result.next then' recherche facture non lettrée
		startdate=dateFromSQL(result.getstring(1))
		startdate=dateserial(year(startdate),month(startdate),1)
		if startdate>previousmonth then startdate=previousmonth
		result=statement.executequery("SELECT `id` FROM mybase.fact WHERE `numclient`="+numclient+" AND `datefact`>='"+dateToSQL(startdate)+" 00:00:00' ORDER BY `id`")
		result.next
		startfact=result.getstring(1)
		result=statement.executequery("SELECT * FROM mybase.fact WHERE `id`>="+startfact+" AND `numclient`="+numclient)
	else' aucune facture non lettrée trouvée, recherche facture comptant
		result=statement.executequery("SELECT * FROM mybase.fact WHERE `numclient`="+numclient+" AND `datefact`>='"+dateToSQL(previousmonth)+" 00:00:00'")
		if result.next then
			startfact=result.getstring(1)
			result=statement.executequery("SELECT * FROM mybase.fact WHERE `id`>="+startfact+" AND `numclient`="+numclient)
		end if
	end if
	ligne=13
	while result.next
		ligne=ligne+1
		targetSheet.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(2))'date fact
		targetSheet.getCellByPosition(2,ligne).string=result.getstring(1)'n°fact
		targetSheet.getCellByPosition(4,ligne).value=result.getstring(10)'ttc
		targetSheet.getCellByPosition(5,ligne).string=result.getstring(25)'lettre
		select case result.getstring(23)'type fact
			case "COMPTANT"
				targetSheet.getCellByPosition(1,ligne).string="Facture comptant"
			case "CRÉDIT"
				targetSheet.getCellByPosition(1,ligne).string="Facture crédit"
				targetSheet.getCellByPosition(3,ligne).value=dateFromSQL(result.getstring(24))'échéance
				if result.getstring(25)="" then
					targetSheet.GetCellRangeByPosition(0,ligne,7,ligne).CharColor=0
					if targetSheet.getCellByPosition(3,ligne).value<=echeance then
						targetSheet.getCellByPosition(6,ligne).value=result.getstring(10)' à payer
					end if
				end if
		end select
	wend
	if ligne>13 then
		result=statement.executequery("SELECT * FROM mybase.regl WHERE `numclient`="+numclient+" AND `numfact`>="+startfact)
		while result.next
			ligne=ligne+1
			targetSheet.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(2)
			select case result.getstring(4)
				case "ESP": targetSheet.getCellByPosition(1,ligne).string="Versement en espèce"
				case "CHQ": targetSheet.getCellByPosition(1,ligne).string="Chèque"
				case "CB": targetSheet.getCellByPosition(1,ligne).string="Versement par carte"
				case "VIR": targetSheet.getCellByPosition(1,ligne).string="Virement"
				case "MDT": targetSheet.getCellByPosition(1,ligne).string="Mandat postal"
			end select
			targetSheet.getCellByPosition(2,ligne).string=result.getstring(6)'n°fact
			targetSheet.getCellByPosition(4,ligne).value=result.getint(10)-result.getint(5)'montant
			if result.getstring(7)="" then
				targetSheet.GetCellRangeByPosition(0,ligne,7,ligne).CharColor=0
				targetSheet.getCellByPosition(6,ligne).value=targetSheet.getCellByPosition(4,ligne).value' à payer
			else
				targetSheet.getCellByPosition(5,ligne).string=result.getstring(7)'lettre
			end if
		wend
		lastline=ligne
		oRange=targetSheet.getCellRangeByPosition(0,14,5,lastline)
		oSortFields(0).Field=2
		oSortFields(0).SortAscending=True
		oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
		oSortDesc(0).Name="SortFields"
		oSortDesc(0).Value=oSortFields
		oRange.Sort(oSortDesc)
	else
		targetSheet.getCellByPosition(1,14).string="Pas de facture trouvée"
		lastline=13
	end if
	for ligne=lastline+5 to 113
		targetSheet.getCellByPosition(0,ligne).Rows.IsVisible=FALSE
	next ligne
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	sourceSheet.getCellByPosition(3,1).string=" "
	targetDoc.CurrentController.Frame.ContainerWindow.toFront
	targetDoc.CurrentController.Frame.ContainerWindow.Visible=True
	targetDoc.CurrentController.Frame.Activate
	genBalanceError=false
	exit function' global const l =" @
	ErrorHandler:
	genBalanceError=true
	on error goto 0
end function

Sub trieparnumclient
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastclient)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub trieparnom
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastclient)
	oSortFields(0).Field=1
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub triepartype
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastclient)
	oSortFields(0).Field=2
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub trieparsolde
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Clients")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastclient)
	oSortFields(0).Field=3
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub
