option explicit

function lastitem as integer
	dim counter as integer
	counter=5
	while ThisComponent.CurrentController.ActiveSheet.getCellByPosition(1,counter).Value
		counter=counter+1
	wend
	lastitem=counter
end function

sub salescleaner
	dim feuille as object
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(0,5))
	feuille.protect(mypass)
end sub

sub today
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as long
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.factdet WHERE `datefact`='"+dateToSQL(date)+"'")
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(3))
		feuille.getCellByPosition(1,ligne).value=result.getstring(2)
		feuille.getCellByPosition(2,ligne).value=result.getstring(4)
		feuille.getCellByPosition(3,ligne).string=result.getstring(5)
		feuille.getCellByPosition(4,ligne).string=result.getstring(7)
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)
		feuille.getCellByPosition(6,ligne).value=result.getstring(9)
		feuille.getCellByPosition(7,ligne).value=clng(vir(result.getstring(13))*(1.0+vir(result.getstring(10))))
	wend
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,0,5))
	exit sub' global const l =" @
	ErrorHandler:
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Stats")
	on error goto 0
end sub

sub thismonth
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as long
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.factdet WHERE MONTH(`datefact`)="+month(date)+" AND YEAR(`datefact`)="+year(date))
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(3))
		feuille.getCellByPosition(1,ligne).value=result.getstring(2)
		feuille.getCellByPosition(2,ligne).value=result.getstring(4)
		feuille.getCellByPosition(3,ligne).string=result.getstring(5)
		feuille.getCellByPosition(4,ligne).string=result.getstring(7)
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)
		feuille.getCellByPosition(6,ligne).value=result.getstring(9)
		feuille.getCellByPosition(7,ligne).value=clng(vir(result.getstring(13))*(1.0+vir(result.getstring(10))))
	wend
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,0,5))
	exit sub' global const l =" @
	ErrorHandler:
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Stats")
	on error goto 0
end sub

sub lastmonth
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as long
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.factdet WHERE MONTH(`datefact`)="+month(DateAdd("m",-1,date))+" AND YEAR(`datefact`)="+year(DateAdd("m",-1,date)))
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(3))
		feuille.getCellByPosition(1,ligne).value=result.getstring(2)
		feuille.getCellByPosition(2,ligne).value=result.getstring(4)
		feuille.getCellByPosition(3,ligne).string=result.getstring(5)
		feuille.getCellByPosition(4,ligne).string=result.getstring(7)
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)
		feuille.getCellByPosition(6,ligne).value=result.getstring(9)
		feuille.getCellByPosition(7,ligne).value=clng(vir(result.getstring(13))*(1.0+vir(result.getstring(10))))
	wend
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,0,5))
	exit sub' global const l =" @
	ErrorHandler:
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Stats")
	on error goto 0
end sub

sub thisyear
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as long
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.factdet WHERE YEAR(`datefact`)="+year(date))
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(3))
		feuille.getCellByPosition(1,ligne).value=result.getstring(2)
		feuille.getCellByPosition(2,ligne).value=result.getstring(4)
		feuille.getCellByPosition(3,ligne).string=result.getstring(5)
		feuille.getCellByPosition(4,ligne).string=result.getstring(7)
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)
		feuille.getCellByPosition(6,ligne).value=result.getstring(9)
		feuille.getCellByPosition(7,ligne).value=clng(vir(result.getstring(13))*(1.0+vir(result.getstring(10))))
	wend
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,0,5))
	exit sub' global const l =" @
	ErrorHandler:
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Stats")
	on error goto 0
end sub

sub lastyear
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as long
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,7,lastitem).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.factdet WHERE YEAR(`datefact`)="+(year(date)-1))
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).value=dateFromSQL(result.getstring(3))
		feuille.getCellByPosition(1,ligne).value=result.getstring(2)
		feuille.getCellByPosition(2,ligne).value=result.getstring(4)
		feuille.getCellByPosition(3,ligne).string=result.getstring(5)
		feuille.getCellByPosition(4,ligne).string=result.getstring(7)
		feuille.getCellByPosition(5,ligne).string=result.getstring(8)
		feuille.getCellByPosition(6,ligne).value=result.getstring(9)
		feuille.getCellByPosition(7,ligne).value=clng(vir(result.getstring(13))*(1.0+vir(result.getstring(10))))
	wend
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	feuille.getCellByPosition(4,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellRangeByPosition(0,5,0,5))
	exit sub' global const l =" @
	ErrorHandler:
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
	msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Stats")
	on error goto 0
end sub

Sub trieparfact
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=1'	n°facture
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(4,1).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparnumclient
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=2'	n°client
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(4,1).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparname
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=3'	nom
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(4,1).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub trieparrefmag
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=4'	refmag
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(4,1).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub

Sub triepardesign
	if errormode then exit sub' global const l =" @
	on error goto ErrorHandler
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	feuille=ThisComponent.Sheets.getByName("Ventes")
	feuille.getCellByPosition(4,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,7,lastitem)
	oSortFields(0).Field=5'	designation
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(4,1).string=" "
	feuille.protect(mypass)
	ThisComponent.enableAutomaticCalculation(true)
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Trie")
	on error goto 0
End Sub
