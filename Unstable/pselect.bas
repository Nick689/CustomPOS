Option Explicit

global oCell as object
global oDescriptor as object
global previoussearch as string

function lastproduct as integer
	dim counter as integer
	counter=5
	while ThisComponent.CurrentController.ActiveSheet.getCellByPosition(1,counter).Value
		counter=counter+1
	wend
	lastproduct=counter
end function

sub PSCleaner
	dim feuille as object
	dim i as integer
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,12,lastproduct).clearContents(flag)
	feuille.getCellByPosition(9,1).string=" "
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(0,5))
	feuille.protect(mypass)
end sub

sub maj
	on error goto ErrorHandler
	if errormode then exit sub' global const l =" @
	if notconnected then exit sub' global const l =" @
	dim feuille as object
	dim result as object
	dim statement as object
	dim ligne as integer
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.getCellByPosition(9,1).string="VEUILLEZ PATIENTER"
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille.unprotect(mypass)
	feuille.getCellRangeByPosition(0,5,12,lastproduct).clearContents(flag)
	statement=connection.CreateStatement
	result=statement.executequery("SELECT * FROM mybase.stk ORDER BY `design`")
	ligne=4
	while result.next
		ligne=ligne+1
		feuille.getCellByPosition(0,ligne).string=result.getstring(7)
		feuille.getCellByPosition(1,ligne).value=result.getstring(1)
		feuille.getCellByPosition(2,ligne).string=result.getstring(2)
		feuille.getCellByPosition(3,ligne).string=result.getstring(4)
		feuille.getCellByPosition(4,ligne).string=result.getstring(11)
		feuille.getCellByPosition(5,ligne).string=result.getstring(5)
		feuille.getCellByPosition(6,ligne).string=result.getstring(6)
		feuille.getCellByPosition(7,ligne).value=result.getstring(9)
		feuille.getCellByPosition(8,ligne).string=result.getstring(8)
		feuille.getCellByPosition(9,ligne).value=result.getstring(14)
		feuille.getCellByPosition(10,ligne).string=result.getstring(26)
		select case result.getstring(19)
			case 0
			 feuille.getCellByPosition(12,ligne).value=clng(result.getstring(23))
			case 1
			 feuille.getCellByPosition(11,ligne).value=tva1
			 feuille.getCellByPosition(12,ligne).value=clng(vir(result.getstring(23))*(1+tva1))
			case 2
			 feuille.getCellByPosition(11,ligne).value=tva2
			 feuille.getCellByPosition(12,ligne).value=clng(vir(result.getstring(23))*(1+tva2))
			case 3
			 feuille.getCellByPosition(11,ligne).value=tva3
			 feuille.getCellByPosition(12,ligne).value=clng(vir(result.getstring(23))*(1+tva3))
		end select
	wend
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	feuille.getCellByPosition(9,1).string=cstr(ligne-4)+" articles référencés"
	ThisComponent.enableAutomaticCalculation(true)
	ThisComponent.CurrentController.Select(feuille.getCellByPosition(0,5))
	exit sub' global const l =" @
	ErrorHandler:
	recovery
	on error goto 0
end sub

Sub trieparcat
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,12,lastproduct)
	oSortFields(0).Field=0'	catégorie
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub trieparfourn
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,12,lastproduct)
	oSortFields(0).Field=4'	fourn
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub trieparintern
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,12,lastproduct)
	oSortFields(0).Field=1'	ref int
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.NUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

Sub triepardesign
	dim oRange as object
	dim oSortFields(0) as new com.sun.star.util.SortField
	dim oSortDesc(0) as new com.sun.star.beans.PropertyValue
	dim feuille as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	feuille=ThisComponent.Sheets.getByName("Articles")
	feuille.unprotect(mypass)
	oRange=feuille.getCellRangeByPosition(0,5,12,lastproduct)
	oSortFields(0).Field=8'	désignation
	oSortFields(0).SortAscending=True
	oSortFields(0).FieldType=com.sun.star.util.SortFieldType.ALPHANUMERIC
	oSortDesc(0).Name="SortFields"
	oSortDesc(0).Value=oSortFields
	oRange.Sort(oSortDesc)
	feuille.protect(mypass)
	ThisComponent.unlockcontrollers
	ThisComponent.enableAutomaticCalculation(true)
End Sub

sub search
	dim newsearch as boolean
	dim feuille as object
	dim oRange as object
	ThisComponent.enableAutomaticCalculation(false)
	ThisComponent.lockcontrollers
	oRange=ThisComponent.createInstance("com.sun.star.sheet.SheetCellRanges")
	feuille=ThisComponent.Sheets.getByName("Articles")
	if feuille.getCellByPosition(8,2).String<>"" then
		if feuille.getCellByPosition(8,2).String<>previoussearch then  'Première recherche
			previoussearch=feuille.getCellByPosition(8,2).String
			oDescriptor=feuille.createSearchDescriptor
			oDescriptor.SearchString=previoussearch
			oDescriptor.SearchWords=true
			oDescriptor.SearchCaseSensitive=False
			feuille.getCellByPosition(8,2).String=""
			oCell=feuille.findFirst(oDescriptor)
			if isnull(oCell) then
				oDescriptor.SearchWords=false
				oCell=feuille.findFirst(oDescriptor)
				if isnull(oCell) then
					ThisComponent.enableAutomaticCalculation(true)
					ThisComponent.unlockcontrollers
					exit sub' global const l =" @
				end if
			end if
		else
			if isnull(oCell) then
				ThisComponent.enableAutomaticCalculation(true)
				ThisComponent.unlockcontrollers
				exit sub' global const l=" @  recherche suivante sans résultat précèdant
			else'								recherche suivante avec résultat précèdant
				oCell=feuille.findNext(oCell,oDescriptor)
				if isnull(oCell) then
					ThisComponent.enableAutomaticCalculation(true)
					ThisComponent.unlockcontrollers
					exit sub' global const l =" @
				end if
			end if
		end if
		if not isnull(oCell) then
			feuille.getCellByPosition(8,2).String=previoussearch
			oRange=feuille.getCellRangeByPosition(0,oCell.CellAddress.row,12,oCell.CellAddress.row)
			ThisComponent.CurrentController.Select(oRange)
			ThisComponent.enableAutomaticCalculation(true)
		end if
	else
		previoussearch=""
	end if
	ThisComponent.enableAutomaticCalculation(true)
	ThisComponent.unlockcontrollers
end sub
