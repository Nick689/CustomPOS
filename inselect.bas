Option Explicit

global inListener1 as object
global inListener2 as object
global inRange1 as object
global inRange2 as object

sub incleanerButton
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Entrée")
	if msgbox("Etes-vous sûr de vouloir tout effacer ?",65,"Effacement")=1 then
		ThisComponent.enableAutomaticCalculation(false)
		stopInListener
		feuille.unprotect(mypass)
		incleaner
		inBControl("standby")
		feuille.protect(mypass)
		ThisComponent.calculateAll
		ThisComponent.enableAutomaticCalculation(true)
		startInListener
	end if
end sub

sub incleaner
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Entrée")
	feuille.getCellRangeByPosition(2,1,2,6).clearContents(flag)
	feuille.getCellRangeByPosition(0,8,20,200).clearContents(flag)
	feuille.getCellByPosition(3,3).string=" "
	ThisComponent.CurrentController.Select(ThisComponent.Sheets.getByName("Entrée").getCellByPosition(2,3))
	dim oRanges
	oRanges=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
  	ThisComponent.CurrentController.Select(oRanges)
end sub

sub inBControl(mode as string)
	dim validButton as object
	dim verifButton as object
	dim inForm as object
	dim perm as boolean
	perm=permission("entree")
	inForm=ThisComponent.Sheets.getByName("Entrée").DrawPage.Forms(0)
	validButton=inForm.getByName("valider")
	verifButton=inForm.getByName("verifier")
	select case mode
	case "arret"
		validButton.Enabled=False
		verifButton.Enabled=False
	case "standby"
		validButton.Enabled=False
		verifButton.Enabled=perm
	case "deposable"
		validButton.Enabled=perm
		verifButton.Enabled=perm
	end select
end sub

sub startInListener
	if errormode then exit sub' global const l =" @
	inRange1=ThisComponent.Sheets.getByName("Entrée").getCellRangeByPosition(3,8,3,153)
	inListener1=CreateUnoListener("IN1_","com.sun.star.util.XModifyListener")
	inRange1.addModifyListener(inListener1)
	inRange2=ThisComponent.Sheets.getByName("Entrée").getCellByPosition(2,3)
	inListener2=CreateUnoListener("IN2_","com.sun.star.util.XModifyListener")
	inRange2.addModifyListener(inListener2)
	inBControl("standby")
end sub

Sub stopInListener
	On Error Resume Next
	inRange1.removeModifyListener(inListener1)
	inRange2.removeModifyListener(inListener2)
End Sub

Sub IN1_modified 'product add
	on error goto ErrorHandler
	if ThisComponent.CurrentController.ActiveSheet.name<>"Entrée" then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim inputString as string
	dim requete as string
	dim blankArray(100) as string
	dim i as integer
	dim htpub as double
	dim ttc as long
	dim inRow as integer
	inRow=selectedRow
	if inRow<8 then exit sub' global const l =" @
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopInListener	
	feuille=ThisComponent.Sheets.getByName("Entrée")
	feuille.unprotect(mypass)
	inputString=feuille.getCellByPosition(3,inRow).string
	do
		select case left(inputString,1)
		case ""
			gosub inRowCleaner
		case "'"
			gosub inRowCleaner
			feuille.getCellByPosition(3,inRow).string="Commentaires non autorisés ici"
		case else
			inputString=ucase(charfilter(inputString))
			statement=connection.CreateStatement
			result=statement.executequery("SELECT * FROM mybase.stk WHERE `refmag`='"+inputString+"' OR `codebar`='"+inputString+"' OR `reffourn`='"+inputString+"' OR `ref5`='"+inputString+"' OR `ref6`='"+inputString+"'")
			if result.next then
				inputString=result.getstring(1)
			else
				result=statement.executequery("SELECT * FROM mybase.stk WHERE `design` LIKE '"+inputString+"%' LIMIT 100")
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
					showprodDialog
					if dialogChoice=-1 or dialogChoice>=i then
						inputString=""
					else
						inputString=selectIdArray(dialogChoice)
					end if
				end if
			end if
			if inputString="" then
				gosub inRowCleaner
				feuille.getCellByPosition(3,inRow).string="non trouvé"
			else
				result=statement.executequery("SELECT * FROM mybase.stk WHERE `refint`="+inputString)
				result.next
				feuille.getCellByPosition(0,inRow).value=result.getstring(1)		'ref int
				feuille.getCellByPosition(1,inRow).string=result.getstring(2)		'ref mag
				feuille.getCellByPosition(2,inRow).string=result.getstring(4)		'ref fourn
				feuille.getCellByPosition(3,inRow).string=result.getstring(8)		'Désignation
				feuille.getCellByPosition(8,inRow).value=result.getstring(14)		'anc qté
				htpub=result.getstring(23)
				select case result.getstring(19)
					case 0
						feuille.getCellByPosition(9,inRow).value=clng(htpub)
					case 1
						feuille.getCellByPosition(9,inRow).value=clng(htpub)+clng(htpub*tva1)
						feuille.getCellByPosition(13,inRow).value=tva1
					case 2
						feuille.getCellByPosition(9,inRow).value=clng(htpub)+clng(htpub*tva2)
						feuille.getCellByPosition(13,inRow).value=tva2
					case 3
						feuille.getCellByPosition(9,inRow).value=clng(htpub)+clng(htpub*tva3)
						feuille.getCellByPosition(13,inRow).value=tva3
				end select
				feuille.getCellByPosition(10,inRow).value=result.getstring(20)	'remise max
				feuille.getCellByPosition(12,inRow).string=result.getstring(18)	'régime
			end if
		end select
		inRow=inRow+1
		inputString=feuille.getCellByPosition(3,inRow).string
	loop while feuille.getCellByPosition(0,inRow).value=0 and inputString<>""
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	startInListener
	exit sub' global const l =" @
	inRowCleaner:
		feuille.getCellRangeByPosition(0,inRow,14,inRow).clearContents(flag)
	Return
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub IN2_modified 'set fourn
	on error goto ErrorHandler
	if ThisComponent.CurrentController.ActiveSheet.name<>"Entrée" then exit sub' global const l =" @
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim inputString as string
	dim requete as string
	dim i as integer
	dim blankArray(100) as string
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopInListener
	feuille=ThisComponent.Sheets.getByName("Entrée")
	feuille.unprotect(mypass)
	inputString=ucase(charfilter(feuille.getCellByPosition(2,3).string))
	statement=connection.CreateStatement
	if inputString="" then
		feuille.getCellByPosition(3,3).string=" "
	else
		result=statement.executequery("SELECT * FROM mybase.fourn WHERE `id`='"+inputString+"'")
		if not result.next then
			result=statement.executequery("SELECT * FROM mybase.fourn WHERE `nom` LIKE '"+inputString+"%'")
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
		if inputString="" then
			feuille.getCellByPosition(3,3).string="INCONNU"
		else
			result=statement.executequery("SELECT * FROM mybase.fourn WHERE `id`='"+inputString+"'")
			result.next
			feuille.getCellByPosition(2,3).string=result.getstring(1)
			feuille.getCellByPosition(3,3).string=result.getstring(2)
		end if
	end if
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	startInListener
	exit sub' global const l =" @
	ErrorHandler:
		msgbox("Un problème inconnu est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Recherche fournisseur")
	on error goto 0
End Sub

Sub IN1_disposing
End Sub

Sub IN2_disposing
End Sub

function noError as boolean  'renvoie 0 si pas d'erreur
	dim i as integer
	dim j as integer
	dim lastinput as integer
	dim feuille as object
	dim errorRow as integer
	dim warning as integer
	noError=false
	lastinput=lastitem
	feuille=ThisComponent.Sheets.getByName("Entrée")
	if feuille.getCellByPosition(2,1).string <> "" then
		msgbox ("Bon déjà enregistré !",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(3,3).string="INCONNU" then
		msgbox ("Fournisseur inconnu",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(3,3).string="" then
		msgbox ("Fournisseur inconnu",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(3,3).string=" " then
		msgbox ("Fournisseur inconnu",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(2,6).string="" then
		msgbox ("n° facture manquante",64,"Vérification")
		exit function' global const l =" @
	end if
	for i=8 to lastinput
		errorRow=i+1
		if feuille.getCellByPosition(0,i).value=0 then
			msgbox ("Référence manquante, ligne: "+ErrorRow,64,"Vérification")
			exit function' global const l =" @
		end if
		for j=4 to 6
			if feuille.getCellByPosition(j,i).value=0 then
				msgbox ("Un prix ou une quantité est manquante, ligne: "+ErrorRow,64,"Vérification")
				exit function' global const l =" @
			end if
		next j
		if feuille.getCellByPosition(6,i).value<(feuille.getCellByPosition(5,i).value*(1+feuille.getCellByPosition(13,i).value)) then
			msgbox ("Vente à perte, ligne: "+ErrorRow,64,"Vérification")
			warning=warning+1
		end if
		if feuille.getCellByPosition(11,i).value<0 then
			msgbox ("Vente à perte si remise max apliquée en ligne: "+ErrorRow,64,"Vérification")
			warning=warning+1
		end if
	next i
	if feuille.getCellByPosition(2,4).value=0 then
		msgbox ("Total facture non saisie",64,"Vérification")
		exit function' global const l =" @
	elseif abs(feuille.getCellByPosition(2,5).value-feuille.getCellByPosition(2,4).value)> 10 then
		msgbox ("Les totaux ne correspondent pas",64,"Vérification")
		exit function' global const l =" @
	end if
	noError=true
	inBControl("deposable")
	msgbox("Pas d'erreur grave détectée"+chr(13)+cstr(warning)+" Warning",64,"Vérification")
end function

sub inpost
	if errormode then exit sub' global const l =" @
	if isnull(connection) then exit sub' global const l =" @
	dim feuille as object
	dim statement as object
	dim result as object
	ThisComponent.enableAutomaticCalculation(false)
	stopInListener
	feuille=ThisComponent.Sheets.getByName("Entrée")
	if noError then
		if msgbox("Confirmation de l'enregistrement",65,"Validation")=1 then
			if intransacError then	
				recovery
			else
				inBControl("standby")
				statement=connection.CreateStatement
				result=statement.executequery("SELECT LAST_INSERT_ID()")
				result.next
				feuille.getCellByPosition(2,1).value=result.getstring(1)
				feuille.getCellByPosition(2,2).value=date
				msgbox("La saisie est enregistrée correctement"+chr(13)+"N'oubliez pas de tout effacer",64,"Validation")
			end if
		end if
	end if
	ThisComponent.enableAutomaticCalculation(true)
	startInListener
end sub

function intransacError as integer
	on error goto ErrorHandler
	dim feuille as object
	dim statement as object
	dim result as object
	dim requete as string
	dim fourn as string
	dim ht as string
	dim nouvqte as string
	dim nouvpond as string
	dim nouvrev as double
	dim ancqte as double
	dim ancpond as double
	dim arrivqte as double
	dim ancht as double
	dim refint as integer
	dim retour as integer
	dim insertID as integer
	dim lastinput as integer
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Entrée")
	fourn=feuille.getCellByPosition(2,3).string
	lastinput=lastitem
	intransacError=1
	if permission("entree") then
		intransacError=2
		statement=connection.CreateStatement
		retour=statement.executeUpdate("START TRANSACTION")
		intransacError=3
		retour=statement.executeUpdate("INSERT INTO mybase.entree VALUES(NULL,CURDATE(),"+fourn+",'"+feuille.getCellByPosition(3,3).string+"','"+feuille.getCellByPosition(2,6).string+"','"+dot(feuille.getCellByPosition(2,4).value)+"')")
		if retour=0 then goto Errormsg
		result=statement.executequery("SELECT LAST_INSERT_ID()")
		result.next
		insertID=result.getstring(1)
		for i=8 to lastinput
			arrivqte=feuille.getCellByPosition(4,i).value
			nouvrev=feuille.getCellByPosition(5,i).value
			refint=feuille.getCellByPosition(0,i).value
			ht=dot(feuille.getCellByPosition(6,i).value/(1+feuille.getCellByPosition(13,i).value))
			result=statement.executequery("SELECT `qte`,`revpond`,`ht` FROM mybase.stk WHERE `refint`="+refint)
			if not result.next then goto Errormsg
			ancqte=result.getstring(1)
			nouvqte=dot(ancqte+arrivqte)
			ancpond=result.getstring(2)
			ancht=result.getstring(3)
			if ancqte<1 then
				nouvpond=dot((abs(arrivqte)*nouvrev)/abs(arrivqte))
			else
				nouvpond=dot((abs(ancqte)*ancpond+abs(arrivqte)*nouvrev)/(abs(ancqte)+abs(arrivqte)))
			end if
			'												    1        2          3          4                           5                                 6                  7               8                  9               10                11
			requete="INSERT INTO mybase.entreedet VALUES(NULL,"+insertID+",CURDATE(),"+refint+",'"+feuille.getCellByPosition(3,i).string+"','"+dot(arrivqte)+"','"+dot(nouvrev)+"','"+dot(ht)+"','"+dot(ancqte)+"','"+dot(ancpond)+"','"+dot(ancht)+"')"
			retour=statement.executeUpdate(requete)
			if retour=0 then goto Errormsg
			requete="UPDATE mybase.stk SET `fourn`="+fourn+",`qte`='"+dot(nouvqte)+"',`derrev`='"+dot(nouvrev)+"',`revpond`='"+nouvpond+"',`ht`='"+ht+"' WHERE `refint`="+refint
			retour=statement.executeUpdate(requete)
			retour=statement.executeUpdate("COMMIT")
		next i
		intransacError=0
		exit function' global const l =" @
	else
		intransacError=2
		goto Errormsg
	end if
	Errormsg:
	select case intransacError
	case 1
		msgbox("Problème de connexion"+chr(13)+"Enregistrement impossible",64,"Validation")
	case 2
		msgbox("Vous n'êtes pas authorisé à faire des saisies",64,"Validation")
	case 3
		retour=statement.executeUpdate("ROLLBACK")
		msgbox("Les données sont invalides"+chr(13)+"L'enregistrement a été annulé"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Validation")
	end select
	exit function' global const l =" @
	ErrorHandler:
	if intransacError>2 then
		retour=statement.executeUpdate("ROLLBACK")
	else
		intransacError=1
	end if
	on error goto 0
end function

function lastitem as integer
	dim counter as integer
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Entrée")
	counter=154
	while counter>7 and feuille.getCellByPosition(0,counter).value=0
		counter=counter-1
	wend
	lastitem=counter
end function
