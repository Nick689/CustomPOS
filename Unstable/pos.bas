Option Explicit

global posListener1 as object
global posRange1 as object
global posListener2 as object
global posRange2 as object
global posListener3 as object
global posRange3 as object
global posListener4 as object
global posRange4 as object
global posListener5 as object
global posRange5 as object
global posListener6 as object
global posRange6 as object
global okpressed as boolean

sub cleanbutton
	if errormode then exit sub' global const l =" @
	if msgbox("Etes-vous sûr de vouloir tout effacer ?",65,"Effacement")<>1 then exit sub' global const l =" @
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	stopPosListener
	poscleaner
	pospreselect
	posBControl("arret")
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	startposListener
end sub

sub poscleaner
	dim feuille as object
	dim locked as new com.sun.star.util.CellProtection
	locked.islocked=true
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.getCellRangeByPosition(3,0,3,12).clearContents(flag)
	feuille.getCellRangeByPosition(12,3,21,11).clearContents(flag)
	feuille.getCellRangeByPosition(27,0,27,9).clearContents(flag)
	feuille.getCellRangeByPosition(0,14,36,114).clearContents(flag)
	feuille.getCellByPosition(3,1).cellprotection=locked
	feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=true
	feuille.getCellByPosition(18,6).string="espèce"
	feuille.getCellByPosition(18,7).string="carte"
	feuille.getCellByPosition(18,8).string="chèque"
	feuille.getCellByPosition(18,9).string="virement"
end sub

sub pospreselect
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Facturation").getCellByPosition(3,0))
	dim oRanges
	oRanges=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
  	ThisComponent.CurrentController.Select(oRanges)
end sub

sub posRowCleaner(row as integer)
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,row,36,row).clearContents(flag)
	feuille.protect(mypass)
end sub

sub posBControl(mode as string)
	dim credit as object
	dim comptant as object
	dim devis as object
	dim remclient as object
	dim remautre as object
	dim form as object
	dim statement as object
	dim result as object
	dim pcredit as boolean
	dim pcomptant as boolean
	dim pdevis as boolean
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	form=feuille.DrawPage.Forms(0)
	credit=form.getByName("credit")
	comptant=form.getByName("comptant")
	devis=form.getByName("devis")
	if mode="arret" then
		credit.Enabled=False
		comptant.Enabled=False
		devis.Enabled=False
	elseif isnull(connection) then
		credit.Enabled=False
		comptant.Enabled=False
		devis.Enabled=False
	else
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.utilisateur WHERE `id`='" +user+ "'")
		result.next
		pcomptant =result.getint(3)
		pcredit =result.getint(4)
		pdevis =result.getint(5)
		select case mode
		case "comptant"
			credit.Enabled=False
			comptant.Enabled=pcomptant
			devis.Enabled=pdevis
		case "credit"
			credit.Enabled=pcredit
			comptant.Enabled=pcomptant
			devis.Enabled=pdevis
		case "devis"
			credit.Enabled=False
			comptant.Enabled=False
			devis.Enabled=pdevis
		end select
	end if
	feuille.protect(mypass)
end sub

sub startposListener
	if errormode then exit sub' global const l =" @
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	posRange1=feuille.getCellRangeByPosition(3,14,3,114)
	posListener1=CreateUnoListener("POS1_","com.sun.star.util.XModifyListener")
	posRange1.addModifyListener(posListener1)
	posRange2=feuille.getCellByPosition(3,0)
	posListener2=CreateUnoListener("POS2_","com.sun.star.util.XModifyListener")
	posRange2.addModifyListener(posListener2)
	posRange3=feuille.getCellRangeByPosition(4,14,4,114)
	posListener3=CreateUnoListener("POS3_","com.sun.star.util.XModifyListener")
	posRange3.addModifyListener(posListener3)
	posRange4=feuille.getCellRangeByPosition(12,14,12,114)
	posListener4=CreateUnoListener("POS4_","com.sun.star.util.XModifyListener")
	posRange4.addModifyListener(posListener4)
	posRange5=feuille.getCellRangeByPosition(16,14,16,114)
	posListener5=CreateUnoListener("POS5_","com.sun.star.util.XModifyListener")
	posRange5.addModifyListener(posListener5)
	posRange6=feuille.getCellRangeByPosition(12,6,12,9)
	posListener6=CreateUnoListener("POS6_","com.sun.star.util.XModifyListener")
	posRange6.addModifyListener(posListener6)
end sub

Sub stopPosListener
	On Error Resume Next
	posRange1.removeModifyListener(posListener1)
	posRange2.removeModifyListener(posListener2)
	posRange3.removeModifyListener(posListener3)
	posRange4.removeModifyListener(posListener4)
	posRange5.removeModifyListener(posListener5)
	posRange6.removeModifyListener(posListener6)
End Sub

Sub POS1_modified 'add product
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim inputString as string
	dim requete as string
	dim blankArray(100) as string
	dim i as integer
	dim htpub as double
	dim ttc as long
	dim row as integer
	row=selectedRow
	if row<14 then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	inputString=feuille.getCellByPosition(3,row).string
	do
		select case left(inputString,1)
		case ""
			posRowCleaner(row)
		case "'"
			posRowCleaner(row)
			mid(inputString,1,1,"")
			feuille.getCellByPosition(3,row).string=charfilter(inputString)
		case else
			inputString=ucase(charfilter(inputString))
			statement=connection.CreateStatement
			if feuille.getCellByPosition(0,row).value=misc then
				feuille.getCellByPosition(3,row).string=inputString
			else
				requete="SELECT * FROM mybase.stk WHERE refmag='"+inputString+"' OR codebar='"+inputString+"' OR reffourn='"+inputString+"' OR ref5='"+inputString+"' OR ref6='"+inputString+"'"
				result=statement.executequery(requete)
				if result.next then
					inputString=result.getstring(1)
				else
					requete="SELECT * FROM mybase.stk WHERE design LIKE '"+inputString+"%' ORDER BY `design` LIMIT 100"
					result=statement.executequery(requete)
					selectNameArray=blankArray
					i=0
					while result.next 'remplissable listbox
						selectIdArray(i)=result.getstring(1)
						htpub=result.getstring(23)
						select case result.getstring(19)
							case 0: ttc=clng(htpub)
							case 1: ttc=clng(htpub)+clng(htpub*tva1)
							case 2: ttc=clng(htpub)+clng(htpub*tva2)
							case 3: ttc=clng(htpub)+clng(htpub*tva3)
						end select
						selectNameArray(i)=" "+alignG(result.getstring(2),14)+alignG(result.getstring(4),14)+alignG(result.getstring(8),30)+alignD(format(result.getlong(14),"0"),5)+alignD(format(ttc,"# ##0"),9)
						i=i+1
					wend
					if i=0 then
						inputString=""
					elseif i=1 then
						inputString=selectIdArray(0)
					else
						okpressed=false
						showprodDialog
						if okpressed then
							if dialogChoice < 0 then
								inputString=""
							elseif dialogChoice < i then
								inputString=selectIdArray(dialogChoice)
							else
								inputString=""
							end if
						else
							inputString=""
						end if
					end if
				end if
				if inputString="" then
					if feuille.getCellByPosition(0,row).value>0 then
						result=statement.executequery("SELECT design FROM mybase.stk WHERE `refint`="+feuille.getCellByPosition(0,row).value)
						result.next
						feuille.getCellByPosition(3,row).string=result.getstring(1)
					else
						posRowCleaner(row)
						feuille.getCellByPosition(3,row).string="'non trouvé"
					end if
				else
					posRowCleaner(row)
					statement=connection.CreateStatement
					result=statement.executequery("SELECT * FROM mybase.stk WHERE `refint`="+inputString)
					result.next
					feuille.getCellByPosition(0,row).value=result.getstring(1)'		ref int
					feuille.getCellByPosition(1,row).string=result.getstring(2'		ref mag
					feuille.getCellByPosition(2,row).string=result.getstring(4)'		ref fourn
					feuille.getCellByPosition(3,row).string=result.getstring(8)'		Désignation
					feuille.getCellByPosition(4,row).value=1'							qté cmd
					feuille.getCellByPosition(5,row).value=1'							qté cmd
					feuille.getCellByPosition(6,row).value=result.getstring(14)'		qté dispo
					feuille.getCellByPosition(7,row).string=result.getstring(18)'		régime
					feuille.getCellByPosition(8,row).value=result.getstring(19)'		n°tva
					htpub=result.getstring(23)
					feuille.getCellByPosition(10,row).value=htpub'					ht pub
					feuille.getCellByPosition(12,row).value=0'						r.
					feuille.getCellByPosition(13,row).value=0'						r.
					feuille.getCellByPosition(14,row).value=result.getstring(20)'		Rmax
					feuille.getCellByPosition(15,row).value=htpub'					ht net
					feuille.getCellByPosition(18,row).string=result.getstring(26)'	colisage
					feuille.getCellByPosition(19,row).value=result.getstring(28)'		vol1
					feuille.getCellByPosition(20,row).value=result.getstring(29)'		vol2
					feuille.getCellByPosition(21,row).value=result.getstring(28)'		vol tot
					feuille.getCellByPosition(22,row).value=result.getstring(27)'		poids Unit
					feuille.getCellByPosition(23,row).value=result.getstring(27)'		poids tot
					feuille.getCellByPosition(33,row).value=result.getstring(24)'		max1
					feuille.getCellByPosition(34,row).value=result.getstring(25)'		max2
					feuille.getCellByPosition(35,row).value=result.getstring(22)'		revpond
					feuille.getCellByPosition(36,row).value=result.getstring(30)'		mode
					if vir(result.getstring(14))<1.0 then feuille.getCellByPosition(24,row).string="STOCK INSUFFISANT"
					select case result.getstring(19)'									TVA
						case 0
							feuille.getCellByPosition(8,row).value=0'					n°tva
							feuille.getCellByPosition(9,row).value=0'					% tva
							feuille.getCellByPosition(11,row).value=clng(htpub)'		ttc pub
							feuille.getCellByPosition(16,row).value=clng(htpub)'		ttc net
							feuille.getCellByPosition(17,row).value=clng(htpub)'		tot ttc
							feuille.getCellByPosition(29,row).value=clng(htpub)'		base tva
						case 1
							feuille.getCellByPosition(8,row).value=1'					n°tva
							feuille.getCellByPosition(9,row).value=tva1'				% tva
							feuille.getCellByPosition(11,row).value=clng(htpub)+clng(htpub*tva1)'ttc pub
							feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value'ttc net
							feuille.getCellByPosition(17,row).value=feuille.getCellByPosition(11,row).value'tot ttc
							feuille.getCellByPosition(26,row).value=clng(htpub)'		base tva
							feuille.getCellByPosition(30,row).value=clng(htpub*tva1)'	tva
						case 2
							feuille.getCellByPosition(8,row).value=2'					n°tva
							feuille.getCellByPosition(9,row).value=tva2'				% tva
							feuille.getCellByPosition(11,row).value=clng(htpub)+clng(htpub*tva2)'ttc pub
							feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value'ttc net
							feuille.getCellByPosition(17,row).value=feuille.getCellByPosition(11,row).value'tot ttc
							feuille.getCellByPosition(27,row).value=clng(htpub)'		base tva
							feuille.getCellByPosition(31,row).value=clng(htpub*tva2)'	tva
						case 3
							feuille.getCellByPosition(8,row).value=3'					n°tva
							feuille.getCellByPosition(9,row).value=tva3'				% tva
							feuille.getCellByPosition(11,row).value=clng(htpub)+clng(htpub*tva3)'ttc pub
							feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value'ttc net
							feuille.getCellByPosition(17,row).value=feuille.getCellByPosition(11,row).value'tot ttc
							feuille.getCellByPosition(28,row).value=clng(htpub)'		base tva
							feuille.getCellByPosition(32,row).value=clng(htpub*tva3)'	tva
					end select
				end if
			end if
		end select
		row=row+1
		inputString=feuille.getCellByPosition(3,row).string
	loop while feuille.getCellByPosition(0,row).value=0 and inputString<>""
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub POS2_modified 'set customer
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	dim feuille as object
	dim result as object
	dim retour as integer
	dim statement as object
	dim impaye as long
	dim inputString as string
	dim echeance as date
	dim i as integer
	dim lastitem as integer
	dim htpub as double
	dim totht as double
	dim blankArray(100) as string
	dim locked as new com.sun.star.util.CellProtection
	dim unlocked as new com.sun.star.util.CellProtection
	locked.islocked=true
	unlocked.islocked=false
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	statement=connection.CreateStatement
	inputString=ucase(charfilter(feuille.getCellByPosition(3,0).string))
	if inputString<>"" then
		result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+inputString+"'")
		if not result.next then
			result=statement.executequery("SELECT * FROM mybase.customer WHERE `nom` LIKE '"+inputString+"%' LIMIT 100")
			selectNameArray=blankArray
			i=0
			while result.next
				selectIdArray(i)=result.getstring(1)
				selectNameArray(i)=result.getstring(1)+" "+result.getstring(2)
				i=i+1
			wend
			if i=0 then
				inputString=""
			elseif i=1 then
				inputString=selectIdArray(0)
			else
				showClientDialog
				if dialogChoice=-1 or dialogChoice>=i then
					inputString=""
				else
					inputString=selectIdArray(dialogChoice)
				end if
			end if
		end if
	end if
	if inputString="" then
		feuille.getCellRangeByPosition(3,0,3,12).clearContents(flag)
		feuille.getCellRangeByPosition(27,0,27,9).clearContents(flag)
		feuille.getCellByPosition(3,1).string="non trouvé"
		feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=true
		feuille.getCellByPosition(3,1).cellprotection=locked
	else
		if inputString<>"100" then
			retour=statement.executeUpdate("UPDATE mybase.customer SET `solde`= (SELECT SUM(`ttc`) FROM mybase.fact WHERE `numclient`="+inputstring+" AND `typefact`='Crédit') + (SELECT SUM(`rendu`-`montant`) FROM mybase.regl WHERE `numclient`="+inputstring+") WHERE `id`="+inputstring)
		end if
		result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`="+inputString)
		result.next
		feuille.getCellByPosition(3,0).value=result.getstring(1)'		n°
		feuille.getCellByPosition(3,1).string=result.getstring(2)'	nom
		if result.getboolean(4) then'	unlock name
			feuille.getCellByPosition(3,1).cellprotection=unlocked
			feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=false
			feuille.getCellByPosition(27,7).value=1'					editable
		else
			feuille.getCellByPosition(3,1).cellprotection=locked
			feuille.getCellByPosition(3,1).IsCellBackgroundTransparent=true
			feuille.getCellByPosition(27,7).value=0'					editable
		end if
		feuille.getCellByPosition(3,5).string=result.getstring(5)'	lieu
		feuille.getCellByPosition(3,6).string=result.getstring(6)'	bateau
		feuille.getCellByPosition(3,8).string=result.getstring(17)'	contact5
		feuille.getCellByPosition(3,2).string=result.getstring(3)'	type client
		feuille.getCellByPosition(3,3).value=result.getint(18)'		solde
		feuille.getCellByPosition(27,0).value=result.getstring(9)'	r.
		feuille.getCellByPosition(27,1).value=result.getint(11)'		plafond
		feuille.getCellByPosition(27,2).value=result.getint(10)'		credit
		feuille.getCellByPosition(27,4).string=result.getstring(12)'	echeance
		feuille.getCellByPosition(27,5).value=result.getstring(1)'	sauv n°client
	end if
	lastitem=itemcounter
	for i=14 to lastitem
		select case feuille.getCellByPosition(36,i).value
		case -1,0,3
		case else
			feuille.getCellByPosition(12,i).value=0'					r.
			feuille.getCellByPosition(13,i).value=0'					r.
			htpub=feuille.getCellByPosition(10,i).value
			feuille.getCellByPosition(15,i).value=htpub'				ht net
			totht=htpub*feuille.getCellByPosition(5,i).value
			select case feuille.getCellByPosition(8,i).value'			tva
				case 0
					feuille.getCellByPosition(16,i).value=clng(htpub)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)'total ttc
					feuille.getCellByPosition(29,i).value=clng(totht)'base tva
				case 1
					feuille.getCellByPosition(16,i).value=clng(htpub)+clng(htpub*tva1)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva1)'total ttc
					feuille.getCellByPosition(26,i).value=clng(totht)'base tva
					feuille.getCellByPosition(30,i).value=clng(totht*tva1)'tva
				case 2
					feuille.getCellByPosition(16,i).value=clng(htpub)+clng(htpub*tva2)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva2)'total ttc
					feuille.getCellByPosition(27,i).value=clng(totht)'base tva
					feuille.getCellByPosition(31,i).value=clng(totht*tva2)'tva
				case 3
					feuille.getCellByPosition(16,i).value=clng(htpub)+clng(htpub*tva3)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva3)'total ttc
					feuille.getCellByPosition(28,i).value=clng(totht)'base tva
					feuille.getCellByPosition(32,i).value=clng(totht*tva3)'tva
			end select
		end select
	next i
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(3,13))
	dim oRanges
	oRanges=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
  	ThisComponent.CurrentController.Select(oRanges)
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub POS3_modified 'Qty modify
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	dim feuille as object
	dim qte as double
	dim totht as double
	dim row as integer
	row=selectedRow
	if row<14 then exit sub' global const l =" @
	feuille=ThisComponent.Sheets.getByName("Facturation")
	if feuille.getCellByPosition(0,row).value=0 then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille.unprotect(mypass)
	qte=feuille.getCellByPosition(4,row).value'				qté
	feuille.getCellByPosition(5,row).value=qte'				qté
	totht=feuille.getCellByPosition(15,row).value*qte'		totht
	select case feuille.getCellByPosition(8,row).value'			n°tva
		case 0
			feuille.getCellByPosition(17,row).value=clng(totht)'total ttc
			feuille.getCellByPosition(29,row).value=clng(totht)'base tva
		case 1
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva1)'total ttc
			feuille.getCellByPosition(26,row).value=clng(totht)'base tva
			feuille.getCellByPosition(30,row).value=clng(totht*tva1)'tva
		case 2
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva2)'total ttc
			feuille.getCellByPosition(27,row).value=clng(totht)'base tva
			feuille.getCellByPosition(31,row).value=clng(totht*tva2)'tva
		case 3
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva3)'total ttc
			feuille.getCellByPosition(28,row).value=clng(totht)'base tva
			feuille.getCellByPosition(32,row).value=clng(totht*tva3)'tva
	end select
	if qte>1 then
		feuille.getCellByPosition(21,row).value=feuille.getCellByPosition(19,row).value+feuille.getCellByPosition(20,row).value*(qte-1) 'vol tot
	else
		feuille.getCellByPosition(21,row).value=feuille.getCellByPosition(19,row).value*qte 'vol tot
	end if
	if qte>0 then feuille.getCellByPosition(23,row).value=feuille.getCellByPosition(22,row).value*qte 'poids tot
	if qte>feuille.getCellByPosition(6,row).value then
		feuille.getCellByPosition(24,row).string="STOCK INSUFFISANT"
	else
		feuille.getCellByPosition(24,row).string=" "
	end if
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub POS4_modified'r.
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	dim feuille as object
	dim htnet as double
	dim totht as double
	dim row as integer
	row=selectedRow
	if row<14 then exit sub' global const l =" @
	feuille=ThisComponent.Sheets.getByName("Facturation")
	if feuille.getCellByPosition(0,row).value=0 then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille.unprotect(mypass)
	if feuille.getCellByPosition(12,row).value<0 then
		msgbox("Valeur incorrecte",64,"Modif Remise")
		feuille.getCellByPosition(12,row).value=0
		feuille.getCellByPosition(13,row).value=0
	else
		select case feuille.getCellByPosition(36,row).value'	mode
		case 0,-1' mode bloqué
			if hInput=l then
				feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
			else
				feuille.getCellByPosition(12,row).value= 0
				feuille.getCellByPosition(13,row).value= 0
			end if
		case 1' mode normale
			if feuille.getCellByPosition(12,row).value>0.1 then
				if hInput=l then
					feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
				else
					if feuille.getCellByPosition(14,row).value<0.1 then
						feuille.getCellByPosition(12,row).value=feuille.getCellByPosition(14,row).value
						feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(14,row).value
					else
						feuille.getCellByPosition(12,row).value=0.1
						feuille.getCellByPosition(13,row).value=0.1
					end if
				end if
			else
				if feuille.getCellByPosition(12,row).value>feuille.getCellByPosition(14,row).value then
					if hInput=l then
						feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
					else
						feuille.getCellByPosition(12,row).value=feuille.getCellByPosition(14,row).value
						feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(14,row).value
					end if
				else
					feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
				end if
			end if
		case 2'	max autorisé
			if feuille.getCellByPosition(12,row).value>feuille.getCellByPosition(14,row).value then
				if hInput=l then
					feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
				else
					feuille.getCellByPosition(12,row).value= feuille.getCellByPosition(14,row).value
					feuille.getCellByPosition(13,row).value= feuille.getCellByPosition(14,row).value
				end if
			else
				feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
			end if
		case 3'	gratuit autorisé
			feuille.getCellByPosition(13,row).value=feuille.getCellByPosition(12,row).value
		case else' mode bloqué
			feuille.getCellByPosition(12,row).value=0
			feuille.getCellByPosition(13,row).value=0
		end select
	end if
	if feuille.getCellByPosition(0,row).value>0 then
		htnet=feuille.getCellByPosition(10,row).value/(1+feuille.getCellByPosition(13,row).value)
		feuille.getCellByPosition(15,row).value=htnet'					ht net
		totht=htnet*feuille.getCellByPosition(5,row).value
		select case feuille.getCellByPosition(8,row).value'					n°tva
			case 0
				feuille.getCellByPosition(16,row).value=clng(htnet)'		ttc net
				feuille.getCellByPosition(17,row).value=clng(totht)'		tot ttc
				feuille.getCellByPosition(29,row).value=clng(totht)'		base tva
			case 1
				feuille.getCellByPosition(16,row).value=clng(htnet)+clng(htnet*tva1)'ttc net
				feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva1)'tot ttc
				feuille.getCellByPosition(26,row).value=clng(totht)'		base tva
				feuille.getCellByPosition(30,row).value=clng(totht*tva1)'	tva
			case 2
				feuille.getCellByPosition(16,row).value=clng(htnet)+clng(htnet*tva2)'ttc net
				feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva2)'tot ttc
				feuille.getCellByPosition(27,row).value=clng(totht)'		base tva
				feuille.getCellByPosition(31,row).value=clng(totht*tva2)'	tva
			case 3
				feuille.getCellByPosition(16,row).value=clng(htnet)+clng(htnet*tva3)'ttc net
				feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva3)'tot ttc
				feuille.getCellByPosition(28,row).value=clng(totht)'		base tva
				feuille.getCellByPosition(32,row).value=clng(totht*tva3)'	tva
			case else
				feuille.getCellByPosition(16,row).value=clng(htnet)'		ttc net
				feuille.getCellByPosition(17,row).value=clng(totht)'		tot ttc
				feuille.getCellByPosition(29,row).value=clng(totht)'		base tva
		end select
	end if
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub POS5_modified 'ttc net
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	dim feuille as object
	dim totht as double
	dim tm as double
	dim row as integer
	row=selectedRow
	if row<14 then exit sub' global const l =" @
	feuille=ThisComponent.Sheets.getByName("Facturation")
	if feuille.getCellByPosition(0,row).value=0 then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille.unprotect(mypass)
	if feuille.getCellByPosition(16,row).value<0 then
		msgbox("Valeur incorrecte",64,"Modif ttc")
		feuille.getCellByPosition(12,row).value=0'						r.
		feuille.getCellByPosition(13,row).value=0'
		feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
	else
		feuille.getCellByPosition(12,row).value=0'						r.
		feuille.getCellByPosition(13,row).value=0'						r.
		tm=feuille.getCellByPosition(11,row).value/(feuille.getCellByPosition(16,row).value+1)-1
		select case feuille.getCellByPosition(36,row).value'	mode
		case 0,-1' mode bloqué
			if feuille.getCellByPosition(16,row).value<feuille.getCellByPosition(11,row).value then
				if hInput<>l then
					feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
				end if
			end if
		case 1' mode normale
			if tm>0.1 then
				if hInput<>l then
					feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
				end if
			else
				if tm>feuille.getCellByPosition(14,row).value then
					if hInput<>l then
						feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
					end if
				end if
			end if
		case 2'	max autorisé
			if tm>feuille.getCellByPosition(14,row).value then
				if hInput<>l then
					feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
				end if
			end if
		case 3'	gratuit autorisé
		case else' mode bloqué
			if feuille.getCellByPosition(16,row).value<feuille.getCellByPosition(11,row).value then
				if hInput<>l then
					feuille.getCellByPosition(16,row).value=feuille.getCellByPosition(11,row).value
				end if
			end if
		end select
	end if
	select case feuille.getCellByPosition(8,row).value'					tva
		case 0
			feuille.getCellByPosition(15,row).value=feuille.getCellByPosition(16,row).value'ht net
			feuille.getCellByPosition(16,row).value=clng(feuille.getCellByPosition(15,row).value)'ttc net
			totht=feuille.getCellByPosition(15,row).value*feuille.getCellByPosition(5,row).value
			feuille.getCellByPosition(17,row).value=clng(totht)'		tot ttc
			feuille.getCellByPosition(29,row).value=clng(totht)'		base tva
		case 1
			feuille.getCellByPosition(15,row).value=feuille.getCellByPosition(16,row).value/(1+tva1)'ht net
			feuille.getCellByPosition(16,row).value=clng(feuille.getCellByPosition(15,row).value)+clng(feuille.getCellByPosition(15,row).value*tva1)'ttc net
			totht=feuille.getCellByPosition(15,row).value*feuille.getCellByPosition(5,row).value
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva1)'tot ttc
			feuille.getCellByPosition(26,row).value=clng(totht)'		base tva
			feuille.getCellByPosition(30,row).value=clng(totht*tva1)'	tva
		case 2
			feuille.getCellByPosition(15,row).value=feuille.getCellByPosition(16,row).value/(1+tva2)'ht net
			feuille.getCellByPosition(16,row).value=clng(feuille.getCellByPosition(15,row).value)+clng(feuille.getCellByPosition(15,row).value*tva2)'ttc net
			totht=feuille.getCellByPosition(15,row).value*feuille.getCellByPosition(5,row).value
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva2)'tot ttc
			feuille.getCellByPosition(27,row).value=clng(totht)'		base tva
			feuille.getCellByPosition(31,row).value=clng(totht*tva2)'	tva
		case 3
			feuille.getCellByPosition(15,row).value=feuille.getCellByPosition(16,row).value/(1+tva3)'ht net
			feuille.getCellByPosition(16,row).value=clng(feuille.getCellByPosition(15,row).value)+clng(feuille.getCellByPosition(15,row).value*tva3)'ttc net
			totht=feuille.getCellByPosition(15,row).value*feuille.getCellByPosition(5,row).value
			feuille.getCellByPosition(17,row).value=clng(totht)+clng(totht*tva3)'tot ttc
			feuille.getCellByPosition(28,row).value=clng(totht)'		base tva
			feuille.getCellByPosition(32,row).value=clng(totht*tva3)'	tva
	end select
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

Sub POS6_modified 'payement
	on error goto ErrorHandler
	if ThisComponent.CurrentController.ActiveSheet.name<>"Facturation" then exit sub' global const l =" @
	ThisComponent.lockcontrollers
	stopPosListener
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

sub creditControl
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	if feuille.getCellByPosition(27,5).value then'		client
		if feuille.getCellByPosition(27,2).value then'		client credit
			if feuille.getCellByPosition(12,3).value+feuille.getCellByPosition(3,3).value>feuille.getCellByPosition(27,1).value then
				posBControl("comptant")
				feuille.getCellByPosition(3,4).string="Crédit impossible, plafond atteind"
			else
				posBControl("credit")
				feuille.getCellByPosition(3,4).string="Echéance: "+feuille.getCellByPosition(27,4).string
			end if
		else
			posBControl("comptant")
			feuille.getCellByPosition(3,4).string="Client comptant"
		end if
	else
		posBControl("arret")
	end if
end sub

Sub POS1_disposing
End Sub
Sub POS2_disposing
End Sub
Sub POS3_disposing
End Sub
Sub POS4_disposing
End Sub
Sub POS5_disposing
End Sub
Sub POS6_disposing
End Sub

sub remclient
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim i as integer
	dim lastitem as integer
	dim totht as double
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	i=13
	lastitem=itemcounter
	do while i<lastitem
	do while i<lastitem
		i=i+1
		if feuille.getCellByPosition(0,i).value then
		if feuille.getCellByPosition(13,i).value>=feuille.getCellByPosition(27,0).value then
			exit do
		else
			select case feuille.getCellByPosition(36,i).value'	mode
			case -1,0,3' mode bloqué + gratuit autorisé
				exit do
			case 1,2' mode normale + max autorisé
				if feuille.getCellByPosition(27,0).value>feuille.getCellByPosition(14,i).value then
					feuille.getCellByPosition(12,i).value=feuille.getCellByPosition(14,i).value
					feuille.getCellByPosition(13,i).value=feuille.getCellByPosition(14,i).value
				else
					feuille.getCellByPosition(12,i).value= feuille.getCellByPosition(27,0).value
					feuille.getCellByPosition(13,i).value= feuille.getCellByPosition(27,0).value
				end if
			case else' au cas ou
				feuille.getCellByPosition(12,i).value=0
				feuille.getCellByPosition(13,i).value=0
			end select
			feuille.getCellByPosition(15,i).value=feuille.getCellByPosition(10,i).value/(1+feuille.getCellByPosition(12,i).value)'ht net
			totht=feuille.getCellByPosition(15,i).value*feuille.getCellByPosition(5,i).value
			select case feuille.getCellByPosition(8,i).value'							tva
				case 0
					feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)'					tot ttc
					feuille.getCellByPosition(29,i).value=clng(totht)'					base tva
				case 1
					feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva1)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva1)'	tot ttc
					feuille.getCellByPosition(26,i).value=clng(totht)'					base tva
					feuille.getCellByPosition(30,i).value=clng(totht*tva1)'				tva
				case 2
					feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva2)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva2)'	tot ttc
					feuille.getCellByPosition(27,i).value=clng(totht)'					base tva
					feuille.getCellByPosition(31,i).value=clng(totht*tva2)'				tva
				case 3
					feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva3)'ttc net
					feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva3)'	tot ttc
					feuille.getCellByPosition(28,i).value=clng(totht)'					base tva
					feuille.getCellByPosition(32,i).value=clng(totht*tva3)'				tva
			end select
		end if
		end if
	loop
	loop
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub remautre
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim inputstring as string
	dim inputvalue as double
	dim totht as double
	dim h as string
	dim i as integer
	dim lastitem as integer
	inputstring=InputBox("Taux de marque=?"+chr(13)+"Max sans mot de passe: 10%","Taux de marque",)
	if not IsNumeric(inputstring) then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopPosListener
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.unprotect(mypass)
	inputvalue=vir(inputstring)/100
	if inputvalue>0.1 then
		h=hInput
	else
		h=""
	end if
	i=13
	lastitem=itemcounter
	do while i<lastitem
	do while i<lastitem
		i=i+1
		if feuille.getCellByPosition(0,i).value then
			if feuille.getCellByPosition(13,i).value>=inputvalue then
				exit do
			else
				select case feuille.getCellByPosition(36,i).value'	mode
				case -1,0,3' mode bloqué + gratuit autorisé
					exit do
				case 1' mode normale
					if h=l then
						if inputvalue>feuille.getCellByPosition(14,i).value then
							feuille.getCellByPosition(12,i).value=feuille.getCellByPosition(14,i).value
							feuille.getCellByPosition(13,i).value=feuille.getCellByPosition(14,i).value
						else
							feuille.getCellByPosition(12,i).value= inputvalue
							feuille.getCellByPosition(13,i).value= inputvalue
						end if
					else
						if feuille.getCellByPosition(14,i).value>0.1 then
							if inputvalue>0.1 then
								feuille.getCellByPosition(12,i).value= 0.1
								feuille.getCellByPosition(13,i).value= 0.1
							else
								if inputvalue>feuille.getCellByPosition(14,i).value then
									feuille.getCellByPosition(12,i).value= feuille.getCellByPosition(14,i).value
									feuille.getCellByPosition(13,i).value= feuille.getCellByPosition(14,i).value
								else
									feuille.getCellByPosition(12,i).value= inputvalue
									feuille.getCellByPosition(13,i).value= inputvalue
								end if
							end if
						else
							if inputvalue>feuille.getCellByPosition(14,i).value then
								feuille.getCellByPosition(12,i).value= feuille.getCellByPosition(14,i).value
								feuille.getCellByPosition(13,i).value= feuille.getCellByPosition(14,i).value
							else
								feuille.getCellByPosition(12,i).value= inputvalue
								feuille.getCellByPosition(13,i).value= inputvalue
							end if
						end if
					end if
				case 2'	max autorisé
					if inputvalue>feuille.getCellByPosition(14,i).value then
						feuille.getCellByPosition(12,i).value=feuille.getCellByPosition(14,i).value
						feuille.getCellByPosition(13,i).value=feuille.getCellByPosition(14,i).value
					else
						feuille.getCellByPosition(12,i).value=inputvalue
						feuille.getCellByPosition(13,i).value=inputvalue
					end if
				case else' au cas ou
					feuille.getCellByPosition(12,i).value=0
					feuille.getCellByPosition(13,i).value=0
				end select
				feuille.getCellByPosition(15,i).value=feuille.getCellByPosition(10,i).value/(1+feuille.getCellByPosition(12,i).value)'ht net
				totht=feuille.getCellByPosition(15,i).value*feuille.getCellByPosition(5,i).value
				select case feuille.getCellByPosition(8,i).value'							tva
					case 0
						feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)'ttc net
						feuille.getCellByPosition(17,i).value=clng(totht)'					tot ttc
						feuille.getCellByPosition(29,i).value=clng(totht)'					base tva
					case 1
						feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva1)'ttc net
						feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva1)'	tot ttc
						feuille.getCellByPosition(26,i).value=clng(totht)'					base tva
						feuille.getCellByPosition(30,i).value=clng(totht*tva1)'				tva
					case 2
						feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva2)'ttc net
						feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva2)'	tot ttc
						feuille.getCellByPosition(27,i).value=clng(totht)'					base tva
						feuille.getCellByPosition(31,i).value=clng(totht*tva2)'				tva
					case 3
						feuille.getCellByPosition(16,i).value=clng(feuille.getCellByPosition(15,i).value)+clng(feuille.getCellByPosition(15,i).value*tva3)'ttc net
						feuille.getCellByPosition(17,i).value=clng(totht)+clng(totht*tva3)'	tot ttc
						feuille.getCellByPosition(28,i).value=clng(totht)'					base tva
						feuille.getCellByPosition(32,i).value=clng(totht*tva3)'				tva
				end select
			end if
		end if
	loop
	loop
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	creditControl
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startposListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub tout0
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim i as integer
	dim lastitem as integer
	if hInput=l then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		stopPosListener
		feuille=ThisComponent.Sheets.getByName("Facturation")
		feuille.unprotect(mypass)
		stopPosListener
			i=13
			lastitem=itemcounter
			do while i<lastitem
				i=i+1
				feuille.getCellByPosition(12,i).value=0
				feuille.getCellByPosition(13,i).value=0
				feuille.getCellByPosition(15,i).value=0
				feuille.getCellByPosition(16,i).value=0
				feuille.getCellByPosition(17,i).value=0
				feuille.getCellByPosition(26,i).value=0
				feuille.getCellByPosition(27,i).value=0
				feuille.getCellByPosition(28,i).value=0
				feuille.getCellByPosition(29,i).value=0
				feuille.getCellByPosition(30,i).value=0
				feuille.getCellByPosition(31,i).value=0
				feuille.getCellByPosition(32,i).value=0
			loop
		ThisComponent.calculateAll
		ThisComponent.enableAutomaticCalculation(true)
		creditControl
		feuille.protect(mypass)
		ThisComponent.unlockcontrollers
		startposListener
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub addligne
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	dim feuille as object
	dim i as long
	feuille=ThisComponent.Sheets.getByName("Facturation")
	i=selectedRow
	if 14<i and i<110 then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		stopPosListener
		feuille=ThisComponent.Sheets.getByName("Facturation")
		feuille.unprotect(mypass)
		stopPosListener
		feuille.Rows.InsertByIndex(i,1)
		feuille.Rows.RemoveByIndex(110,1)
		ThisComponent.calculateAll
		ThisComponent.enableAutomaticCalculation(true)
		creditControl
		feuille.protect(mypass)
		ThisComponent.unlockcontrollers
		startposListener
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

sub supprimeligne
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim i as long
	feuille=ThisComponent.Sheets.getByName("Facturation")
	i=selectedRow
	if 110>i and i>13 then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		stopPosListener
		feuille=ThisComponent.Sheets.getByName("Facturation")
		feuille.unprotect(mypass)
		stopPosListener
		feuille.Rows.RemoveByIndex(i,1)
		feuille.Rows.InsertByIndex(110,1)
		ThisComponent.calculateAll
		ThisComponent.enableAutomaticCalculation(true)
		creditControl
		feuille.protect(mypass)
		ThisComponent.unlockcontrollers
		startposListener
	end if
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

function noQError as boolean  'renvoie TRUE si pas d'erreur
	on error goto ErrorHandler
	dim statement as object
	dim result as object
	dim lastitem as integer
	dim feuille as object
	dim i as integer
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.getCellByPosition(3,1).string=charfilter(feuille.getCellByPosition(3,1).string)
	feuille.getCellByPosition(3,5).string=charfilter(feuille.getCellByPosition(3,5).string)
	feuille.getCellByPosition(3,6).string=charfilter(feuille.getCellByPosition(3,6).string)
	feuille.getCellByPosition(3,7).string=charfilter(feuille.getCellByPosition(3,7).string)
	feuille.getCellByPosition(3,8).string=charfilter(feuille.getCellByPosition(3,8).string)
	feuille.getCellByPosition(3,9).string=charfilter(feuille.getCellByPosition(3,9).string)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+feuille.getCellByPosition(27,5).string+"'")
	if not result.next then
		msgbox ("Client non valide",64,"Facturation")
		noQError=false
		exit function' global const l =" @
	end if
	if instr(feuille.getCellByPosition(3,1).string,"?") then
		msgbox ("Client non valide",64,"Facturation")
		noQError=false
		exit function' global const l =" @
	end if
	if lastitem=13 then
		msgbox ("Aucun article à facturer",64,"Facturation")
		noQError=false
		exit function' global const l =" @
	end if
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value then
			if feuille.getCellByPosition(5,i).value=0 then
				msgbox ("Quantité manquante, ligne "+cstr(i+1),64,"Facturation")
				noQError=false
				exit function' global const l =" @
			end if
		end if
		if feuille.getCellByPosition(3,i).string="'non trouvé" then
			msgbox ("Article non trouvé, ligne "+cstr(i+1),64,"Facturation")
			noQError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="DIVERS" then
			msgbox ("Désignation ''DIVERS'' interdit , ligne "+cstr(i+1),64,"Facturation")
			noQError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="" then
			msgbox ("Ligne "+cstr(i+1)+" vide",64,"Facturation")
			noQError=false
			exit function' global const l =" @
		end if
	next i
	noQError=true
	exit function' global const l =" @
	ErrorHandler:
	noQError=false
	recovery
	on error goto 0
end function

function noComptantError as boolean  'renvoie TRUE si pas d'erreur
	on error goto ErrorHandler
	dim statement as object
	dim result as object
	dim lastitem as integer
	dim feuille as object
	dim esp as long
	dim i as integer
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.getCellByPosition(3,1).string=charfilter(feuille.getCellByPosition(3,1).string)
	feuille.getCellByPosition(3,5).string=charfilter(feuille.getCellByPosition(3,5).string)
	feuille.getCellByPosition(3,6).string=charfilter(feuille.getCellByPosition(3,6).string)
	feuille.getCellByPosition(3,7).string=charfilter(feuille.getCellByPosition(3,7).string)
	feuille.getCellByPosition(3,8).string=charfilter(feuille.getCellByPosition(3,8).string)
	feuille.getCellByPosition(3,9).string=charfilter(feuille.getCellByPosition(3,9).string)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+feuille.getCellByPosition(27,5).string+"'")
	if not result.next then
		msgbox ("Client non valide",64,"Facturation")
		noComptantError=false
		exit function' global const l =" @
	end if
	if instr(feuille.getCellByPosition(3,1).string,"?") then
		msgbox ("Client non valide",64,"Facturation")
		noComptantError=false
		exit function' global const l =" @
	end if
	if lastitem=13 then
		msgbox ("Aucun article à facturer",64,"Facturation")
		noComptantError=false
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(3,6).string<>"" and feuille.getCellByPosition(3,7).string="" then
		msgbox ("n° connaissement non renseigné",64,"Facturation")
		noComptantError=false
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(27,6).value<0 then
		msgbox ("Versement insufisant",64,"Facturation")
		noComptantError=false
		exit function' global const l =" @
	end if
	for i=6 to 9
		if feuille.getCellByPosition(12,i).value then if feuille.getCellByPosition(18,i).string="espèce" then esp=esp+feuille.getCellByPosition(12,i).value
	next i
	if feuille.getCellByPosition(27,6).value-esp>5000 then
		if feuille.getCellByPosition(12,3).value>0 then
			msgbox ("Cette entreprise n'est pas une banque !",64,"Facturation")
			noComptantError=false
			exit function' global const l =" @
		end if
	end if
	for i=6 to 9
		if feuille.getCellByPosition(12,i).value then
			if feuille.getCellByPosition(18,i).string="" then
				msgbox ("mode de paiement non renseigné, versement "+cstr(i-4),64,"Facturation")
				noComptantError=false
				exit function' global const l =" @
			end if
			if feuille.getCellByPosition(21,i).value and feuille.getCellByPosition(18,i).string<>"chèque" then
				msgbox ("versement "+cstr(i-5)+" par chèque ?",64,"Facturation")
				noComptantError=false
				exit function' global const l =" @
			end if
			if feuille.getCellByPosition(18,i).string="chèque" and feuille.getCellByPosition(21,i).value=0 then
				msgbox ("Il manque le n° du chèque",64,"Facturation")
				noComptantError=false
				exit function' global const l =" @
			end if
		end if
	next i
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value then
			if feuille.getCellByPosition(5,i).value=0 then
				msgbox ("Quantité manquante, ligne "+cstr(i+1),64,"Facturation")
				noComptantError=false
				exit function' global const l =" @
			end if
		end if
		if feuille.getCellByPosition(3,i).string="'non trouvé" then
			msgbox ("Article non trouvé, ligne "+cstr(i+1),64,"Facturation")
			noComptantError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="DIVERS" then
			msgbox ("Désignation ''DIVERS'' interdit , ligne "+cstr(i+1),64,"Facturation")
			noComptantError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="" then
			msgbox ("Ligne "+cstr(i+1)+" vide",64,"Facturation")
			noComptantError=false
			exit function' global const l =" @
		end if
	next i
	noComptantError=true
	exit function' global const l =" @
	ErrorHandler:
	noComptantError=false
	recovery
	on error goto 0
end function

function nocreditError as boolean  'renvoie TRUE si pas d'erreur
	on error goto ErrorHandler
	dim statement as object
	dim result as object
	dim lastitem as integer
	dim feuille as object
	dim i as integer
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	feuille.getCellByPosition(3,1).string=charfilter(feuille.getCellByPosition(3,1).string)
	feuille.getCellByPosition(3,5).string=charfilter(feuille.getCellByPosition(3,5).string)
	feuille.getCellByPosition(3,6).string=charfilter(feuille.getCellByPosition(3,6).string)
	feuille.getCellByPosition(3,7).string=charfilter(feuille.getCellByPosition(3,7).string)
	feuille.getCellByPosition(3,8).string=charfilter(feuille.getCellByPosition(3,8).string)
	feuille.getCellByPosition(3,9).string=charfilter(feuille.getCellByPosition(3,9).string)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.customer WHERE `id`='"+feuille.getCellByPosition(27,5).string+"'")
	if not result.next then
		msgbox ("Client non valide",64,"Facturation")
		nocreditError=false
		exit function' global const l =" @
	elseif result.getint(10)=0 then
		msgbox ("Pas de crédit pour ce client",64,"Facturation à crédit")
		nocreditError=false
		exit function' global const l =" @
	end if
	if instr(feuille.getCellByPosition(3,1).string,"?") then
		msgbox ("Client non valide",64,"Facturation")
		nocreditError=false
		exit function' global const l =" @
	end if
	if lastitem=13 then
		msgbox ("Aucun article à facturer",64,"Facturation")
		nocreditError=false
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(3,6).string<>"" and feuille.getCellByPosition(3,7).string="" then
		msgbox ("n° connaissement non renseigné",64,"Facturation")
		nocreditError=false
		exit function' global const l =" @
	end if
	dim vers as integer
	vers=feuille.getCellByPosition(12,6).value
	vers=vers+feuille.getCellByPosition(12,7).value
	vers=vers+feuille.getCellByPosition(12,8).value
	vers=vers+feuille.getCellByPosition(12,9).value
	if vers then
		msgbox ("Les paiements de facture crédit se font dans le module 'Client'",64,"Facturation à crédit")
		nocreditError=false
		exit function' global const l =" @
	end if
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value then
			if feuille.getCellByPosition(5,i).value=0 then
				msgbox ("Quantité manquante, ligne "+cstr(i+1),64,"Facturation")
				nocreditError=false
				exit function' global const l =" @
			end if
		end if
		if feuille.getCellByPosition(3,i).string="'non trouvé" then
			msgbox ("Article non trouvé, ligne "+cstr(i+1),64,"Facturation")
			nocreditError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="DIVERS" then
			msgbox ("Désignation ''DIVERS'' interdit , ligne "+cstr(i+1),64,"Facturation")
			nocreditError=false
			exit function' global const l =" @
		end if
		if feuille.getCellByPosition(3,i).string="" then
			msgbox ("Ligne "+cstr(i+1)+" vide",64,"Facturation")
			nocreditError=false
			exit function' global const l =" @
		end if
	next i
	nocreditError=true
	exit function' global const l =" @
	ErrorHandler:
	nocreditError=false
	recovery
	on error goto 0
end function

sub devispost
	if errormode then exit sub' global const l =" @
	if isnull(connection) then exit sub' global const l =" @
	if permission("devis") then
		if noQError then
			if msgbox("Le devis va maintenant ètre enregistré"+chr(13)+"Confirmez-vous ?",65,"Enregistrement")=1 then
				if devisTrError then
					recovery
				else
					ThisComponent.enableAutomaticCalculation(false)
					ThisComponent.lockcontrollers
					stopPosListener
					stopIVListener
					ThisComponent.Sheets.getByName("Facturation").unprotect(mypass)
					poscleaner
					pospreselect
					posBControl("arret")
					ThisComponent.Sheets.getByName("Facturation").protect(mypass)
					ThisComponent.Sheets.getByName("Aff.Facture").unprotect(mypass)
					iDisplay
					ThisComponent.Sheets.getByName("Aff.Facture").protect(mypass)
					ThisComponent.unlockcontrollers
					ThisComponent.calculateAll
					ThisComponent.enableAutomaticCalculation(true)
					startPosListener
					startIVListener
				end if
			end if
		end if
	else
		msgbox("Vous n'êtes pas authorisé à établir des devis",64,"Facturation")
	end if
end sub

sub comptantpost
	if errormode then exit sub' global const l =" @
	if isnull(connection) then exit sub' global const l =" @
	if permission("comptant") then
		if noComptantError then
			if msgbox("La facture va maintenant ètre enregistrée au comptant"+chr(13)+"Confirmez-vous ?",65,"Facturation")=1 then
				if comptantTrError then
					recovery
				else
					ThisComponent.enableAutomaticCalculation(false)
					ThisComponent.lockcontrollers
					stopPosListener
					stopIVListener
					ThisComponent.Sheets.getByName("Facturation").unprotect(mypass)
					poscleaner
					pospreselect
					posBControl("arret")
					ThisComponent.Sheets.getByName("Facturation").protect(mypass)
					ThisComponent.Sheets.getByName("Aff.Facture").unprotect(mypass)
					iDisplay
					ThisComponent.Sheets.getByName("Aff.Facture").protect(mypass)
					ThisComponent.unlockcontrollers
					ThisComponent.calculateAll
					ThisComponent.enableAutomaticCalculation(true)
					startPosListener
					startIVListener
				end if
			end if
		end if
	else
		msgbox("Vous n'êtes pas authorisé à facturer",64,"Facturation")
	end if
end sub

sub creditpost
	if errormode then exit sub' global const l =" @
	if isnull(connection) then exit sub' global const l =" @
	if permission("credit") then
		if nocreditError then
			if msgbox("La facture va maintenant ètre enregistrée à CREDIT"+chr(13)+"Confirmez-vous ?",65,"Facturation")=1 then
				if creditTrError then
					recovery
				else
					ThisComponent.enableAutomaticCalculation(false)
					ThisComponent.lockcontrollers
					stopPosListener
					stopIVListener
					ThisComponent.Sheets.getByName("Facturation").unprotect(mypass)
					poscleaner
					pospreselect
					posBControl("arret")
					ThisComponent.Sheets.getByName("Facturation").protect(mypass)
					ThisComponent.Sheets.getByName("Aff.Facture").unprotect(mypass)
					iDisplay
					ThisComponent.Sheets.getByName("Aff.Facture").protect(mypass)
					ThisComponent.unlockcontrollers
					ThisComponent.calculateAll
					ThisComponent.enableAutomaticCalculation(true)
					startPosListener
					startIVListener
				end if
			end if
		end if
	else
		msgbox("Vous n'êtes pas authorisé à facturer",64,"Facturation")
	end if
end sub

function devisTrError as integer
	on error goto ErrorHandler
	dim feuille as object
	dim statement as object
	dim result as object
	dim requete as string
	dim retour as integer
	dim insertID as integer
	dim lastitem as integer
	dim i as integer
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	statement=connection.CreateStatement
	retour=statement.executeUpdate("START TRANSACTION")
	if feuille.getCellByPosition(27,7).value=0 then
		requete="UPDATE mybase.customer SET lieu='"+feuille.getCellByPosition(3,5).string+"', transport='"+feuille.getCellByPosition(3,6).string+"', contact5='"+feuille.getCellByPosition(3,8).string+"' WHERE `id`="+feuille.getCellByPosition(27,5).value
		retour=statement.executeUpdate(requete)
	end if
	requete="INSERT INTO mybase.devis VALUES(NULL,CURDATE(),'" +user+ "',"+_
	feuille.getCellByPosition(27,5).value+",'"+_
	feuille.getCellByPosition(3,1).string+"','"+_
	feuille.getCellByPosition(3,5).string+"','"+_
	feuille.getCellByPosition(3,6).string+"','"+_
	feuille.getCellByPosition(3,8).string+"','"+_
	feuille.getCellByPosition(3,9).string+"',"+_
	feuille.getCellByPosition(26,12).value+","+_
	feuille.getCellByPosition(27,12).value+","+_
	feuille.getCellByPosition(28,12).value+","+_
	feuille.getCellByPosition(26,11).value+","+_
	feuille.getCellByPosition(27,11).value+","+_
	feuille.getCellByPosition(28,11).value+","+_
	feuille.getCellByPosition(12,3).value+",NULL)"
	retour=statement.executeUpdate(requete)
	if retour=0 then goto ErrorHandler
	result=statement.executequery("SELECT LAST_INSERT_ID()")
	result.next
	insertID=result.getstring(1)
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value=0 then
			requete="INSERT INTO mybase.devisdet VALUES(NULL,"+insertID+",NULL,NULL,'"+feuille.getCellByPosition(3,i).string+"',0,NULL,NULL,NULL,NULL,NULL,NULL)"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
		else
			requete="INSERT INTO mybase.devisdet VALUES(NULL,"+insertID+","+feuille.getCellByPosition(0,i).value+",'"+feuille.getCellByPosition(1,i).string+"','"+feuille.getCellByPosition(3,i).string+"',"+dot(feuille.getCellByPosition(5,i).value)+","+dot(feuille.getCellByPosition(9,i).value)+","+dot(feuille.getCellByPosition(13,i).value)+","+dot(feuille.getCellByPosition(10,i).value)+","+dot(feuille.getCellByPosition(15,i).value)+","+feuille.getCellByPosition(33,i).value+","+feuille.getCellByPosition(34,i).value+")"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
		end if
	next i
	retour=statement.executeUpdate("COMMIT")
	ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0).value=insertID
	devisTrError=0
	exit function' global const l =" @
	ErrorHandler:
	retour=statement.executeUpdate("ROLLBACK")
	devisTrError=1
	on error goto 0
end function

function comptantTrError as integer
	on error goto ErrorHandler
	dim feuille as object
	dim statement as object
	dim result as object
	dim requete as string
	dim retour as integer
	dim insertID as integer
	dim lastitem as integer
	dim i as integer
	dim echeance as date
	dim vers(6 to 9) as long
	dim mode(6 to 9) as integer
	dim chq(6 to 9) as long
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	for i=6 to 9
		if feuille.getCellByPosition(12,i).value then
			vers(i)=cstr(clng(feuille.getCellByPosition(12,i).value))
			select case feuille.getCellByPosition(18,i).string
				case "espèce": mode(i)=1
				case "chèque": mode(i)=2
				case "carte": mode(i)=3
				case "virement": mode(i)=4
				case "mandat": mode(i)=5
			end select
			chq(i)=feuille.getCellByPosition(21,i).value
		end if
	next i
	statement=connection.CreateStatement
	retour=statement.executeUpdate("START TRANSACTION")
	if feuille.getCellByPosition(27,7).value=0 then
		requete="UPDATE mybase.customer SET lieu='"+feuille.getCellByPosition(3,5).string+"', transport='"+feuille.getCellByPosition(3,6).string+"', contact5='"+feuille.getCellByPosition(3,8).string+"' WHERE `id`="+feuille.getCellByPosition(27,5).value
		retour=statement.executeUpdate(requete)
	end if
	requete="INSERT INTO mybase.fact VALUES(NULL,NOW(),'" +user+ "',"+_
	feuille.getCellByPosition(27,5).value+",'"+_
	feuille.getCellByPosition(3,2).string+"','"+_
	feuille.getCellByPosition(3,1).string+"','"+_
	feuille.getCellByPosition(3,5).string+"','"+_
	feuille.getCellByPosition(3,6).string+"','"+_
	feuille.getCellByPosition(3,9).string+"',"+_
	feuille.getCellByPosition(12,3).value+","+_
	feuille.getCellByPosition(26,11).value+","+_
	feuille.getCellByPosition(27,11).value+","+_
	feuille.getCellByPosition(28,11).value+","+_
	vers(6)+","+vers(7)+","+vers(8)+","+vers(9)+","+_
	mode(6)+","+mode(7)+","+mode(8)+","+mode(9)+","+_
	feuille.getCellByPosition(12,10).value+",1,NULL,'',0,'"+_
	feuille.getCellByPosition(3,8).string+"',"+_
	chq(6)+","+chq(7)+","+chq(8)+","+chq(9)+",'"+_
	feuille.getCellByPosition(3,7).string+"',"+_
	feuille.getCellByPosition(26,12).value+","+_
	feuille.getCellByPosition(27,12).value+","+_
	feuille.getCellByPosition(28,12).value+","+_
	feuille.getCellByPosition(30,12).value+")"
	retour=statement.executeUpdate(requete)
	if retour=0 then goto ErrorHandler
	result=statement.executequery("SELECT LAST_INSERT_ID()")
	result.next
	insertID=result.getstring(1)
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value=0 then' com
			requete="INSERT INTO mybase.factdet VALUES(NULL,"+insertID+",CURDATE(),"+feuille.getCellByPosition(27,5).value+",'"+feuille.getCellByPosition(3,1).string+"',NULL,NULL,'"+feuille.getCellByPosition(3,i).string+"',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
		else
			requete="INSERT INTO mybase.factdet VALUES(NULL,"+insertID+",CURDATE(),"+feuille.getCellByPosition(27,5).value+",'"+feuille.getCellByPosition(3,1).string+"',"+feuille.getCellByPosition(0,i).value+",'"+feuille.getCellByPosition(1,i).string+"','"+feuille.getCellByPosition(3,i).string+"','"+dot(feuille.getCellByPosition(5,i).value)+"','"+dot(feuille.getCellByPosition(9,i).value)+"','"+dot(feuille.getCellByPosition(13,i).value)+"','"+dot(feuille.getCellByPosition(10,i).value)+"','"+dot(feuille.getCellByPosition(15,i).value)+"',"+feuille.getCellByPosition(33,i).value+","+feuille.getCellByPosition(34,i).value+",'"+dot(feuille.getCellByPosition(35,i).value)+"',"+feuille.getCellByPosition(8,i).value+")"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
			requete="UPDATE mybase.stk SET qte=qte-'"+dot(feuille.getCellByPosition(5,i).value)+"' WHERE `refint`="+feuille.getCellByPosition(0,i).value
			retour=statement.executeUpdate(requete)
		end if
	next i
	retour=statement.executeUpdate("COMMIT")
	ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0).value=insertID
	comptantTrError=0
	exit function' global const l =" @
	ErrorHandler:
	retour=statement.executeUpdate("ROLLBACK")
	comptantTrError=1
	on error goto 0
end function

function creditTrError as integer
	on error goto ErrorHandler
	dim feuille as object
	dim statement as object
	dim result as object
	dim requete as string
	dim retour as integer
	dim insertID as integer
	dim lastitem as integer
	dim i as integer
	dim echeance as date
	dim nextmonth as date
	lastitem=itemcounter
	feuille=ThisComponent.Sheets.getByName("Facturation")
	statement=connection.CreateStatement
	select case left(feuille.getCellByPosition(27,4).string,1)
	case "F"
		echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",1,date)),15)
	case "1"
		if day(date)<15 then
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",1,date)),15)
		else
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",2,date)),15)
		end if
	case "2"
		if day(date)<15 then
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",2,date)),15)
		else
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",3,date)),15)
		end if
	case "3"
		if day(date)<15 then
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",3,date)),15)
		else
			echeance=dateserial(year(dateadd("m",1,date)),month(dateadd("m",4,date)),15)
		end if
	case else
		msgbox("Fiche client incomplète"+chr(13)+"Enregistrement annulé",64,"Facturation")
		goto ErrorHandler
	end select
	retour=statement.executeUpdate("START TRANSACTION")
	if feuille.getCellByPosition(27,7).value=0 then
		requete="UPDATE mybase.customer SET lieu='"+feuille.getCellByPosition(3,5).string+"', transport='"+feuille.getCellByPosition(3,6).string+"', contact5='"+feuille.getCellByPosition(3,8).string+"' WHERE `id`="+feuille.getCellByPosition(27,5).string
		retour=statement.executeUpdate(requete)	
	end if
	requete="INSERT INTO mybase.fact VALUES(NULL,NOW(),'" +user+ "',"+_
	feuille.getCellByPosition(27,5).string+",'"+_
	feuille.getCellByPosition(3,2).string+"','"+_
	feuille.getCellByPosition(3,1).string+"','"+_
	feuille.getCellByPosition(3,5).string+"','"+_
	feuille.getCellByPosition(3,6).string+"','"+_
	feuille.getCellByPosition(3,9).string+"',"+_
	feuille.getCellByPosition(12,3).value+","+_
	feuille.getCellByPosition(26,11).value+","+_
	feuille.getCellByPosition(27,11).value+","+_
	feuille.getCellByPosition(28,11).value+ _
	",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,2,'"+dateToSQL(echeance)+"','',0,'"+_
	feuille.getCellByPosition(3,8).string+"',NULL,NULL,NULL,NULL,'"+_
	feuille.getCellByPosition(3,7).string+"',"+_
	feuille.getCellByPosition(26,12).value+","+_
	feuille.getCellByPosition(27,12).value+","+_
	feuille.getCellByPosition(28,12).value+","+_
	feuille.getCellByPosition(30,12).value+")"
	retour=statement.executeUpdate(requete)
	if retour=0 then goto ErrorHandler
	result=statement.executequery("SELECT LAST_INSERT_ID()")
	result.next
	insertID=result.getstring(1)
	for i=14 to lastitem
		if feuille.getCellByPosition(0,i).value=0 then' com
			requete="INSERT INTO mybase.factdet VALUES(NULL,"+insertID+",CURDATE(),"+feuille.getCellByPosition(27,5).value+",'"+feuille.getCellByPosition(3,1).string+"',NULL,NULL,'"+feuille.getCellByPosition(3,i).string+"',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
		else
			requete="INSERT INTO mybase.factdet VALUES(NULL,"+insertID+",CURDATE(),"+feuille.getCellByPosition(27,5).value+",'"+feuille.getCellByPosition(3,1).string+"',"+feuille.getCellByPosition(0,i).value+",'"+feuille.getCellByPosition(1,i).string+"','"+feuille.getCellByPosition(3,i).string+"','"+dot(feuille.getCellByPosition(5,i).value)+"','"+dot(feuille.getCellByPosition(9,i).value)+"','"+dot(feuille.getCellByPosition(13,i).value)+"','"+dot(feuille.getCellByPosition(10,i).value)+"','"+dot(feuille.getCellByPosition(15,i).value)+"',"+feuille.getCellByPosition(33,i).value+","+feuille.getCellByPosition(34,i).value+",'"+dot(feuille.getCellByPosition(35,i).value)+"',"+feuille.getCellByPosition(8,i).value+")"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto ErrorHandler
			requete="UPDATE mybase.stk SET qte=qte-'"+dot(feuille.getCellByPosition(5,i).value)+"' WHERE `refint`="+feuille.getCellByPosition(0,i).value
			retour=statement.executeUpdate(requete)
		end if
	next i
	retour=statement.executeUpdate("COMMIT")
	ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0).value=insertID
	creditTrError=0
	exit function' global const l =" @
	ErrorHandler:
	retour=statement.executeUpdate("ROLLBACK")
	creditTrError=1
	on error goto 0
end function

function itemcounter as integer
	dim counter as integer
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Facturation")
	counter=114
	while feuille.getCellByPosition(3,counter).formula=""
		counter=counter-1
	wend
	itemcounter=counter
end function
