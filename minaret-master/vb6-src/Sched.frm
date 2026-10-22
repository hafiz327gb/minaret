VERSION 5.00
Begin VB.Form frmSched 
   ClientHeight    =   3972
   ClientLeft      =   2208
   ClientTop       =   4440
   ClientWidth     =   5604
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.4
      Charset         =   178
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3972
   ScaleWidth      =   5604
   Visible         =   0   'False
   Begin VB.TextBox Text1 
      Height          =   3855
      HideSelection   =   0   'False
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   0
      Width           =   5655
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFClose 
         Caption         =   "&Close"
         Shortcut        =   ^W
      End
      Begin VB.Menu mnuFSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFSave 
         Caption         =   "&Save"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuFSaveAs 
         Caption         =   "Save &As..."
      End
      Begin VB.Menu mnuFSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFPrint 
         Caption         =   "&Print"
         Shortcut        =   ^P
      End
      Begin VB.Menu mnuFSep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuECut 
         Caption         =   "Cu&t"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuECopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuEPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuEDelete 
         Caption         =   "De&lete"
         Shortcut        =   {DEL}
      End
      Begin VB.Menu mnuESep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuESelectAll 
         Caption         =   "Select &All"
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "&Window"
      WindowList      =   -1  'True
      Begin VB.Menu mnuWCascade 
         Caption         =   "&Cascade"
      End
      Begin VB.Menu mnuWTile 
         Caption         =   "&Tile"
      End
      Begin VB.Menu mnuWArrange 
         Caption         =   "&Arrange Icons"
      End
   End
End
Attribute VB_Name = "frmSched"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Text1.FontName = "FixedSys"
    Text1.FontSize = 10
    Text1.FontBold = False
    'top = (Screen.Height - Height) / 2
    'Left = (Screen.Width - Width) / 2
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Dim msg As String
    Dim Filename As String
    Dim NL As String * 2
    Dim Response As Integer

    If FState(Me.Tag).Dirty Then
        Filename = Me.Caption
        NL = Chr(10) & Chr(13)
        msg = "The text in [" & Filename & "] has changed."
        msg = msg & NL
        msg = msg & "Do you want to save the changes?"
        Response = MsgBox(msg, 51, frmMinaret.Caption)
        Select Case Response
        ' User selects Yes
        Case 6
            'Get the filename to save the file
            Filename = GetFileName(2)
            'If the user did notspecify a file name,
            'cancel the unload; otherwise, save it.
            If Filename = "" Then
                Cancel = True
            Else
                SaveFileAs (Filename)
            End If

        ' User selects No
        ' Ok to unload
        Case 7
            Cancel = False
        ' User selects Cancel
        ' Cancel the unload
        Case 2
            Cancel = True
        End Select
    End If
End Sub

Private Sub Form_Resize()
    If WindowState <> 1 And ScaleHeight <> 0 Then
        Text1.Visible = False
        Text1.Height = ScaleHeight
        Text1.Width = ScaleWidth
        Text1.Visible = True
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    FState(Me.Tag).Deleted = True
End Sub

Private Sub mnuECopy_Click()
    EditCopyProc
End Sub

Private Sub mnuECut_Click()
    EditCutProc
End Sub

Private Sub mnuEDelete_Click()
  ' If cursor is not at the end of the notepad.
  If Screen.ActiveControl.SelStart <> Len(Screen.ActiveControl.Text) Then
    ' If nothing is selected, extend selection by one.
    If Screen.ActiveControl.SelLength = 0 Then
      Screen.ActiveControl.SelLength = 1
      ' If cursor is on a blank line, extend selection by two.
      If Asc(Screen.ActiveControl.SelText) = 13 Then
        Screen.ActiveControl.SelLength = 2
      End If
    End If
    ' Delete selected text.
    Screen.ActiveControl.SelText = ""
  End If
End Sub

Private Sub mnuEPaste_Click()
    EditPasteProc
End Sub

Private Sub mnuESelectAll_Click()
    frmMinaret.ActiveForm.Text1.SelStart = 0
    frmMinaret.ActiveForm.Text1.SelLength = Len(frmMinaret.ActiveForm.Text1.Text)
End Sub

Private Sub mnuFClose_Click()
    Unload Me
End Sub

Private Sub mnuFExit_Click()
    ' Unloading the MDI form invokes the QueryUnload event
    ' for each child form, then the MDI form - before unloading
    ' the MDI form. Setting the Cancel argument to True in any of the
    ' QueryUnload events aborts the unload.
    Unload Me
End Sub

Private Sub mnuFNew_Click()
    FileNew
End Sub

Private Sub mnuFOpen_Click()
    Dim OpenFileName As String

    OpenFileName = GetFileName(1)
    If OpenFileName <> "" Then OpenFile (OpenFileName)
End Sub

Private Sub mnuFPrint_Click()
    Dim txt As String
    Dim pos As Long
    Dim start As Long
    
    MousePointer = vbHourglass '11
    'frmTest.Show
    'frmTest.FontSize = 6.6
    'frmTest.ScaleLeft = -1440 '1 inch = 1440 twips
    'frmTest.ScaleTop = -1440
    'Printer.FontSize = 10  '8.25
    Printer.ScaleLeft = -1440 '1 inch = 1440 twips
    Printer.ScaleTop = -1440
    'LinesPerPage = (frmTest.Height - 2880) / frmTest.TextHeight("A")
    LinesPerPage = (Printer.Height - 2880) / Printer.TextHeight("A")
    PrtForm
    MousePointer = 0
End Sub

Private Sub mnuFSave_Click()
    Dim Filename As String

    If Left(Me.Caption, 8) = "Untitled" Then
        ' The file hasn't been saved yet,
        ' get the filename, then call the
        ' save procedure
        Filename = GetFileName(2)
    Else
        ' The caption contains the name of the open file
        Filename = Me.Caption
    End If
    ' call the save procedure, if Filename = Empty then
    ' the user selected Cancel in the Save As dialog, otherwise
    ' save the file
    If Filename <> "" Then
        SaveFileAs Filename
    End If
End Sub

Private Sub mnuFSaveAs_Click()
    Dim SaveFileName As String

    SaveFileName = GetFileName(2)
    If SaveFileName <> "" Then SaveFileAs (SaveFileName)
End Sub

Private Sub mnuWArrange_Click()
    frmMinaret.Arrange ARRANGE_ICONS
End Sub

Private Sub mnuWCascade_Click()
    frmMinaret.Arrange CASCADE
End Sub

Private Sub mnuWTile_Click()
    frmMinaret.Arrange TILE_HORIZONTAL
End Sub

Private Sub PrtForm()
    Dim txt As String
    Dim pageCount As Integer
    Dim pageStart As Long
    Dim pageEnd As Long

    txt = frmMinaret.ActiveForm.Text1.Text
    pageStart = 1
    Do
        pageEnd = InStr(pageStart, txt, FORMFEED)
        If pageEnd > 0 Then
            PrtText (Mid(txt, pageStart, pageEnd - pageStart))
            Printer.NewPage
            'frmTest.Cls
            pageStart = pageEnd + 1
        End If
    Loop While pageEnd > 0
    PrtText (Mid(txt, pageStart))
    Printer.EndDoc
    'frmTest.Cls
End Sub

Private Sub PrtText(txt As String)
    Dim lineStart As Long
    Dim lineEnd As Long
    Dim pageStart As Long
    Dim lineCount As Integer

    pageStart = 1
    lineStart = 1
    lineCount = 0
    Do
        Do While lineCount < LinesPerPage
            lineEnd = InStr(lineStart, txt, LF)
            If lineEnd > 0 Then
                lineCount = lineCount + 1
                lineStart = lineEnd + 1
            Else
                Exit Do
            End If
        Loop
        If lineEnd > 0 Then
            Printer.Print Mid(txt, pageStart, lineEnd - pageStart)
            'frmTest.Print Mid(txt, pageStart, lineEnd - pageStart)
            pageStart = lineStart
            lineCount = 0
            Printer.NewPage
            'frmTest.Cls
        Else
            Printer.Print Mid(txt, pageStart)
            'frmTest.Print Mid$(txt, pageStart)
            Exit Do
        End If
    Loop
End Sub

Private Sub Text1_Change()
    FState(Me.Tag).Dirty = True
End Sub

