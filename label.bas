Option Explicit

Sub printcode
	on error goto ErrorHandler
	dim sourcesheet as object
	dim printsheet as object
	dim ligne as integer
	dim copy as integer
	dim page as object
	ligne=selectedRow
	if ligne>4 then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		sourcesheet=ThisComponent.Sheets.getByName("Articles")
		printsheet=ThisComponent.Sheets.getByName("Codebar")
		printsheet.unprotect(mypass)
		printsheet.getCellByPosition(0,0).string=sourcesheet.getCellByPosition(8,ligne).string
		printsheet.getCellByPosition(0,1).string=code128(sourcesheet.getCellByPosition(2,ligne).string)
		printsheet.getCellByPosition(0,2).string=sourcesheet.getCellByPosition(2,ligne).string
		page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
		page.IsLandscape=False
		page.PageScale=100
		page.width=10400
		page.height=3000
		page.LeftMargin=0 '2500
		page.RightMargin=0
		page.TopMargin=0
		page.BottomMargin=0
		page.HeaderIsOn=False
		page.FooterIsOn=False
		page.CenterHorizontally=True 'False
		page.CenterVertically=False
		page.PrintAnnotations=False
		page.PrintGrid=False
		page.PrintHeaders=False
		page.PrintObjects=False
		page.PrintDownFirst=True
		page.PrintFormulas=False
		page.PrintZeroValues=False
		dim args1(0) as new com.sun.star.beans.PropertyValue
		args1(0).Name="Printer"
		args1(0).Value=barcodePrinter
		printsheet.protect(mypass)
		printsheet.isVisible=True
		ThisComponent.unlockcontrollers
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=printsheet
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Print", "", 0, Array)
		wait(100)
		ThisComponent.CurrentController.ActiveSheet=sourcesheet
		printsheet.isVisible=False
	end if
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=sourcesheet
		printsheet.isVisible=False
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Printbarcode")
	on error goto 0
End Sub

sub printprix
	on error goto ErrorHandler
	dim sourcesheet as object
	dim printsheet as object
	dim ligne as integer
	dim copy as integer
	dim page as object
	ligne=selectedRow
	if ligne>4 then
		ThisComponent.enableAutomaticCalculation(false)
		ThisComponent.lockcontrollers
		sourcesheet=ThisComponent.Sheets.getByName("Articles")
		printsheet=ThisComponent.Sheets.getByName("Prix")
		printsheet.unprotect(mypass)
		printsheet.getCellByPosition(0,0).string=sourcesheet.getCellByPosition(8,ligne).string 'design
		printsheet.getCellByPosition(0,1).string=sourcesheet.getCellByPosition(2,ligne).string 'code
		printsheet.getCellByPosition(0,2).value=sourcesheet.getCellByPosition(12,ligne).value 'prix
		page=ThisComponent.StyleFamilies.getByName("PageStyles").getByName("Default")
		page.IsLandscape=False
		page.PageScale=100
		page.width=10400
		page.height=3000
		page.LeftMargin=0 '2500
		page.RightMargin=0
		page.TopMargin=0
		page.BottomMargin=0
		page.HeaderIsOn=False
		page.FooterIsOn=False
		page.CenterHorizontally=True 'False
		page.CenterVertically=False
		page.PrintAnnotations=False
		page.PrintGrid=False
		page.PrintHeaders=False
		page.PrintObjects=False
		page.PrintDownFirst=True
		page.PrintFormulas=False
		page.PrintZeroValues=False
		dim args1(0) as new com.sun.star.beans.PropertyValue
		args1(0).Name="Printer"
		args1(0).Value=pricePrinter
		printsheet.protect(mypass)
		printsheet.isVisible=True
		ThisComponent.unlockcontrollers
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=printsheet
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Printer", "", 0, args1)
		createUnoService("com.sun.star.frame.DispatchHelper").executeDispatch(ThisComponent.CurrentController.Frame, ".uno:Print", "", 0, Array)
		wait(100)
		ThisComponent.CurrentController.ActiveSheet=sourcesheet
		printsheet.isVisible=False
	end if
	exit sub' global const l =" @
	ErrorHandler:
		ThisComponent.enableAutomaticCalculation(true)
		ThisComponent.CurrentController.ActiveSheet=sourcesheet
		printsheet.isVisible=False
		msgbox("Un problème est survenu"+chr(13)+chr(13)+"Error code: "+chr(13)+Error(Err),64,"Printprix")
	on error goto 0
End Sub

GLOBAL Function code128(chaine as string) as string
  dim i as integer
  dim lenchaine as integer
  dim len128 as integer
  dim mini as integer
  dim dummy as integer
  dim tableB as integer
  dim checksum as integer
  code128=""
  lenchaine=Len(chaine)
  If lenchaine > 0 Then
    For i=1 To lenchaine
      Select Case Asc(Mid(chaine, i, 1))
      Case 32 To 126, 203
      Case Else
        i=0
        Exit For
      End Select
    Next
    code128=""
    tableB=True
    If i > 0 Then
      i=1
      Do While i<=lenchaine
        If tableB Then
          If i=1 Or i+3=lenchaine Then mini=4 Else mini=6
          GoSub testnum
          If mini < 0 Then
            If i=1 Then
              code128=Chr(210)
            Else
              code128=code128 & Chr(204)
            End If
            tableB=False
          Else
            If i=1 Then code128=Chr(209)
          End If
        End If
        If Not tableB Then
          mini=2
          GoSub testnum
          If mini < 0 Then
            dummy=Val(Mid(chaine, i, 2))
            dummy=IIf(dummy < 95, dummy+32, dummy+105)
            code128=code128 & Chr(dummy)
            i=i+2
          Else
            code128=code128 & Chr(205)
            tableB=True
          End If
        End If
        If tableB Then
          code128=code128 & Mid(chaine, i, 1)
          i=i+1
        End If
      Loop
      len128=Len(code128)
      For i=1 To len128
        dummy=Asc(Mid(code128, i, 1))
        If dummy<127 Then dummy=dummy-32 Else dummy=dummy-105
        If i=1 Then checksum=dummy
        checksum=(checksum+(i-1) * dummy) Mod 103
      Next
      checksum=IIf(checksum < 95, checksum+32, checksum+105)
      code128=code128 & Chr(checksum) & Chr(211)
    End If
  End If
  exit function' global const l =" @
testnum:
  mini=mini-1
  If i+mini<=lenchaine Then
    Do While mini>=0
      If Asc(Mid(chaine, i+mini, 1)) < 48 Or Asc(Mid(chaine, i+mini, 1)) > 57 Then Exit Do
      mini=mini-1
    Loop
  End If
Return
End Function
