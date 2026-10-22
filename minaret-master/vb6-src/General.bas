Attribute VB_Name = "Module2"
Option Explicit

Global Const modal = 1
Global Const CASCADE = 0
Global Const TILE_HORIZONTAL = 1
Global Const TILE_VERTICAL = 2
Global Const ARRANGE_ICONS = 3

Type FormState
    Deleted As Boolean
    Dirty As Boolean
    Color As Long
End Type
Global FState()  As FormState
Global Document() As New frmSched
''Global ArrayNum As Integer

Function AnyPadsLeft() As Integer
    Dim i As Integer

    ' Cycle throught the document array.
    ' Return True if there is at least one
    ' open document remaining.
    For i = 1 To UBound(Document)
        If Not FState(i).Deleted Then
            AnyPadsLeft = True
            Exit Function
        End If
    Next

End Function

Sub CenterForm(frmParent As Form, frmChild As Form)
' This procedure centers a child form over a parent form.
' Calling this routine loads the dialog. Use the Show method
' to display the dialog after calling this routine ( ie MyFrm.Show 1)

Dim l As Integer
Dim t As Integer
  ' get left offset
  l = frmParent.Left + ((frmParent.Width - frmChild.Width) / 2)
  If (l + frmChild.Width > Screen.Width) Then
    l = Screen.Width - frmChild.Width
  End If

  ' get top offset
  t = frmParent.top + ((frmParent.Height - frmChild.Height) / 2)
  If (t + frmChild.Height > Screen.Height) Then
    t = Screen.Height - frmChild.Height
  End If

  ' center the child formfv
  frmChild.Move l, t

End Sub

Sub EditCopyProc()
    ' Copy selected text to Clipboard.
    Clipboard.SetText frmMinaret.ActiveForm.ActiveControl.SelText
End Sub

Sub EditCutProc()
    ' Copy selected text to Clipboard.
    Clipboard.SetText frmMinaret.ActiveForm.ActiveControl.SelText
    ' Delete selected text.
    frmMinaret.ActiveForm.ActiveControl.SelText = ""
End Sub

Sub EditPasteProc()
    ' Place text from Clipboard into active control.
    frmMinaret.ActiveForm.ActiveControl.SelText = Clipboard.GetText()
End Sub

Sub FileNew()
    Dim fIndex As Integer

    fIndex = FindFreeIndex()
    Document(fIndex).Tag = fIndex
    Document(fIndex).Caption = "Untitled:" & fIndex
    Document(fIndex).Show
    Set schTxt = Document(fIndex).Text1
End Sub

Function FindFreeIndex() As Integer
    Dim i As Integer
    Dim ArrayCount As Integer

    ArrayCount = UBound(Document)

    ' Cycle throught the document array. If one of the
    ' documents has been deleted, then return that
    ' index.
    For i = 1 To ArrayCount
        If FState(i).Deleted Then
            FindFreeIndex = i
            FState(i).Deleted = False
            Exit Function
        End If
    Next

    ' If none of the elements in the document array have
    ' been deleted, then increment the document and the
    ' state arrays by one and return the index to the
    ' new element.

    ReDim Preserve Document(ArrayCount + 1)
    ReDim Preserve FState(ArrayCount + 1)
    FindFreeIndex = UBound(Document)
End Function

