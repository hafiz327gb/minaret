VERSION 5.00
Begin VB.Form frmGaz 
   Caption         =   "Gazetteer "
   ClientHeight    =   7320
   ClientLeft      =   2460
   ClientTop       =   3540
   ClientWidth     =   8388
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   7.8
      Charset         =   178
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   7320
   ScaleWidth      =   8388
   Begin VB.CommandButton cmdDSTSpec 
      BackColor       =   &H00FF0000&
      Caption         =   "Specify Dates"
      Height          =   375
      Left            =   5880
      TabIndex        =   31
      Top             =   3960
      Width           =   2055
   End
   Begin VB.TextBox txtCurLoc 
      Enabled         =   0   'False
      Height          =   288
      Left            =   360
      TabIndex        =   29
      Top             =   480
      Width           =   2775
   End
   Begin VB.CommandButton cmdNewLoc 
      Caption         =   "Create New Entry"
      Height          =   372
      Left            =   4080
      TabIndex        =   28
      Top             =   4800
      Width           =   2652
   End
   Begin VB.CommandButton cmdSel 
      Caption         =   "Make it Current Location"
      Height          =   372
      Left            =   4800
      TabIndex        =   14
      Top             =   6720
      Width           =   2652
   End
   Begin VB.Frame Frame3 
      BackColor       =   &H0000FFFF&
      Caption         =   "Time Zone"
      Height          =   735
      Left            =   3720
      TabIndex        =   27
      Top             =   2760
      Width           =   4455
      Begin VB.OptionButton optPos 
         Caption         =   "+"
         Height          =   255
         Left            =   720
         TabIndex        =   9
         Top             =   360
         Width           =   495
      End
      Begin VB.OptionButton optNeg 
         Caption         =   "-"
         Height          =   255
         Left            =   1200
         TabIndex        =   10
         Top             =   360
         Value           =   -1  'True
         Width           =   495
      End
      Begin VB.TextBox txtHr 
         Height          =   288
         Left            =   1800
         TabIndex        =   11
         Top             =   360
         Width           =   612
      End
      Begin VB.TextBox txtMin 
         Height          =   288
         Left            =   3000
         TabIndex        =   12
         Top             =   360
         Width           =   612
      End
      Begin VB.Label Label7 
         Caption         =   "GMT"
         Height          =   252
         Left            =   120
         TabIndex        =   20
         Top             =   360
         Width           =   492
      End
      Begin VB.Label Label8 
         Caption         =   "hr"
         Height          =   255
         Left            =   2520
         TabIndex        =   21
         Top             =   360
         Width           =   375
      End
      Begin VB.Label Label9 
         Caption         =   "min"
         Height          =   255
         Left            =   3720
         TabIndex        =   25
         Top             =   360
         Width           =   495
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H0000FFFF&
      Caption         =   "Longitude"
      Height          =   735
      Left            =   3720
      TabIndex        =   26
      Top             =   1920
      Width           =   4455
      Begin VB.TextBox txtLongDeg 
         Height          =   288
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   612
      End
      Begin VB.TextBox txtLongMin 
         Height          =   288
         Left            =   1560
         TabIndex        =   6
         Top             =   360
         Width           =   612
      End
      Begin VB.OptionButton optE 
         Caption         =   "E"
         Height          =   255
         Left            =   3000
         TabIndex        =   7
         Top             =   360
         Width           =   495
      End
      Begin VB.OptionButton optW 
         Caption         =   "W"
         Height          =   252
         Left            =   3600
         TabIndex        =   8
         Top             =   360
         Value           =   -1  'True
         Width           =   492
      End
      Begin VB.Label Label4 
         Caption         =   "deg"
         Height          =   252
         Left            =   960
         TabIndex        =   18
         Top             =   360
         Width           =   495
      End
      Begin VB.Label Label6 
         Caption         =   "min"
         Height          =   252
         Left            =   2280
         TabIndex        =   19
         Top             =   360
         Width           =   492
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H0000FFFF&
      Caption         =   "Latitude"
      Height          =   735
      Left            =   3720
      TabIndex        =   22
      Top             =   1080
      Width           =   4455
      Begin VB.TextBox txtLatDeg 
         Height          =   288
         Left            =   240
         TabIndex        =   1
         Top             =   360
         Width           =   612
      End
      Begin VB.TextBox txtLatMin 
         Height          =   288
         Left            =   1560
         TabIndex        =   2
         Top             =   360
         Width           =   612
      End
      Begin VB.OptionButton optN 
         Caption         =   "N"
         Height          =   255
         Left            =   3000
         TabIndex        =   3
         Top             =   360
         Value           =   -1  'True
         Width           =   495
      End
      Begin VB.OptionButton optS 
         Caption         =   "S"
         Height          =   255
         Left            =   3600
         TabIndex        =   4
         Top             =   360
         Width           =   495
      End
      Begin VB.Label Label3 
         Caption         =   "deg"
         Height          =   255
         Left            =   960
         TabIndex        =   24
         Top             =   360
         Width           =   495
      End
      Begin VB.Label Label5 
         Caption         =   "min"
         Height          =   252
         Left            =   2280
         TabIndex        =   23
         Top             =   360
         Width           =   492
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   732
      Left            =   7200
      TabIndex        =   17
      Top             =   5280
      Width           =   852
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "Remove this location"
      Height          =   372
      Left            =   4080
      TabIndex        =   16
      Top             =   6000
      Width           =   2652
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "Update/add this location"
      Height          =   372
      Left            =   4080
      TabIndex        =   15
      Top             =   5400
      Width           =   2652
   End
   Begin VB.CheckBox chkDST 
      Caption         =   "Observed"
      Height          =   375
      Left            =   3960
      TabIndex        =   13
      Top             =   3960
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.ComboBox cboGaz 
      Height          =   5328
      Left            =   240
      Sorted          =   -1  'True
      Style           =   1  'Simple Combo
      TabIndex        =   0
      Top             =   1680
      Width           =   3012
   End
   Begin VB.Frame Frame4 
      BackColor       =   &H00FFFF00&
      Caption         =   "Current Location"
      ForeColor       =   &H00000000&
      Height          =   615
      Left            =   240
      TabIndex        =   30
      Top             =   240
      Width           =   3015
   End
   Begin VB.Frame Frame5 
      BackColor       =   &H0000FFFF&
      Caption         =   "Daylight Saving Time"
      Height          =   855
      Left            =   3720
      TabIndex        =   32
      Top             =   3600
      Width           =   4455
   End
   Begin VB.Frame Frame6 
      BackColor       =   &H0000FFFF&
      Caption         =   "Location Under Edit"
      Height          =   732
      Left            =   3720
      TabIndex        =   33
      Top             =   240
      Width           =   4452
      Begin VB.TextBox txtName 
         Height          =   288
         Left            =   840
         TabIndex        =   34
         Top             =   240
         Width           =   3372
      End
      Begin VB.Label Label1 
         Caption         =   " Name"
         Height          =   252
         Left            =   120
         TabIndex        =   35
         Top             =   240
         Width           =   612
      End
   End
   Begin VB.Line Line4 
      BorderColor     =   &H00FF8080&
      BorderWidth     =   2
      X1              =   3360
      X2              =   3360
      Y1              =   1200
      Y2              =   7080
   End
   Begin VB.Line Line3 
      BorderColor     =   &H00FF8080&
      BorderWidth     =   2
      X1              =   120
      X2              =   3360
      Y1              =   7080
      Y2              =   7080
   End
   Begin VB.Line Line2 
      BorderColor     =   &H00FF8080&
      BorderWidth     =   2
      X1              =   120
      X2              =   3360
      Y1              =   1200
      Y2              =   1200
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FF8080&
      BorderWidth     =   2
      X1              =   120
      X2              =   120
      Y1              =   1200
      Y2              =   7080
   End
   Begin VB.Label Label10 
      Caption         =   "To select: scroll and click."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   7.8
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Left            =   720
      TabIndex        =   37
      Top             =   1200
      Width           =   1932
   End
   Begin VB.Label Label2 
      Caption         =   "To search: type a few letters."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   7.8
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   252
      Left            =   600
      TabIndex        =   36
      Top             =   1440
      Width           =   2172
   End
End
Attribute VB_Name = "frmGaz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cboGaz_Click()
    Dim i As Integer
    i = cboGaz.ItemData(cboGaz.ListIndex)
    txtName.Text = place(i).name
    txtLatDeg.Text = Asc(place(i).latd)
    txtLatMin.Text = Asc(place(i).latm)
    If Asc(place(i).latIsS) <> 0 Then
        optS.Value = True
    Else
        optN.Value = True
    End If
    txtLongDeg.Text = Asc(place(i).longd)
    txtLongMin.Text = Asc(place(i).longm)
    If Asc(place(i).longIsW) <> 0 Then
        optW.Value = True
    Else
        optE.Value = True
    End If
    If Asc(place(i).zoneIsM) <> 0 Then
        optNeg.Value = True
    Else
        optPos.Value = True
    End If
    txtHr.Text = Asc(place(i).zoneH)
    txtMin.Text = Asc(place(i).zoneM)
    chkDST.Value = Asc(place(i).hasDayLt)
    DSTStartMonth = Asc(place(i).DSTStartMonth)
    DSTStartDate = Asc(place(i).DSTStartDate)
    DSTStartNum = Asc(place(i).DSTStartNum)
    DSTStartDOW = Asc(place(i).DSTStartDOW)
    DSTFinMonth = Asc(place(i).DSTFinMonth)
    DSTFinDate = Asc(place(i).DSTFinDate)
    DSTFinNum = Asc(place(i).DSTFinNum)
    DSTEndDOW = Asc(place(i).DSTEndDOW)
End Sub

Private Sub chkDST_Click()
    'If (chkDST.Value) Then
        cmdDSTSpec.Enabled = chkDST.Value
    'End If
End Sub

Private Sub cmdAdd_Click()
    Dim i As Integer
    Dim j As Integer
    Dim s As String * 29

    If EmptyFieldCheck(txtName) Then
        Exit Sub
    End If
    If EmptyFieldCheck(txtLatDeg) Then
        Exit Sub
    End If
    i = RangeCheck(txtLatDeg, 0, 90)
    If i < 0 Then
        Exit Sub
    End If
    If EmptyFieldCheck(txtLatMin) Then
        Exit Sub
    End If
    If i = 90 Then
        j = RangeCheck(txtLatMin, 0, 0)
        If j < 0 Then
            Exit Sub
        End If
    Else
        j = RangeCheck(txtLatMin, 0, 59)
        If j < 0 Then
            Exit Sub
        End If
    End If
    If EmptyFieldCheck(txtLongDeg) Then
        Exit Sub
    End If
    i = RangeCheck(txtLongDeg, 0, 180)
    If i < 0 Then
        Exit Sub
    End If
    If EmptyFieldCheck(txtLongMin) Then
        Exit Sub
    End If
    If i = 180 Then
        j = RangeCheck(txtLongMin, 0, 0)
        If j < 0 Then
            Exit Sub
        End If
    Else
        j = RangeCheck(txtLongMin, 0, 59)
        If j < 0 Then
            Exit Sub
        End If
    End If
    If EmptyFieldCheck(txtHr) Then
        Exit Sub
    End If
    i = RangeCheck(txtHr, 0, 12)
    If i < 0 Then
        Exit Sub
    End If
    If EmptyFieldCheck(txtMin) Then
        Exit Sub
    End If
    If i = 12 Then
        j = RangeCheck(txtMin, 0, 0)
        If j < 0 Then
            Exit Sub
        End If
    Else
        j = RangeCheck(txtMin, 0, 30)
        If j < 0 Then
            Exit Sub
        End If
    End If
    pname = Trim(txtName)
    gztDirty = 1
    j = BinSearch(pname)
    If (j < 0) Then
        If nLocHoles > 0 Then
            i = locHole(nLocHoles)
            nLocHoles = nLocHoles - 1
        Else
            locCnt = locCnt + 1
            i = locCnt
        End If
        cboGaz.AddItem pname 'RTrim$(txtName)
        cboGaz.ItemData(cboGaz.NewIndex) = i
    Else
        i = frmGaz.cboGaz.ItemData(j)
    End If
    s = BLANKNAME
    Mid(s, 1) = pname
    place(i).name = s
    place(i).namelen = Chr(Len(pname))
    place(i).latd = Chr(txtLatDeg)
    place(i).latm = Chr(txtLatMin)
    If optS.Value Then
        place(i).latIsS = Chr(1)
    Else
        place(i).latIsS = Chr(0)
    End If
    place(i).longd = Chr(txtLongDeg)
    place(i).longm = Chr(txtLongMin)
    If optW.Value Then
        place(i).longIsW = Chr(1)
    Else
        place(i).longIsW = Chr(0)
    End If
    If optNeg.Value Then
        place(i).zoneIsM = Chr(1)
    Else
        place(i).zoneIsM = Chr(0)
    End If
    place(i).zoneH = Chr(txtHr)
    place(i).zoneM = Chr(txtMin)
    If chkDST Then
        place(i).hasDayLt = Chr(1)
    Else
        place(i).hasDayLt = Chr(0)
    End If
    place(i).DSTStartMonth = Chr(DSTStartMonth)
    place(i).DSTStartDate = Chr(DSTStartDate)
    place(i).DSTStartNum = Chr(DSTStartNum)
    place(i).DSTStartDOW = Chr(DSTStartDOW)
    place(i).DSTFinMonth = Chr(DSTFinMonth)
    place(i).DSTFinDate = Chr(DSTFinDate)
    place(i).DSTFinNum = Chr(DSTFinNum)
    place(i).DSTEndDOW = Chr(DSTEndDOW)
    ' Select added entry if new
    If (j < 0) Then
        cboGaz.ListIndex = cboGaz.NewIndex
    End If
End Sub

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdRecall_Click()
    RecallCurrentLoc
End Sub

Private Sub cmdDSTSpec_Click()
    frmDST.optNumStart(DSTStartNum).Value = True
    frmDST.optDOWStart(DSTStartDOW).Value = True
    frmDST.optMonStart(DSTStartMonth).Value = True
    If DSTStartDate > 0 Then
        frmDST.txtStartDate = DSTStartDate
        frmDST.txtStartDate.Enabled = True
        frmDST.optStartByDate.Value = True
        frmDST.optStartByDOW.Value = False
    Else
        frmDST.txtStartDate = 15
        frmDST.txtStartDate.Enabled = False
        frmDST.optStartByDate.Value = False
        frmDST.optStartByDOW.Value = True
    End If
    
    frmDST.optNumEnd(DSTFinNum).Value = True
    frmDST.optDOWEnd(DSTEndDOW).Value = True
    frmDST.optMonEnd(DSTFinMonth).Value = True
    If DSTFinDate > 0 Then
        frmDST.txtEndDate = DSTFinDate
        frmDST.txtEndDate.Enabled = True
        frmDST.optEndByDate.Value = True
        frmDST.optEndByDOW.Value = False
    Else
        frmDST.txtEndDate = 15
        frmDST.txtEndDate.Enabled = False
        frmDST.optEndByDate.Value = False
        frmDST.optEndByDOW.Value = True
    End If
    frmDST.Show 1 'modal
End Sub

Private Sub cmdNewLoc_Click()
    txtName.Text = ""
    txtLatDeg.Text = "0"
    txtLatMin.Text = "0"
    optS.Value = False
    txtLongDeg.Text = "0"
    txtLongMin.Text = "0"
    optW.Value = True
    optNeg.Value = True
    txtHr.Text = "0"
    txtMin.Text = "0"
    chkDST.Value = False
End Sub

Private Sub cmdRemove_Click()
    gztDirty = 1
    nLocHoles = nLocHoles + 1
    locHole(nLocHoles) = cboGaz.ItemData(cboGaz.ListIndex)
    cboGaz.RemoveItem cboGaz.ListIndex
End Sub

Private Sub cmdSel_Click()
    Dim i As Integer
    Dim s As String * 29

    gztDirty = 1
    pname = Trim(txtName)
    txtCurLoc.Text = pname
    'SetGeog setting
    s = BLANKNAME
    Mid(s, 1) = pname
    setting.name = s
    setting.namelen = Chr(Len(pname))
    setting.latd = Chr(txtLatDeg)
    setting.latm = Chr(txtLatMin)
    If optS.Value Then
        setting.latIsS = Chr(1)
    Else
        setting.latIsS = Chr(0)
    End If
    setting.longd = Chr(txtLongDeg)
    setting.longm = Chr(txtLongMin)
    If optW.Value Then
        setting.longIsW = Chr(1)
    Else
        setting.longIsW = Chr(0)
    End If
    If optNeg.Value Then
        setting.zoneIsM = Chr(1)
    Else
        setting.zoneIsM = Chr(0)
    End If
    setting.zoneH = Chr(txtHr)
    setting.zoneM = Chr(txtMin)
    If chkDST Then
        setting.hasDayLt = Chr(1)
    Else
        setting.hasDayLt = Chr(0)
    End If
    i = BinSearch(pname)
    If i >= 0 Then
        cboGaz.ListIndex = i
    End If
    latd = Asc(setting.latd)
    latm = Asc(setting.latm)
    latsgn = Asc(setting.latIsS)
    longd = Asc(setting.longd)
    longm = Asc(setting.longm)
    longsgn = Asc(setting.longIsW)
    zoneH = Asc(setting.zoneH)
    zoneM = Asc(setting.zoneM)
    zonesgn = Asc(setting.zoneIsM)
    hasDayLt = Asc(setting.hasDayLt)
    latitude = deg2rad(dm2deg(latd, latm))
    If latsgn <> 0 Then
        latitude = -latitude
    End If
    longitude = deg2rad(dm2deg(longd, longm))
    If longsgn <> 0 Then
        longitude = -longitude
    End If
    timeZone = zoneH + zoneM / 60#
    If zonesgn <> 0 Then
        timeZone = -timeZone
    End If
    direc = qibla()
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    'in case of control box close command, just hide
    ' the gazetter, so combo box need not be refilled
    If UnloadMode = 0 Then
        Hide
        Cancel = True
    End If
End Sub

