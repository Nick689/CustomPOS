option explicit

sub fdjcleaner
	dim i as integer
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("FDJ")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(1,3,5,161).clearContents(flag)
	feuille.getCellRangeByPosition(2,169,5,170).clearContents(flag)
	feuille.getCellRangeByPosition(0,176,5,182).clearContents(flag)
	for i=1 to 162
		feuille.getCellByPosition(0,i).Rows.IsVisible=False
	next i
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(2,0))
	feuille.protect(mypass)
end sub

sub fdjtoday
	ThisComponent.Sheets.getByName("FDJ").getCellByPosition(2,0).value=date
	fdj
end sub

sub showline
	ThisComponent.Sheets.getByName("FDJ").getCellByPosition(0,selectedRow+1).Rows.IsVisible=True
end sub

sub fdj
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result1 as object
	dim result2 as object
	dim statement1 as object
	dim statement2 as object
	dim retour as integer
	dim jour as long
	dim creditvide as integer
	creditvide=176
	dim ht1 as double
	dim ht2 as double
	dim ht0 as double
	feuille=ThisComponent.Sheets.getByName("FDJ")
	jour=feuille.getCellByPosition(2,0).value
	if jour<42114 then
		msgbox "Date non valide"
		exit sub' global const l =" @
	end if
	if permission("fdj") then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		fdjcleaner
		feuille.unprotect(mypass)
		statement1=connection.CreateStatement
		statement2=connection.CreateStatement
		retour=statement1.executeUpdate("CALL fdj('"+dateToSQL(jour)+"')")
		result1=statement1.executequery("SELECT * FROM mybase.utilisateur WHERE `print`=1")
		if result1.next then
			feuille.getCellByPosition(2,35).value=result1.getlong(14)
			feuille.getCellByPosition(3,35).value=result1.getlong(15)
			feuille.getCellByPosition(4,35).value=result1.getlong(16)
			feuille.getCellByPosition(5,35).value=result1.getlong(17)
			feuille.getCellByPosition(0,1).Rows.IsVisible=True
			feuille.getCellByPosition(0,2).Rows.IsVisible=True
			feuille.getCellByPosition(0,2).string=ucase(result1.getstring(2))
			feuille.getCellByPosition(0,3).Rows.IsVisible=True
			feuille.getCellByPosition(0,14).Rows.IsVisible=True
			feuille.getCellByPosition(0,35).Rows.IsVisible=True
			feuille.getCellByPosition(0,36).Rows.IsVisible=True
			feuille.getCellByPosition(0,37).Rows.IsVisible=True
		end if
		result1=statement1.executequery("SELECT * FROM mybase.utilisateur WHERE `print`=2")
		if result1.next then
			feuille.getCellByPosition(2,72).value=result1.getlong(14)
			feuille.getCellByPosition(3,72).value=result1.getlong(15)
			feuille.getCellByPosition(4,72).value=result1.getlong(16)
			feuille.getCellByPosition(5,72).value=result1.getlong(17)
			feuille.getCellByPosition(0,38).Rows.IsVisible=True
			feuille.getCellByPosition(0,39).Rows.IsVisible=True
			feuille.getCellByPosition(0,39).string=ucase(result1.getstring(2))
			feuille.getCellByPosition(0,40).Rows.IsVisible=True
			feuille.getCellByPosition(0,51).Rows.IsVisible=True
			feuille.getCellByPosition(0,72).Rows.IsVisible=True
			feuille.getCellByPosition(0,73).Rows.IsVisible=True
			feuille.getCellByPosition(0,74).Rows.IsVisible=True
		end if
		result1=statement1.executequery("SELECT * FROM mybase.utilisateur WHERE `print`=3")
		if result1.next then
			feuille.getCellByPosition(2,109).value=result1.getlong(14)
			feuille.getCellByPosition(3,109).value=result1.getlong(15)
			feuille.getCellByPosition(4,109).value=result1.getlong(16)
			feuille.getCellByPosition(5,109).value=result1.getlong(17)
			feuille.getCellByPosition(0,75).Rows.IsVisible=True
			feuille.getCellByPosition(0,76).Rows.IsVisible=True
			feuille.getCellByPosition(0,76).string=ucase(result1.getstring(2))
			feuille.getCellByPosition(0,77).Rows.IsVisible=True
			feuille.getCellByPosition(0,88).Rows.IsVisible=True
			feuille.getCellByPosition(0,109).Rows.IsVisible=True
			feuille.getCellByPosition(0,110).Rows.IsVisible=True
			feuille.getCellByPosition(0,111).Rows.IsVisible=True
		end if
		result1=statement1.executequery("SELECT * FROM mybase.utilisateur WHERE `print`=4")
		if result1.next then
			feuille.getCellByPosition(2,146).value=result1.getlong(14)
			feuille.getCellByPosition(3,146).value=result1.getlong(15)
			feuille.getCellByPosition(4,146).value=result1.getlong(16)
			feuille.getCellByPosition(5,146).value=result1.getlong(17)
			feuille.getCellByPosition(0,112).Rows.IsVisible=True
			feuille.getCellByPosition(0,113).Rows.IsVisible=True
			feuille.getCellByPosition(0,113).string=ucase(result1.getstring(2))
			feuille.getCellByPosition(0,114).Rows.IsVisible=True
			feuille.getCellByPosition(0,125).Rows.IsVisible=True
			feuille.getCellByPosition(0,146).Rows.IsVisible=True
			feuille.getCellByPosition(0,147).Rows.IsVisible=True
			feuille.getCellByPosition(0,148).Rows.IsVisible=True
		end if
		result1=statement1.executequery("SELECT * FROM mybase.regl WHERE `dateregl`='"+dateToSQL(jour)+"'")
		while result1.next
			result2=statement2.executequery("SELECT `freecell` FROM mybase.utilisateur WHERE `id`='"+result1.getstring(8)+"'")
			result2.next
			feuille.getCellByPosition(1,result2.getint(1)).string=result1.getstring(9)' nom
			select case result1.getstring(4)
				case "ESP"
					feuille.getCellByPosition(2,result2.getint(1)).value=result1.getlong(5)-result1.getlong(10)
				case "CHQ"
					feuille.getCellByPosition(2,result2.getint(1)).value=-result1.getlong(10)
					feuille.getCellByPosition(3,result2.getint(1)).value=result1.getlong(5)'chq
				case "CB"
					feuille.getCellByPosition(2,result2.getint(1)).value=-result1.getlong(10)
					feuille.getCellByPosition(4,result2.getint(1)).value=result1.getlong(5)'cb
				case else
					feuille.getCellByPosition(2,result2.getint(1)).value=-result1.getlong(10)
					feuille.getCellByPosition(5,result2.getint(1)).value=result1.getlong(5)'vir
			end select
			feuille.getCellByPosition(0,result2.getint(1)).Rows.IsVisible=True
			retour=statement2.executeUpdate("UPDATE mybase.utilisateur SET `freecell`=`freecell`+1 WHERE `id`='"+result1.getstring(8)+"'")
		wend
		result1=statement1.executequery("SELECT * FROM mybase.fact WHERE `typefact`='CRÉDIT' AND DATE(`datefact`)='"+dateToSQL(jour)+"'")
		while result1.next
			feuille.getCellByPosition(0,creditvide).string=username(result1.getstring(3))
			feuille.getCellByPosition(1,creditvide).value=result1.getlong(1) 	'n°fact
			feuille.getCellByPosition(2,creditvide).string=result1.getstring(6)'client
			feuille.getCellByPosition(5,creditvide).value=result1.getlong(10)	'ttc
			creditvide=creditvide+1
		wend
		result1=statement1.executequery("SELECT `dec1`,`dec2`,`dec3` FROM mybase.output")
		result1.next
		feuille.getCellByPosition(2,169).value=result1.getstring(1)
		feuille.getCellByPosition(3,169).value=result1.getstring(2)
		feuille.getCellByPosition(4,169).value=result1.getstring(3)
		feuille.protect(mypass)
		ThisComponent.unlockcontrollers
		ThisComponent.calculateAll
		ThisComponent.enableAutomaticCalculation(true)
	else
		msgbox("Accés non autorisé",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub printfdj
	on error goto ErrorHandler
	if permission("fdj") then
		dim page as object
		page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
		page.IsLandscape=False
		page.PageScale=100
		page.width=21000
		page.height=29700
		page.LeftMargin=700
		page.RightMargin=700
		page.TopMargin=1500
		page.BottomMargin=700
		page.HeaderIsOn=False
		page.FooterIsOn=False
		page.CenterHorizontally=True
		page.CenterVertically=False
		page.PrintAnnotations=False
		page.PrintGrid=False
		page.PrintHeaders=False
		page.PrintObjects=False
		page.PrintDownFirst=False
		page.PrintFormulas=False
		page.PrintZeroValues=False
		dim args1(0) as new com.sun.star.beans.PropertyValue
		args1(0).Name="Printer"
		args1(0).Value=A4printer
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
		ThisComponent.print(array)
	else
		msgbox("Accés non autorisé",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub
