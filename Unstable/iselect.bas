option explicit

sub iselectcleaner
	dim feuille as object
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	i=10
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	iPreSelect
end sub

sub iPreSelect
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Factures").getCellByPosition(0,10))
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Factures").getCellByPosition(4,1))
	dim oRanges
	oRanges=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
  	ThisComponent.CurrentController.Select(oRanges)
end sub

sub chercheFactures
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim requete as string
	dim chq as string
	dim result as object
	dim feuille as object
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	feuille.getCellByPosition(4,2).string=charfilter(feuille.getCellByPosition(4,2).string)
	feuille.getCellByPosition(4,4).string=charfilter(feuille.getCellByPosition(4,4).string)
	statement=connection.CreateStatement
	requete="SELECT * FROM mybase.fact WHERE "
	if feuille.getCellByPosition(4,1).value then requete=requete+" `numclient`='"+cstr(feuille.getCellByPosition(4,1).value)+"'"
	if feuille.getCellByPosition(4,2).string<>"" then
		if feuille.getCellByPosition(4,1).value then requete=requete+" AND "
		requete=requete+"`nom` LIKE '"+feuille.getCellByPosition(4,2).string+"%'"
	end if
	if feuille.getCellByPosition(4,3).value then
		if feuille.getCellByPosition(4,1).value or feuille.getCellByPosition(4,2).string<>"" then requete=requete+" AND "
		requete=requete+"`datefact`>='"+dateToSQL(feuille.getCellByPosition(4,3).value)+"'"
	end if
	if feuille.getCellByPosition(4,4).string<>"" then
		if feuille.getCellByPosition(4,1).value or feuille.getCellByPosition(4,2).string<>"" or feuille.getCellByPosition(4,3).value then requete=requete+" AND "
		requete=requete+"`utilisateur`='"+feuille.getCellByPosition(4,4).string+"'"
	end if
	if feuille.getCellByPosition(4,5).string<>"" then
		if feuille.getCellByPosition(4,1).value or feuille.getCellByPosition(4,2).string<>"" or feuille.getCellByPosition(4,3).value or feuille.getCellByPosition(4,4).value then requete=requete+" AND "
		requete=requete+"ttc='"+dot(feuille.getCellByPosition(4,5).value)+"'"
	end if
	ligne=9
	if requete="SELECT * FROM mybase.fact WHERE " then
		msgbox("Au moins 1 critère de recherche est nécessaire",0,"Recherche")
	else
		requete=requete+" ORDER BY `id` LIMIT 400"
		result=statement.executequery(requete)
		while result.next
			ligne=ligne+1
			feuille.getCellByPosition(0,ligne).value=result.getstring(1)
			feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
			feuille.getCellByPosition(2,ligne).string=result.getstring(3)
			feuille.getCellByPosition(3,ligne).value=result.getstring(4)
			feuille.getCellByPosition(4,ligne).string=result.getstring(6)
			feuille.getCellByPosition(5,ligne).value=result.getstring(10)
			feuille.getCellByPosition(6,ligne).string=result.getstring(23)
			feuille.getCellByPosition(7,ligne).string=result.getstring(25)
			feuille.getCellByPosition(8,ligne).value=result.getstring(14)
			feuille.getCellByPosition(9,ligne).value=result.getstring(15)
			feuille.getCellByPosition(10,ligne).value=result.getstring(16)
			feuille.getCellByPosition(11,ligne).value=result.getstring(17)
			chq=""
			if result.getboolean(28) then chq=chq+result.getstring(28)+","
			if result.getboolean(29) then chq=chq+result.getstring(29)+","
			if result.getboolean(30) then chq=chq+result.getstring(30)+","
			if result.getboolean(31) then chq=chq+result.getstring(31)+","
			if chq<>"" then
				chq=left(chq,len(chq)-1)
				feuille.getCellByPosition(12,ligne).string=chq
			end if
		wend
	end if
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" facture(s) trouvée(s)"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub cherchelastfact
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact ORDER BY `id` DESC LIMIT 400")
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub viewSelect
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim numfacture as long
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Aff.Facture")
	if selectedRow>9 then
		numfacture=ThisComponent.CurrentController.ActiveSheet.getCellByPosition(0,selectedRow).Value
		if numfacture then
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
	msgbox("Vous n'avez pas sélectionné de facture !",64,"Factures")
end sub

sub today
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact WHERE DATE(`datefact`)='"+dateToSQL(date)+"' ORDER BY `id`")
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub yesterday
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact WHERE DATE(`datefact`)='"+dateToSQL(date-1)+"'")
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub thismonth
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact WHERE MONTH(`datefact`)="+month(date)+" AND YEAR(`datefact`)="+year(date))
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub previousmonth
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact WHERE MONTH(`datefact`)="+month(DateAdd("m",-1,date))+" AND YEAR(`datefact`)="+year(DateAdd("m",-1,date)))
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub thisyear
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	feuille.unprotect(mypass)
	result=statement.executequery("SELECT * FROM mybase.fact WHERE YEAR(`datefact`)="+year(date))
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub previousyear
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim chq as string
	dim result as object
	dim feuille as object
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim statement
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(4,1,4,5).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,12,lastfact).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.fact WHERE YEAR(`datefact`)="+(year(date)-1))
	ligne=9
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=result.getstring(1)
		feuille.getCellByPosition(1,ligne).value=dateTimeFromSQL(result.getstring(2))
		feuille.getCellByPosition(2,ligne).string=result.getstring(3)
		feuille.getCellByPosition(3,ligne).value=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(6)		
		feuille.getCellByPosition(5,ligne).value=result.getstring(10)
		feuille.getCellByPosition(6,ligne).string=result.getstring(23)
		feuille.getCellByPosition(7,ligne).string=result.getstring(25)
		feuille.getCellByPosition(8,ligne).value=result.getstring(14)
		feuille.getCellByPosition(9,ligne).value=result.getstring(15)
		feuille.getCellByPosition(10,ligne).value=result.getstring(16)
		feuille.getCellByPosition(11,ligne).value=result.getstring(17)
		chq=""
		if result.getboolean(28) then chq=chq+result.getstring(28)+","
		if result.getboolean(29) then chq=chq+result.getstring(29)+","
		if result.getboolean(30) then chq=chq+result.getstring(30)+","
		if result.getboolean(31) then chq=chq+result.getstring(31)+","
		if chq<>"" then
			chq=left(chq,len(chq)-1)
			feuille.getCellByPosition(12,ligne).string=chq
		end if
	wend
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.getCellByPosition(2,6).string=cstr(ligne-9)+" factures trouvées"
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	iPreSelect
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

Sub trieparfact
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=0'	n°facture
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub triepardate
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=1'	date
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparuser
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=2'	user
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparclient
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=3'	n°client
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparnom
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=4'	nom
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparmontant
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	feuille.getCellByPosition(2,6).string="Veuillez patienter"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,10,12,lastfact)
	oSortFields(0).Field=5'	montant
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(2,6).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

function lastfact as double
	dim counter as double
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Factures")
	counter=10
	while feuille.getCellByPosition(1,counter).Value
		counter=counter+1
	wend
	lastfact=counter
end function
