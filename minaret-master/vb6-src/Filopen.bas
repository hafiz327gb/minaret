Attribute VB_Name = "Module1"
Option Explicit

Function GetFileName(ByVal mode As Integer) As String
    'mode is 1 for Open, 2 for SaveAs
    
    'Displays Open/SaveAs dialog and returns a file name
    'or an empty string if the user cancels
    On Error Resume Next
    frmMinaret.CMDialog1.Filename = ""
    frmMinaret.CMDialog1.Filter = "Text Files (*.txt;*.doc)|*.txt;*.doc|All Files (*.*)|*.*"
    frmMinaret.CMDialog1.DefaultExt = ".txt;*.doc"
    frmMinaret.CMDialog1.CancelError = True
    frmMinaret.CMDialog1.Action = mode
    'If mode = 1 Then
        'frmMinaret.CMDialog1.ShowOpen '1
    'Else
        'frmMinaret.CMDialog1.ShowSaveAs '2
    'End If
    If Err <> 32755 Then      'User cancelled dialog
        GetFileName = frmMinaret.CMDialog1.Filename
    Else
        GetFileName = ""
    End If
End Function

Function OnRecentFilesList(ByRef Filename As String) As Integer
  ''Dim i

  ''For i = 1 To 4
    ''If frmMinaret.mnuRecentFile(i).Caption = Filename Then
      ''OnRecentFilesList = True
      ''Exit Function
    ''End If
  ''Next i
    ''OnRecentFilesList = False
End Function

Sub OpenFile(ByRef Filename As String)
    Dim NL As String * 2
    Dim TextIn As String
    Dim GetLine As String
    Dim fIndex As Integer

    NL = Chr(13) & Chr(10)
    
    On Error Resume Next
    ' open the selected file
    Open Filename For Input As #1
    If Err Then
        MsgBox "Can't open file: " & Filename
        Exit Sub
    End If
    ' change mousepointer to an hourglass
    Screen.MousePointer = vbHourglass '11
    
    ' change form's caption and display new text
    fIndex = FindFreeIndex()
    Document(fIndex).Tag = fIndex
    Document(fIndex).Caption = UCase(Filename)
    Document(fIndex).Text1.Text = Input(LOF(1), 1)
    FState(fIndex).Dirty = False
    Document(fIndex).Show
    Close #1
    ' reset mouse pointer
    Screen.MousePointer = 0
End Sub

Sub SaveFileAs(ByRef Filename As String)
On Error Resume Next
    Dim Contents As String

    ' open the file
    Open Filename For Output As #1
    ' put contents of the notepad into a variable
    Contents = frmMinaret.ActiveForm.Text1.Text
    ' display hourglass
    Screen.MousePointer = vbHourglass '11
    ' write variable contents to saved file
    Print #1, Contents
    Close #1
    ' reset the mousepointer
    Screen.MousePointer = 0
    ' set the Notepad's caption

    If Err Then
        MsgBox Error, 48, App.title 'exclamation icon
    Else
        frmMinaret.ActiveForm.Caption = UCase(Filename)
        ' reset the dirty flag
        FState(frmMinaret.ActiveForm.Tag).Dirty = False
    End If
End Sub

Sub UpdateFileMenu(ByRef Filename As String)
        ''Dim RetVal
        ' Check if OpenFileName is already on MRU list.
        ''RetVal = OnRecentFilesList(Filename)
        ''If Not RetVal Then
          ' Write OpenFileName to MDINOTEPAD.INI
          ''WriteRecentFiles (Filename)
        ''End If
        ' Update menus for most recent file list.
        ''GetRecentFiles
End Sub

