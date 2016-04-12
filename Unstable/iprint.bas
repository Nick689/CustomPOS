option explicit

sub printcleaner
	dim printsheet as object
	printsheet=ThisComponent.Sheets.getByName("modèleFacture")
	printsheet.unprotect(mypass)
	printsheet.getCellRangeByPosition(4,1,4,9).clearContents(flag)
	printsheet.getCellRangeByPosition(0,11,9,113).clearContents(flag)
	printsheet.getCellRangeByPosition(0,115,7,120).clearContents(flag)
	printsheet.protect(mypass)
	printsheet=ThisComponent.Sheets.getByName("modèleDevis")
	printsheet.unprotect(mypass)
	printsheet.getCellRangeByPosition(4,1,4,9).clearContents(flag)
	printsheet.getCellRangeByPosition(0,11,9,113).clearContents(flag)
	printsheet.getCellRangeByPosition(0,115,7,120).clearContents(flag)
	ThisComponent.Sheets.getByName("ticket").getCellRangeByPosition(0,2,5,115).clearContents(flag)
	printsheet.protect(mypass)
end sub

sub printfactA4(numfacture as long,sortie as integer)
	on error goto ErrorHandler
	dim result as object
	dim result2 as object
	dim printsheet as object
	dim statement as object
	dim qte as double
	dim htn as double
	dim htpub as double
	printsheet=ThisComponent.Sheets.getByName("modèleFacture")
	if permission("printfact") then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		printsheet.unprotect(mypass)
		printsheet.getCellRangeByPosition(4,1,4,9).clearContents(flag)
		printsheet.getCellRangeByPosition(0,11,9,113).clearContents(flag)
		printsheet.getCellRangeByPosition(0,115,7,120).clearContents(flag)
		printsheet.protect(mypass)
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.fact WHERE `id`="+cstr(numFacture))
		result.next
		if result.getboolean(26) then	'archivee
			msgbox ("Facture archivée non disponible",64,"Impression")
			ThisComponent.unlockcontrollers
		else
			if result.getstring(23)="CRÉDIT" then
				printsheet.getCellByPosition(2,0).String="FACTURE CRÉDIT"
				printsheet.getCellByPosition(1,115).String="Date d'échéance: "+result.getstring(24)
				printsheet.getCellByPosition(1,116).String="Pénalités de retard: 2% lors de l'échéance"
				printsheet.getCellByPosition(1,117).Rows.IsVisible=FALSE
				printsheet.getCellByPosition(1,118).String="puis 2% tous les 1er des mois suivants"
			else
				printsheet.getCellByPosition(2,0).String="FACTURE COMPTANT"
				if result.getboolean(14) then
					printsheet.getCellByPosition(0,115).value=result.getlong(14)
					select case result.getstring(18)
						case "ESP": printsheet.getCellByPosition(1,115).String="Francs versés en espèce"
						case "CHQ": printsheet.getCellByPosition(1,115).String="Francs versés par chèque n°"+result.getstring(28)
						case "CB": printsheet.getCellByPosition(1,115).String="Francs versés par carte bancaire"
						case "VIR": printsheet.getCellByPosition(1,115).String="Francs versés par virement bancaire"
						case "MDT": printsheet.getCellByPosition(1,115).String="Francs versés par mandat postal"
					end select
				end if
				if result.getboolean(15) then
					printsheet.getCellByPosition(0,116).value=result.getlong(15)
					select case result.getstring(19)
						case "ESP": printsheet.getCellByPosition(1,116).String="Francs versés en espèce"
						case "CHQ": printsheet.getCellByPosition(1,116).String="Francs versés par chèque n°"+result.getstring(29)
						case "CB": printsheet.getCellByPosition(1,116).String="Francs versés par carte bancaire"
						case "VIR": printsheet.getCellByPosition(1,116).String="Francs versés par virement bancaire"
						case "MDT": printsheet.getCellByPosition(1,116).String="Francs versés par mandat postal"
					end select
				end if
				if result.getboolean(16) then
					printsheet.getCellByPosition(0,118).value=result.getlong(16)
					select case result.getstring(20)
						case "ESP": printsheet.getCellByPosition(1,118).String="Francs versés en espèce"
						case "CHQ": printsheet.getCellByPosition(1,118).String="Francs versés par chèque n°"+result.getstring(30)
						case "CB": printsheet.getCellByPosition(1,118).String="Francs versés par carte bancaire"
						case "VIR": printsheet.getCellByPosition(1,118).String="Francs versés par virement bancaire"
						case "MDT": printsheet.getCellByPosition(1,118).String="Francs versés par mandat postal"
					end select
				end if
				if result.getboolean(17) then
					printsheet.getCellByPosition(0,117).Rows.IsVisible=TRUE
					printsheet.getCellByPosition(0,117).value=result.getlong(17)
					select case result.getstring(21)
						case "ESP": printsheet.getCellByPosition(1,117).String="Francs versés en espèce"
						case "CHQ": printsheet.getCellByPosition(1,117).String="Francs versés par chèque n°"+result.getstring(31)
						case "CB": printsheet.getCellByPosition(1,117).String="Francs versés par carte bancaire"
						case "VIR": printsheet.getCellByPosition(1,117).String="Francs versés par virement bancaire"
						case "MDT": printsheet.getCellByPosition(1,117).String="Francs versés par mandat postal"
					end select
				else
					printsheet.getCellByPosition(0,117).Rows.IsVisible=FALSE
				end if
				if result.getboolean(22) then
					printsheet.getCellByPosition(0,119).value=result.getlong(22)
					printsheet.getCellByPosition(1,119).String="Francs rendus en espèce"
				end if
			end if
			printsheet.getCellByPosition(1,9).String=username(result.getstring(3))'user
			printsheet.getCellByPosition(4,1).String=cstr(numfacture)'n°facture
			printsheet.getCellByPosition(4,2).String=left(result.getstring(2),10)	'date
			if result.getstring(6)="Client divers" then
				printsheet.getCellByPosition(4,3).string=result.getstring(4) 'client
			else
				printsheet.getCellByPosition(4,3).string=result.getstring(4)+"     "+result.getstring(6) 'client
			end if
			printsheet.getCellByPosition(4,6).String=result.getstring(7)			'lieu
			printsheet.getCellByPosition(4,7).String=result.getstring(8)			'navire
			printsheet.getCellByPosition(4,8).String=result.getstring(27)			'contact
			printsheet.getCellByPosition(4,9).String=result.getstring(9)			'bc
			printsheet.getCellByPosition(6,115).value=result.getstring(33)		'base1
			printsheet.getCellByPosition(6,116).value=result.getstring(34)		'base2
			printsheet.getCellByPosition(6,117).value=result.getstring(35)		'base3
			printsheet.getCellByPosition(8,115).value=result.getstring(11)		'tva1
			printsheet.getCellByPosition(8,116).value=result.getstring(12)		'tva2
			printsheet.getCellByPosition(8,117).value=result.getstring(13)		'tva3
			printsheet.getCellByPosition(8,118).value=result.getstring(10)		'ttc
			printsheet.getCellByPosition(0,114).string="Arrêté la facture à "+lettre(result.getint(10))+" Francs CFP"
			result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+result.getstring(4)+"'")
			result.next
			printsheet.getCellByPosition(4,4).string=result.getstring(8)			'bp
			printsheet.getCellByPosition(4,5).String=result.getstring(14)			'bureau
			result=statement.executequery("SELECT * FROM mybase.factdet WHERE `facture`="+cstr(numFacture) )
			dim ligne as integer
			dim nbligne as integer
			ligne=11
			nbligne=0
			while result.next
				htpub=vir(result.getstring(12))
				ligne=ligne+1
				nbligne=nbligne+1
				If result.getstring(6)="" Then	'com detect
					printsheet.getCellByPosition(1,ligne).String=result.getstring(8)
				Else
					qte=result.getstring(9)
					htn=result.getstring(13)
					printsheet.getCellByPosition(0,ligne).String=result.getstring(7)	'refmag
					printsheet.getCellByPosition(1,ligne).String=result.getstring(8)	'designation
					printsheet.getCellByPosition(2,ligne).Value=qte
					printsheet.getCellByPosition(3,ligne).Value=result.getstring(14)	'max zone1
					printsheet.getCellByPosition(4,ligne).Value=result.getstring(15)	'max zone2
					printsheet.getCellByPosition(6,ligne).Value=result.getstring(10)	'tva
					if htn<=htpub then printsheet.getCellByPosition(7,ligne).Value=htpub'HT public
					printsheet.getCellByPosition(5,ligne).Value=result.getstring(11)	'r.
					printsheet.getCellByPosition(8,ligne).Value=htn
					printsheet.getCellByPosition(9,ligne).Value=clng(qte*htn)			'tot ht
				End If
			wend
			dim i as integer
			For i=12 to 112
				printsheet.getCellByPosition(0,i).Rows.IsVisible=FALSE
			Next i
			For i=12 to nbligne+11
				printsheet.getCellByPosition(0,i).Rows.IsVisible=TRUE
			Next i
			if nbligne<33 then
				printsheet.getCellByPosition(0,nbligne+12).Rows.IsVisible=TRUE
				printsheet.getCellByPosition(0,nbligne+13).Rows.IsVisible=TRUE
				printsheet.getCellByPosition(0,nbligne+14).Rows.IsVisible=TRUE
			end if
			ThisComponent.calculateAll
			printsheet.isVisible=True
			ThisComponent.unlockcontrollers
			ThisComponent.CurrentController.ActiveSheet=printsheet
			dim page as object
			page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
			page.IsLandscape=False
			page.PageScale=100
			page.width=21000
			page.height=29700
			page.LeftMargin=600
			page.RightMargin=600
			page.TopMargin=1000
			page.BottomMargin=700
			page.HeaderIsOn=False
			page.FooterIsOn=True
			page.CenterHorizontally=True
			page.CenterVertically=False
			page.PrintAnnotations=False
			page.PrintGrid=False
			page.PrintHeaders=False
			page.PrintDownFirst=True
			page.PrintFormulas=False
			page.PrintZeroValues=False
			select case sortie
				case 1  'preview
					createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:PrintPreview", "", 0, array)
					do
						wait(500)
					loop while inPreviewMode
				case 2  'export PDF
					page.PrintObjects=True
					writePDF(numfacture)
				case 3  'print A4
					page.PrintObjects=False
					dim args1(0) as new com.sun.star.beans.PropertyValue
					args1(0).Name="Printer"
					args1(0).Value=A4printer
					createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
					ThisComponent.CurrentController.ActiveSheet=printsheet
					ThisComponent.print(array)
					wait(100)
			end select
		end if
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=ThisComponent.Sheets.getByName("Aff.Facture")
		printsheet.isVisible=false
	else
		msgbox("Vous n'êtes pas autorisé à imprimer des factures",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
		printsheet.isVisible=false
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+"L'impression a été annulé"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub printdevisA4(numfacture as long,sortie as integer)
	on error goto ErrorHandler
	dim result as object
	dim printsheet as object
	dim statement as object
	dim qte as double
	dim htn as double
	dim htpub as double
	printsheet=ThisComponent.Sheets.getByName("modèleDevis")
	if permission("printfact") then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		printsheet.unprotect(mypass)
		printsheet.getCellRangeByPosition(4,1,4,9).clearContents(flag)
		printsheet.getCellRangeByPosition(0,11,9,113).clearContents(flag)
		printsheet.getCellRangeByPosition(0,115,7,120).clearContents(flag)
		printsheet.protect(mypass)
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.devis WHERE `id`="+cstr(numFacture))
		result.next
		printsheet.getCellByPosition(4,1).String=cstr(numfacture)'	n°devis
		printsheet.getCellByPosition(4,2).String=left(result.getstring(2),10)'date
		if result.getstring(5)="Client divers" then
			printsheet.getCellByPosition(4,3).string=result.getstring(4) 'client
		else
			printsheet.getCellByPosition(4,3).string=result.getstring(4)+"   "+result.getstring(5) 'client
		end if
		printsheet.getCellByPosition(1,9).String=username(result.getstring(3))'user
		printsheet.getCellByPosition(4,6).String=result.getstring(6)			'lieu
		printsheet.getCellByPosition(4,7).String=result.getstring(7)			'navire
		printsheet.getCellByPosition(4,8).String=result.getstring(8)			'contact
		printsheet.getCellByPosition(4,9).String=result.getstring(9)			'bc
		printsheet.getCellByPosition(6,115).value=result.getstring(10)		'base1
		printsheet.getCellByPosition(6,116).value=result.getstring(11)		'base2
		printsheet.getCellByPosition(6,117).value=result.getstring(12)		'base3
		printsheet.getCellByPosition(8,115).value=result.getstring(13)		'tva1
		printsheet.getCellByPosition(8,116).value=result.getstring(14)		'tva2
		printsheet.getCellByPosition(8,117).value=result.getstring(15)		'tva3
		printsheet.getCellByPosition(8,118).value=result.getstring(16)		'ttc
		printsheet.getCellByPosition(0,114).string="Arrêté le devis à "+lettre(result.getint(16))+" Francs CFP"
		result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+result.getstring(4)+"'")
		result.next
		printsheet.getCellByPosition(4,4).string=result.getstring(8)			'bp
		printsheet.getCellByPosition(4,5).String=result.getstring(14)			'bureau
		result=statement.executequery("SELECT * FROM mybase.devisdet WHERE `devis`="+cstr(numFacture))
		dim ligne as integer
		dim nbligne as integer
		ligne=11
		nbligne=0
		while result.next
			htpub=vir(result.getstring(9))
			ligne=ligne+1
			nbligne=nbligne+1
			if result.getboolean(3) then
				qte=result.getstring(6)
				htn=result.getstring(10)
				printsheet.getCellByPosition(0,ligne).String=result.getstring(4)	'refmag
				printsheet.getCellByPosition(1,ligne).String=result.getstring(5)	'designation
				printsheet.getCellByPosition(2,ligne).Value=qte
				printsheet.getCellByPosition(3,ligne).Value=result.getstring(11)  'max zone1
				printsheet.getCellByPosition(4,ligne).Value=result.getstring(12)  'max zone2
				printsheet.getCellByPosition(5,ligne).Value=result.getstring(8)	'r.
				printsheet.getCellByPosition(6,ligne).Value=result.getstring(7)	'tva
				if htn<=htpub then printsheet.getCellByPosition(7,ligne).Value=htpub 'HT public
				printsheet.getCellByPosition(8,ligne).Value=htn
				printsheet.getCellByPosition(9,ligne).Value=clng(qte*htn)			'tot ht
			else	'com detect
				printsheet.getCellByPosition(1,ligne).String=result.getstring(5)
			end If
		wend
		dim i as integer
		for i=12 to 112
			printsheet.getCellByPosition(0,i).Rows.IsVisible=FALSE
		next i
		for i=12 to nbligne+11
			printsheet.getCellByPosition(0,i).Rows.IsVisible=TRUE
		next i
		if nbligne<37 then
			printsheet.getCellByPosition(0,nbligne+12).Rows.IsVisible=TRUE
			printsheet.getCellByPosition(0,nbligne+13).Rows.IsVisible=TRUE
			printsheet.getCellByPosition(0,nbligne+14).Rows.IsVisible=TRUE
		end if
		ThisComponent.calculateAll
		printsheet.isVisible=True
		ThisComponent.unlockcontrollers
		ThisComponent.CurrentController.ActiveSheet=printsheet
		dim page as object
		page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
		page.IsLandscape=False
		page.PageScale=100
		page.width=21000
		page.height=29700
		page.LeftMargin=700
		page.RightMargin=700
		page.TopMargin=1000
		page.BottomMargin=700
		page.HeaderIsOn=False
		page.FooterIsOn=True
		page.CenterHorizontally=True
		page.CenterVertically=False
		page.PrintAnnotations=False
		page.PrintGrid=False
		page.PrintHeaders=False
		page.PrintObjects=True
		page.PrintDownFirst=True
		page.PrintFormulas=False
		page.PrintZeroValues=False
		select case sortie
			case 1  'preview
				createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:PrintPreview", "", 0, array)
				do
					wait(500)
				loop while inPreviewMode
			case 2  'export PDF
				writePDF(numfacture)
			case 3  'print A4
				dim args1(0) as new com.sun.star.beans.PropertyValue
				args1(0).Name="Printer"
				args1(0).Value=A4printer
				createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
				ThisComponent.print(array)
				wait(100)
		end select
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=ThisComponent.Sheets.getByName("Aff.Facture")
		printsheet.isVisible=false
	else
		msgbox("Vous n'êtes pas autorisé à imprimer des factures",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
		printsheet.isVisible=false
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+"L'impression a été annulé"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub writePDF(numfacture as long)
	dim printset(2) as new com.sun.star.beans.PropertyValue
	dim filter(0) as new com.sun.star.beans.PropertyValue
	dim url as string
	url=bureauURL+cstr(numfacture)+".pdf"
	filter(0).Name="Selection"
	filter(0).Value=ThisComponent.currentSelection
	printset(0).Name="FilterName"
	printset(0).Value="calc_pdf_Export"
	printset(1).Name="FilterData"
	printset(1).Value=filter
	if FileExists(url) then
		dim reponse as integer
		reponse=MsgBox(cstr(numfacture)+".pdf existe déjà sur le bureau"+chr(13)+"Voulez-vous l'écraser ?",65,"Enregistrement")
		if reponse=2 then exit sub' global const l =" @
		kill url
	end if
	ThisComponent.storeToURL(url,printset)
end sub

sub printfactTM(numfacture as long)
	on error goto ErrorHandler
	dim result as object
	dim printsheet as object
	dim statement as object
	dim i as integer
	dim qte as double
	dim htn as double
	printsheet=ThisComponent.Sheets.getByName("ticket")
	if permission("printfact") then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		printsheet.unprotect(mypass)
		printsheet.getCellRangeByPosition(0,2,5,115).clearContents(flag)
		printsheet.protect(mypass)
		for i=15  to 110
			printsheet.getCellByPosition(0,i).Rows.IsVisible=FALSE
		next i
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.fact WHERE `id`="+cstr(numFacture))
		result.next
		if result.getboolean(26) then	'archivee
			msgbox ("Facture archivée non disponible",64,"Impression")
		else
			if result.getstring(23)="CRÉDIT" then
				printsheet.getCellByPosition(0,2).String="FACTURE CRÉDIT"
			else
				printsheet.getCellByPosition(0,2).String="FACTURE COMPTANT"
			end if
			printsheet.getCellByPosition(3,3).Value=numfacture
			printsheet.getCellByPosition(3,4).string=left(result.getstring(2),10)	'date
			printsheet.getCellByPosition(3,5).Value=result.getstring(4)			'num client
			if result.getstring(6)<>"Client divers" then printsheet.getCellByPosition(3,6).String=result.getstring(6) 'nom
			printsheet.getCellByPosition(3,7).String=username(result.getstring(3))'user
			printsheet.getCellByPosition(0,112).value=result.getstring(33)		'base1
			printsheet.getCellByPosition(0,113).value=result.getstring(34)		'base2
			printsheet.getCellByPosition(0,114).value=result.getstring(35)		'base3
			printsheet.getCellByPosition(4,112).value=result.getstring(11)		'tva1
			printsheet.getCellByPosition(4,113).value=result.getstring(12)		'tva2
			printsheet.getCellByPosition(4,114).value=result.getstring(13)		'tva3
			printsheet.getCellByPosition(3,115).value=result.getstring(10)		'ttc
			result=statement.executequery("SELECT * FROM mybase.factdet WHERE `facture`="+cstr(numFacture))
			i=10
			while result.next
				printsheet.getCellByPosition(0,i).Rows.IsVisible=TRUE
				If result.getstring(6)="" Then	'com detect
					printsheet.getCellByPosition(2,i).String=result.getstring(8)
				Else
					qte=result.getstring(9)
					htn=result.getstring(13)
					printsheet.getCellByPosition(0,i).Value=qte
					printsheet.getCellByPosition(2,i).String=result.getstring(8)	'designation
					printsheet.getCellByPosition(4,i).Value=result.getstring(10)	'tva
					printsheet.getCellByPosition(5,i).Value=clng(qte*htn)			'tot ht
				End If
				i=i+1
			wend
			ThisComponent.calculateAll
			printsheet.isVisible=True
			ThisComponent.unlockcontrollers
			ThisComponent.CurrentController.ActiveSheet=printsheet
			dim page as object
			page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
			page.IsLandscape=False
			page.PageScale=100
			page.width=8250
			page.height=15000
			page.LeftMargin=0
			page.RightMargin=0
			page.TopMargin=800
			page.BottomMargin=0
			page.HeaderIsOn=False
			page.FooterIsOn=False
			page.CenterHorizontally=False
			page.CenterVertically=False
			page.PrintAnnotations=False
			page.PrintGrid=False
			page.PrintHeaders=False
			page.PrintObjects=True
			page.PrintDownFirst=False
			page.PrintFormulas=False
			page.PrintZeroValues=False
			dim args1(0) as new com.sun.star.beans.PropertyValue
			args1(0).Name="Printer"
			args1(0).Value=ticketPrinter
			createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
			ThisComponent.print(array)
			wait(100)
		end if
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=ThisComponent.Sheets.getByName("Aff.Facture")
		printsheet.isVisible=false
	else
		msgbox("Vous n'êtes pas autorisé à imprimer des factures",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
		printsheet.isVisible=false
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+"L'impression a été annulé"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub

sub printdevisTM(numfacture as long)
	on error goto ErrorHandler
	dim result as object
	dim printsheet as object
	dim statement as object
	dim i as integer
	dim qte as double
	dim htn as double
	printsheet=ThisComponent.Sheets.getByName("ticket")
	if permission("printfact") then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		printsheet.unprotect(mypass)
		printsheet.getCellRangeByPosition(0,2,5,115).clearContents(flag)
		printsheet.protect(mypass)
		for i=15  to 110
			printsheet.getCellByPosition(0,i).Rows.IsVisible=FALSE
		next i
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.devis WHERE `id`="+cstr(numFacture))
		result.next
		printsheet.getCellByPosition(0,2).String="! ! ! ! ! ! DEVIS ! ! ! ! ! !"
		printsheet.getCellByPosition(3,3).Value=numfacture
		printsheet.getCellByPosition(3,4).string=result.getstring(2)			'date
		printsheet.getCellByPosition(3,5).Value=result.getstring(4)			'num client
		if result.getstring(5)<>"Client divers" then printsheet.getCellByPosition(3,6).String=result.getstring(5) 'nom
		printsheet.getCellByPosition(3,7).String=username(result.getstring(3))'user
		printsheet.getCellByPosition(0,112).value=result.getstring(10)		'base1
		printsheet.getCellByPosition(0,113).value=result.getstring(11)		'base2
		printsheet.getCellByPosition(0,114).value=result.getstring(12)		'base3
		printsheet.getCellByPosition(4,112).value=result.getstring(13)		'tva1
		printsheet.getCellByPosition(4,113).value=result.getstring(14)		'tva2
		printsheet.getCellByPosition(4,114).value=result.getstring(15)		'tva3
		printsheet.getCellByPosition(3,115).value=result.getstring(16)		'ttc
		result=statement.executequery("SELECT * FROM mybase.devisdet WHERE `devis`="+cstr(numFacture) )
		i=10
		while result.next
			printsheet.getCellByPosition(0,i).Rows.IsVisible=TRUE
			If result.getboolean(3) Then
				qte=result.getstring(6)
				htn=result.getstring(10)
				printsheet.getCellByPosition(0,i).Value=qte
				printsheet.getCellByPosition(2,i).String=result.getstring(5)	'designation
				printsheet.getCellByPosition(4,i).Value=result.getstring(7)	'tva
				printsheet.getCellByPosition(5,i).Value=clng(qte*htn)			'tot ht
			else 'com detect
				printsheet.getCellByPosition(2,i).String=result.getstring(5)
			End If
			i=i+1
		wend
		ThisComponent.calculateAll
		printsheet.isVisible=True
		ThisComponent.unlockcontrollers
		ThisComponent.CurrentController.ActiveSheet=printsheet
		dim page as object
		page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
		page.IsLandscape=False
		page.PageScale=100
		page.width=8250
		page.height=15000
		page.LeftMargin=0
		page.RightMargin=0
		page.TopMargin=800
		page.BottomMargin=0
		page.HeaderIsOn=False
		page.FooterIsOn=False
		page.CenterHorizontally=False
		page.CenterVertically=False
		page.PrintAnnotations=False
		page.PrintGrid=False
		page.PrintHeaders=False
		page.PrintObjects=True
		page.PrintDownFirst=False
		page.PrintFormulas=False
		page.PrintZeroValues=False
		dim args1(0) as new com.sun.star.beans.PropertyValue
		args1(0).Name="Printer"
		args1(0).Value=ticketPrinter
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
		ThisComponent.CurrentController.ActiveSheet=printsheet
		ThisComponent.print(array)
		wait(100)
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=ThisComponent.Sheets.getByName("Aff.Facture")
		printsheet.isVisible=false
	else
		msgbox("Vous n'êtes pas autorisé à imprimer des factures",64,"Impression")
	end if
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		printsheet.isVisible=false
		msgbox("Un problème est survenu"+chr(13)+"L'impression a été annulé"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Impression")
	on error goto 0
end sub
