Option Explicit

global payListener as object
global payRange as object

sub paycleanerButton
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Reglement")
	stopPayListener
	feuille.unprotect(mypass)
	paycleaner
	feuille.protect(mypass)
	startPayListener
end sub

sub paycleaner
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Reglement")
	feuille.getCellRangeByPosition(1,1,1,6).clearContents(flag)
	feuille.getCellRangeByPosition(0,10,2,100).clearContents(flag)
	feuille.getCellByPosition(3,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(1,1))
end sub

sub startPayListener
	if errormode then exit sub' global const l =" @
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Reglement")
	payRange=feuille.getCellByPosition(1,1)
	payListener=CreateUnoListener("pay_","com.sun.star.util.XModifyListener")
	payRange.addModifyListener(payListener)
end sub

Sub stopPayListener
	On Error Resume Next
	payRange.removeModifyListener(payListener)
End Sub

Sub pay_modified 'set customer
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if ThisComponent.CurrentController.ActiveSheet.name<>"Reglement" then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	stopPayListener
	dim feuille as object
	dim result as object
	dim retour as integer
	dim statement as object
	dim inputString as string
	dim i as integer
	dim blankArray(100) as string
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Reglement")
	feuille.unprotect(mypass)
	statement=connection.CreateStatement
	inputString=ucase(charfilter(feuille.getCellByPosition(1,1).string))
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
		paycleaner
		feuille.getCellByPosition(1,2).string="non trouvé"
	else
		paycleaner
		result=statement.executequery("SELECT `nom` FROM mybase.customer WHERE `id`="+inputString)
		result.next
		feuille.getCellByPosition(1,1).value=inputString
		feuille.getCellByPosition(1,2).string=result.getstring(1)'	nom
		result=statement.executequery("SELECT * FROM mybase.fact WHERE `numclient`="+inputString+" AND `typefact`='CRÉDIT' AND `lettre`=''")
		i=10
		while result.next
			feuille.getCellByPosition(0,i).value=dateTimeFromSQL(result.getstring(2))'date
			feuille.getCellByPosition(1,i).value=result.getstring(1)'n°fact
			feuille.getCellByPosition(2,i).value=result.getstring(10)'ttc
			i=i+1
		wend
	end if
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	startPayListener
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
End Sub

Sub pay_disposing
End Sub

function noPayError as boolean
	dim feuille as object
	noPayError=false
	feuille=ThisComponent.Sheets.getByName("Reglement")
	if feuille.getCellByPosition(1,1).string="" then
		msgbox ("Client non valide",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(1,2).string="non trouvé" then
		msgbox ("Client non valide",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(1,3).value=0 then
		msgbox ("Montant versé non saisie",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(1,4).string="" then
		msgbox ("Mode de payement non saisie",64,"Vérification")
		exit function' global const l =" @
	end if
	if feuille.getCellByPosition(1,4).string="CHQ" and feuille.getCellByPosition(1,5).value=0 then
		msgbox ("Il manque le n° du chèque",64,"Vérification")
		exit function' global const l =" @
	end if
	noPayError=true
end function

sub validSelected
	dim numfacture as long
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Reglement")
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	if permission("reglement") then
		numfacture=ThisComponent.CurrentController.ActiveSheet.getCellByPosition(1,selectedRow).Value
		if noPayError then
			if selectedRow>9 and numfacture then
				if msgbox("Le réglement va maintenant ètre enregistré"+chr(13)+"Confirmez-vous ?",65,"Enregistrement")=1 then
					ThisComponent.enableAutomaticCalculation(false)
					ThisComponent.lockcontrollers
					stopPayListener
					if payPosted(numfacture) then
						feuille.unprotect(mypass)
						paycleaner
						feuille.protect(mypass)
						ThisComponent.unlockcontrollers
						ThisComponent.calculateAll
						ThisComponent.enableAutomaticCalculation(true)
						feuille.getCellByPosition(3,1).string="Règlement enregistré correctement"
					else
						feuille.protect(mypass)
						ThisComponent.unlockcontrollers
						ThisComponent.calculateAll
						ThisComponent.enableAutomaticCalculation(true)
						feuille.getCellByPosition(3,1).string="Un problème est survenu, règlement annulé"
					end if
					startPayListener
				end if
			else
				msgbox("Vous n'avez pas sélectionné de facture !",64,"Réglement")
			end if
		end if
	else
		msgbox("Vous n'êtes pas autorisé à saisir des réglements",64,"Réglement")
	end if
end sub

function payPosted(numfacture as long) as boolean
	on error goto ErrorHandler
	dim feuille as object
	dim statement as object
	dim result as object
	dim requete as string
	dim retour as integer
	feuille=ThisComponent.Sheets.getByName("Reglement")
	statement=connection.CreateStatement
	retour=statement.executeUpdate("START TRANSACTION")
	requete="INSERT INTO mybase.regl VALUES(NULL,CURDATE(),"+_
	feuille.getCellByPosition(1,1).value+",'"+_
	feuille.getCellByPosition(1,4).string+"',"+_
	feuille.getCellByPosition(1,3).value+","+_
	cstr(numfacture)+",'','"+_
	user+"','"+_
	feuille.getCellByPosition(1,2).string+"',"+_
	feuille.getCellByPosition(1,6).value+","+_
	feuille.getCellByPosition(1,5).value+")"
	retour=statement.executeUpdate(requete)
	if retour=0 then goto ErrorHandler
	retour=statement.executeUpdate("COMMIT")
	payPosted=1
	exit function' global const l =" @
	ErrorHandler:
	retour=statement.executeUpdate("ROLLBACK")
	payPosted=0
	on error goto 0
end function
