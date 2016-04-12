Option Explicit

global source as object
global connection as object
global user as string
global const A4printer="PRINTER1"
global const ticketPrinter="PRINTER2"
global const barcodePrinter="PRINTER2"
global const pricePrinter="PRINTER2"
global const bureauURL="file:///home/mycomputer/Bureau/"
global const balanceURL="file:///home/mycomputer/Bureau/CustomPOS/nBalance.ots"
global const tva1=0.16
global const tva2=0.13
global const tva3=0.05
global const quotevalidity=30
global selectNameArray(100) as string
global selectIdArray(100) as long
global dialogChoice as integer
global listboxDialog as object
global const flag=7
global const misc=100
global const mypass=""
global errormode as boolean

sub signal(msg as string)
	ThisComponent.Sheets.getByName("Facturation").getCellByPosition(12,0).String=msg
	ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(10,0).String=msg
	ThisComponent.Sheets.getByName("Factures").getCellByPosition(8,0).String=msg
	ThisComponent.Sheets.getByName("Devis").getCellByPosition(5,0).String=msg
	ThisComponent.Sheets.getByName("Articles").getCellByPosition(9,0).String=msg
	ThisComponent.Sheets.getByName("Clients").getCellByPosition(5,0).String=msg
	ThisComponent.Sheets.getByName("Reglement").getCellByPosition(3,0).String=msg
	ThisComponent.Sheets.getByName("FDJ").getCellByPosition(6,0).String=msg
	ThisComponent.Sheets.getByName("Entrée").getCellByPosition(8,0).String=msg
	ThisComponent.Sheets.getByName("Ventes").getCellByPosition(5,0).String=msg
end sub

sub disconnectButton
	On Error Resume Next
	connection.close
	connection=nothing
	ThisComponent.lockcontrollers
	ThisComponent.Sheets.getByName("Entrée").unprotect(mypass)
	inBControl("arret")
	ThisComponent.Sheets.getByName("Facturation").unprotect(mypass)
	posBControl("arret")
	signal("Déconnecté")
	ThisComponent.Sheets.getByName("Reglement").isVisible=false
	ThisComponent.Sheets.getByName("Ventes").isVisible=false
	ThisComponent.Sheets.getByName("Entrée").isVisible=false
	ThisComponent.Sheets.getByName("FDJ").isVisible=false
	ThisComponent.Sheets.getByName("Liste.Entrées").isVisible=false
	protectAll
	ThisComponent.unlockcontrollers
end sub

sub connectButton
	if errormode then exit sub' global const l =" @
	if notconnected then inBControl("arret")
end sub

function notconnected as boolean
	on error goto ErrorHandler
	dim result as object
	dim statement as object
	dim h as string
	if isnull(connection) then
		user=lcase(charfilter(inputbox("Login ?","Connexion",)))
		if user ="" then
			connection=nothing
			signal("Déconnecté")
			notconnected=true
			exit function
		else
			h=mypass+charfilter(hInput)
			source=createUnoService("com.sun.star.sdb.DatabaseContext").GetByName("mybase")
			connection=source.getconnection(user,h)
			signal(username(user)+" est connecté")
		end if
	end if
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.utilisateur WHERE `id`='"+user+ "'")
	result.next
	ThisComponent.Sheets.getByName("Reglement").isVisible=result.getboolean(7)
	ThisComponent.Sheets.getByName("Ventes").isVisible=result.getboolean(6)
	ThisComponent.Sheets.getByName("Entrée").isVisible=result.getboolean(9)
	ThisComponent.Sheets.getByName("Liste.Entrées").isVisible=result.getboolean(9)
	ThisComponent.Sheets.getByName("FDJ").isVisible=result.getboolean(11)
	notconnected=false
	exit function' global const l =" @
	ErrorHandler:
		notconnected=true
		connection=nothing
		signal("Déconnecté")
		if Err=1 then
			msgbox("Vos identifiants ne sont pas correct",64,"Connexion")
		else
			msgbox("Problem de connexion",64,"Connexion")
		end if
	on error goto 0
end function

Sub hInput as string
	dim oDialog as object
	dim oDialogModel as object
	dim oEditModel as object
	dim oOKButton as object
	dim oCancelButton as object
	oDialog=CreateUnoService("com.sun.star.awt.UnoControlDialog")
	oDialogModel=CreateUnoService("com.sun.star.awt.UnoControlDialogModel")
	oDialogModel.setPropertyValues(Array("Height","PositionX","PositionY","Title","Width"),Array(50,30,30,"Input Password",100))
	oDialog.setModel(oDialogModel)
	oEditModel=oDialogModel.createInstance("com.sun.star.awt.UnoControlEditModel")
	oEditModel.setPropertyValues(Array("EchoChar","Height","PositionX","PositionY","Width"),Array(asc("*"),15,5,5,90) )
	oEditModel.EchoChar=asc("*")
	oDialogModel.insertByName("PasswordEdit",oEditModel)
	oOKButton=oDialogModel.createInstance("com.sun.star.awt.UnoControlButtonModel")
	oOKButton.setPropertyValues(Array("DefaultButton","Height","Label","PositionX","PositionY","PushButtonType","Width"),Array(True,15,"~OK",55,25,1,40))
	oDialogModel.insertByName("OkButton",oOKButton)
	oCancelButton=oDialogModel.createInstance("com.sun.star.awt.UnoControlButtonModel")
	oCancelButton.setPropertyValues(Array("Height","Label","PositionX","PositionY","PushButtonType","Width"),Array(15,"~Cancel",5,25,2,40))
	oDialogModel.insertByName("CancelButton",oCancelButton)
	oDialog.setVisible(True)
	If oDialog.Execute=1 Then hInput=oEditModel.Text
End Sub

function permission(act as string) as boolean
	on error goto ErrorHandler
	dim result as object
	dim statement as object
	if isnull(connection) then
		permission=False
	else
		statement=connection.CreateStatement
		result=statement.executequery("SELECT * FROM mybase.utilisateur WHERE `id`='"+user+ "'")
		result.next
		select case act
			case "comptant": permission=result.getint(3)
			case "credit": permission=result.getint(4)
			case "devis": permission=result.getint(5)
			case "stat": permission=result.getint(6)
			case "reglement": permission=result.getint(7)
			case "clientmod": permission=result.getint(8)
			case "entree": permission=result.getint(9)
			case "printfact": permission=result.getint(10)
			case "fdj": permission=result.getint(11)
			case else: permission=False
		end select
	end if
	exit function' global const l =" @
	ErrorHandler:
	permission=False
	on error goto 0
end function

function factType(num as long) as string
	dim result as object
	dim statement as object
	dim requete as string
	statement=connection.Createstatement
	if num=0 then
		factType="inexistant"
		exit function' global const l =" @
	elseif num>9999 then 'factures
		result=statement.executequery("SELECT `id` FROM mybase.fact WHERE `id`="+cstr(num))
		if result.next then
			factType="facture"
			exit function' global const l =" @
		else
			factType="inexistant"
			exit function' global const l =" @
		end if
	else 'devis
		result=statement.executequery("SELECT `id` FROM mybase.devis WHERE `id`="+cstr(num))
		if result.next then
			factType="devis"
			exit function' global const l =" @
		else
			factType="inexistant"
			exit function' global const l =" @
		end if
	end if
end function

function selectedRow as long
	dim selection,converter
	selection=ThisComponent.getCurrentSelection
	If isempty(selection) Then
		selectedRow=-1
		exit function' global const l =" @
	elseif selection.supportsService("com.sun.star.sheet.SheetCell") Then
		converter=ThisComponent.createInstance("com.sun.star.table.CellAddressConversion")
		converter.address=selection.getCellAddress
		selectedRow=converter.address.Row
	elseif selection.supportsService("com.sun.star.sheet.SheetCellRange") Then
		selectedRow=selection.rangeAddress.StartRow
	else
		selectedRow=-1
	end if
end function

function username(oUser as string) as string
	on error goto ErrorHandler
	dim result as object
	dim statement as object
	statement=connection.CreateStatement
	result=statement.executequery("SELECT `nom` FROM mybase.utilisateur WHERE `id`='"+oUser+ "'")
	if result.next then
		username=result.getstring(1)
	else
		username=oUser
	end if
	exit function' global const l =" @
	ErrorHandler:
		username=oUser
	on error goto 0
end function

function dot(num as double) as string
	dim txt as string
	dim position as integer
	txt=cstr(num)
	position=instr(txt,",")
	if position then mid(txt,position,1,".")
	dot=txt
end function

function vir(txt as string) as double
	dim num as string
	dim position as integer
	num=txt
	position=instr(txt,".")
	if position then mid(num,position,1,",")
	vir=cdbl(num)
end function

function charfilter(inputtxt as string) as string
	dim txt as string
	dim txtlength as integer
	dim i as integer
	dim j as integer
	txt=inputtxt
	txtlength=len(txt)
	for j=1 to txtlength
		select case mid(txt,j,1)
		case "'"
			i=0
			mid(txt,j,1,"`")
		case ","
			i=0
			mid(txt,j,1,".")
		case ";"
			i=0
			mid(txt,j,1,".")
		case "-"
			if i then
				mid(txt,j,1," ")
			else
				i=1
			end if
		case "_"
			i=0
			mid(txt,j,1," ")
		case "\"
			i=0
			mid(txt,j,1,"/")
		case "/"
			i=0
			mid(txt,j,1,"/")
		case "|"
			i=0
			mid(txt,j,1,"/")
		case "#"
			i=0
			mid(txt,j,1," ")
		case "*"
			i=0
			mid(txt,j,1,"x")
		case else
			i=0
		end select
	next j
	charfilter=txt
end function

function dateTimeFromSQL(sql as string) as date
	dateTimeFromSQL=dateserial(left(sql,4),mid(sql,6,2),mid(sql,9,2))+timeserial(mid(sql,12,2),mid(sql,15,2),mid(sql,18,2))
end function

function dateFromSQL(sql as string) as date
	dateFromSQL=dateserial(left(sql,4),mid(sql,6,2),mid(sql,9,2))
end function

function dateToSQL(jour as date) as string
	dateToSQL=cstr(year(jour))+"-"+format(month(jour),"00")+"-"+format(day(jour),"00")
end function

function lettre(vNombre as double) as string
	on error goto ErrorHandler
	Dim vOutput as string
	Dim vGroupe as integer
	Dim vMilliard as integer
	Dim vMillion as integer
	Dim vMille as integer
	Dim vUnite as integer
	Dim vNegatif as boolean
	Dim vString as string
	Dim vlength as integer
	Dim vCentaine as integer
	Dim vDizaine as integer
	Dim vUnites as integer
	Dim tVingt as Variant
	Dim tDix as Variant
	Dim tUnite as Variant
	if vNombre<0 then
		vNegatif=false
		vNombre=abs(vNombre)
	else
		vNegatif=true
	endif
	vString=cstr(vNombre)
	vlength=len(vString)
	while vlength<12
		vString=" "+vString
		vlength=vlength+1
	wend
	vMilliard=cint(mid(vString,1,3))
	vMillion=cint(mid(vString,4,3))
	vMille=cint(mid(vString,7,3))
	vUnite=cint(mid(vString,10,3))
	if vOutput<>"" then vOutput=vOutput+" "
	if vMilliard then
		vGroupe=vMilliard
		gosub Groupe
		vOutput=vOutput+" MILLIARD"
		if vMilliard>1 then vOutput=vOutput+"S"
	end if
	if vMillion then
		if vOutput<>"" then vOutput=vOutput+" "
		vGroupe=vMillion
		gosub Groupe
		vOutput=vOutput+" MILLION"
		if vMillion>1 then vOutput=vOutput+"S"
	end if
	if vMille then
		if vOutput<>"" then vOutput=vOutput+" "
		if vMille>=2 then
			vGroupe=vMille
			gosub Groupe
			vOutput=vOutput+" MILLE"
		else
			vOutput=vOutput+"MILLE"
		end if	
	end if
	if vUnite then
		if vOutput<>"" then vOutput=vOutput+" "
		vGroupe=vUnite
		gosub Groupe
	end if
	if vNombre<1 then vOutput="ZÉRO"
	if vNegatif=false then vOutput="MOINS "+vOutput
	lettre=vOutput
	exit function
Groupe:
	tUnite=array("UN","DEUX","TROIS","QUATRE","CINQ","SIX","SEPT","HUIT","NEUF","DIX","ONZE","DOUZE","TREIZE","QUATORZE","QUINZE","SEIZE","DIX-SEPT","DIX-HUIT","DIX-NEUF")
	tDix=array("VINGT","TRENTE","QUARANTE","CINQUANTE","SOIXANTE","SOIXANTE-DIX","QUATRE-VINGT","QUATRE-VINGT-DIX")
	if vGroupe then
		vCentaine=int(vGroupe/100)
		vDizaine=int((vGroupe-(vCentaine*100))/10)
		vUnites=vGroupe-vCentaine*100-vDizaine*10
	endif
	if vCentaine then
		if vCentaine=1 then
			vOutput=vOutput+"CENT"
		else
			vOutput=vOutput+tUnite(vCentaine-1)+" CENT"
		endif
	endif
	if ((vUnites or vDizaine) and vOutput<>"") then vOutput=vOutput+" "
	select case vDizaine
	case 0,1
		if vUnites or vDizaine then vOutput=vOutput+tUnite(vDizaine*10+vUnites-1)
	case 2,3,4,5,6,8
		vOutput=vOutput+tDix(vDizaine-2)
		if vDizaine=8 and vUnites=0 then vOutput=vOutput+"S"
		if vUnites=1 then
			if vDizaine=8 then
				vOutput=vOutput+"-UN"
			else
				vOutput=vOutput+" ET UN"
			end if
		else
			if vUnites>1 then vOutput=vOutput+"-"+tUnite(vUnites-1)
		end if
	case 7,9
		vOutput=vOutput+tdix(vDizaine-3)
		select case vUnites
		case 0
			vOutput=vOutput+"-DIX"
		case 1
			if vDizaine=7 then
				vOutput=vOutput+" ET ONZE"
			else
				vOutput=vOutput+"-ONZE"
			end if
		case else
			vOutput=vOutput+"-"+tunite(vunites+9)
		end select
	end select
return
ErrorHandler:
	vOutput=""
end function

sub showClientDialog
	GlobalScope.BasicLibraries.LoadLibrary("Tools")
	DialogLibraries.LoadLibrary("Library1")
	listboxDialog=CreateUnoDialog(DialogLibraries.Library1.ClientDialog)
	listboxDialog.Title="Recherche client"
	listboxDialog.Model.Width =126
	listboxDialog.Model.Height=150
	listboxDialog.getControl("ListBox1").Model.StringItemList=selectNameArray
	listboxDialog.Execute
End Sub

sub showProdDialog
	GlobalScope.BasicLibraries.LoadLibrary("Tools")
	DialogLibraries.LoadLibrary("Library1")
	listboxDialog=CreateUnoDialog(DialogLibraries.Library1.ProdDialog)
	listboxDialog.Title="Recherche produit"
	listboxDialog.Model.Width =234	
	listboxDialog.Model.Height=189
	listboxDialog.getControl("ListBox1").Model.StringItemList=selectNameArray
	listboxDialog.Execute
End Sub

sub dialogOk
	dialogChoice=listboxDialog.getControl("ListBox1").getSelectedItemPos
	listboxDialog.endExecute
	okpressed=true
end sub

sub dialogCancel
	dialogChoice=-1
	listboxDialog.endExecute
end sub

function alignD(w as string,l as integer) as string
	dim lw as integer
	lw=len(w)
	while lw<l
		w=" "+w
		lw=lw+1
	wend
	alignD=w
end function

function alignG(w as string,l as integer) as string
	dim lw as integer
	lw=len(w)
	while lw<l
		w=w+ " "
		lw=lw+1
	wend
	alignG=w
end function

global sub onOpening
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	unprotectAll
	errormode=false
	connection=nothing
	signal("Déconnecté")
	poscleaner
	pospreselect
	printcleaner
	iselectcleaner
	qcleaner
	PSCleaner
	ccleaner
	paycleaner
	salescleaner
	incleaner
	fdjcleaner
	icleaner
	ThisComponent.Sheets.getByName("modèleFacture").isVisible=false
	ThisComponent.Sheets.getByName("modèleDevis").isVisible=false
	ThisComponent.Sheets.getByName("ticket").isVisible=false
	ThisComponent.Sheets.getByName("Codebar").isVisible=false
	ThisComponent.Sheets.getByName("Prix").isVisible=false
	ThisComponent.Sheets.getByName("Reglement").isVisible=false
	ThisComponent.Sheets.getByName("Ventes").isVisible=false
	ThisComponent.Sheets.getByName("Entrée").isVisible=false
	ThisComponent.Sheets.getByName("FDJ").isVisible=false
	ThisComponent.Sheets.getByName("Liste.Entrées").isVisible=false
	protectAll
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	ThisComponent.Sheets.getByName("Aff.Facture").getCellByPosition(3,0).string=""
	ThisComponent.CurrentController.ActiveSheet=ThisComponent.Sheets.getByName("Aff.Facture")
	startAllListener
end sub

global sub onClosing
	On Error Resume Next
	stopAllListener
	connection.close
end sub

Sub startAllListener
	startInListener
	startIVListener
	startPayListener
	startPosListener
end sub

Sub stopAllListener
	stopInListener
	stopIVListener
	stopPayListener
	stopPosListener
End Sub

sub protectAll
	dim i As Integer
	dim nbsheet As Integer
	nbsheet=ThisComponent.Sheets.Count-1
	for i=0 to nbsheet
		ThisComponent.Sheets(i).protect(mypass)
	next i
end sub

sub unprotectAll
	dim i As Integer
	dim nbsheet As Integer
	nbsheet=ThisComponent.Sheets.Count-1
	for i=0 to nbsheet
		ThisComponent.Sheets(i).unprotect(mypass)
	next i
end sub

sub unrecoverable(process as string)
	protectAll
	errormode=true
	stopAllListener
	disconnect
	signal("Veuillez redémarrer le programme")
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Une erreur irrécupérable est survenue dans «"+process+"»"+chr(13)+"Veuillez redémarrer le programme"+chr(13)+chr(13)+"Error code: "+chr(13)+ Error(Err),64,"Error")
end sub

sub recovery
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	stopAllListener
	unprotectAll
	msgbox("Un problème est survenu: "+Error+ chr(13)+"Tout doit être effacé"+chr(13),64,"Error")
	poscleaner
	iselectcleaner
	qcleaner
	PSCleaner
	ccleaner
	paycleaner
	salescleaner
	incleaner
	fdjcleaner
	icleaner
	protectAll
	ThisComponent.unlockcontrollers
	ThisComponent.calculateAll
	ThisComponent.enableAutomaticCalculation(true)
	startAllListener
end sub
