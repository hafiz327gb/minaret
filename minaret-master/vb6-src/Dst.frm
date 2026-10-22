VERSION 5.00
Begin VB.Form frmDST 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Start and End of Daylight Saving Time"
   ClientHeight    =   6096
   ClientLeft      =   1716
   ClientTop       =   2136
   ClientWidth     =   7812
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
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   6096
   ScaleWidth      =   7812
   ShowInTaskbar   =   0   'False
   Begin VB.Frame Frame1 
      Caption         =   "Daylight Saving Starts On"
      Height          =   5172
      Left            =   120
      TabIndex        =   17
      Top             =   120
      Width           =   3612
      Begin VB.Frame Frame2 
         Height          =   4452
         Left            =   120
         TabIndex        =   39
         Top             =   600
         Width           =   2292
         Begin VB.Frame Frame4 
            Height          =   2772
            Left            =   1200
            TabIndex        =   64
            Top             =   1560
            Width           =   972
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Thu"
               Height          =   252
               Index           =   6
               Left            =   120
               TabIndex        =   16
               Top             =   2400
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Wed"
               Height          =   252
               Index           =   5
               Left            =   120
               TabIndex        =   31
               Top             =   2040
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Tue"
               Height          =   252
               Index           =   4
               Left            =   120
               TabIndex        =   32
               Top             =   1680
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Mon"
               Height          =   252
               Index           =   3
               Left            =   120
               TabIndex        =   33
               Top             =   1320
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Sun"
               Height          =   252
               Index           =   2
               Left            =   120
               TabIndex        =   34
               Top             =   960
               Value           =   -1  'True
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Sat"
               Height          =   252
               Index           =   1
               Left            =   120
               TabIndex        =   35
               Top             =   600
               Width           =   732
            End
            Begin VB.OptionButton optDOWStart 
               Caption         =   "Fri"
               Height          =   252
               Index           =   0
               Left            =   120
               TabIndex        =   65
               Top             =   240
               Width           =   732
            End
         End
         Begin VB.Frame Frame3 
            Height          =   2052
            Left            =   120
            TabIndex        =   58
            Top             =   1560
            Width           =   972
            Begin VB.OptionButton optNumStart 
               Caption         =   "last"
               Height          =   252
               Index           =   0
               Left            =   120
               TabIndex        =   63
               Top             =   1680
               Width           =   732
            End
            Begin VB.OptionButton optNumStart 
               Caption         =   "4th"
               Height          =   252
               Index           =   4
               Left            =   120
               TabIndex        =   62
               Top             =   1320
               Width           =   732
            End
            Begin VB.OptionButton optNumStart 
               Caption         =   "3rd"
               Height          =   252
               Index           =   3
               Left            =   120
               TabIndex        =   61
               Top             =   960
               Width           =   732
            End
            Begin VB.OptionButton optNumStart 
               Caption         =   "2nd"
               Height          =   252
               Index           =   2
               Left            =   120
               TabIndex        =   60
               Top             =   600
               Width           =   732
            End
            Begin VB.OptionButton optNumStart 
               Caption         =   "1st"
               Height          =   252
               Index           =   1
               Left            =   120
               TabIndex        =   59
               Top             =   240
               Value           =   -1  'True
               Width           =   732
            End
         End
         Begin VB.TextBox txtStartDate 
            Height          =   288
            Left            =   720
            TabIndex        =   57
            Text            =   "15"
            Top             =   600
            Width           =   492
         End
         Begin VB.OptionButton optStartByDate 
            Caption         =   "A fixed date"
            Height          =   252
            Left            =   120
            TabIndex        =   41
            Top             =   240
            Width           =   1932
         End
         Begin VB.OptionButton optStartByDOW 
            Caption         =   "A fixed weekday"
            Height          =   252
            Left            =   120
            TabIndex        =   40
            Top             =   1200
            Value           =   -1  'True
            Width           =   1932
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   "Of"
         Height          =   4692
         Left            =   2520
         TabIndex        =   18
         Top             =   360
         Width           =   972
         Begin VB.OptionButton optMonStart 
            Caption         =   "Jan"
            Height          =   252
            Index           =   1
            Left            =   120
            TabIndex        =   30
            Top             =   360
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Feb"
            Height          =   252
            Index           =   2
            Left            =   120
            TabIndex        =   29
            Top             =   720
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Mar"
            Height          =   252
            Index           =   3
            Left            =   120
            TabIndex        =   28
            Top             =   1080
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Apr"
            Height          =   252
            Index           =   4
            Left            =   120
            TabIndex        =   27
            Top             =   1440
            Value           =   -1  'True
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "May"
            Height          =   252
            Index           =   5
            Left            =   120
            TabIndex        =   26
            Top             =   1800
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Jun"
            Height          =   252
            Index           =   6
            Left            =   120
            TabIndex        =   25
            Top             =   2160
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Jul"
            Height          =   252
            Index           =   7
            Left            =   120
            TabIndex        =   24
            Top             =   2520
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Aug"
            Height          =   252
            Index           =   8
            Left            =   120
            TabIndex        =   23
            Top             =   2880
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Sep"
            Height          =   252
            Index           =   9
            Left            =   120
            TabIndex        =   22
            Top             =   3240
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Oct"
            Height          =   252
            Index           =   10
            Left            =   120
            TabIndex        =   21
            Top             =   3600
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Nov"
            Height          =   252
            Index           =   11
            Left            =   120
            TabIndex        =   20
            Top             =   3960
            Width           =   732
         End
         Begin VB.OptionButton optMonStart 
            Caption         =   "Dec"
            Height          =   252
            Index           =   12
            Left            =   120
            TabIndex        =   19
            Top             =   4320
            Width           =   732
         End
      End
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   372
      Left            =   2160
      TabIndex        =   1
      Top             =   5520
      Width           =   972
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   372
      Left            =   4680
      TabIndex        =   0
      Top             =   5520
      Width           =   972
   End
   Begin VB.Frame Frame6 
      Caption         =   "Daylight Saving Ends On"
      Height          =   5172
      Left            =   4080
      TabIndex        =   2
      Top             =   120
      Width           =   3612
      Begin VB.Frame Frame7 
         Height          =   4452
         Left            =   120
         TabIndex        =   36
         Top             =   600
         Width           =   2292
         Begin VB.TextBox txtEndDate 
            Height          =   288
            Left            =   720
            TabIndex        =   56
            Text            =   "15"
            Top             =   600
            Width           =   492
         End
         Begin VB.Frame Frame9 
            Height          =   2772
            Left            =   1200
            TabIndex        =   48
            Top             =   1560
            Width           =   972
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Thu"
               Height          =   252
               Index           =   6
               Left            =   120
               TabIndex        =   55
               Top             =   2400
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Wed"
               Height          =   252
               Index           =   5
               Left            =   120
               TabIndex        =   54
               Top             =   2040
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Tue"
               Height          =   252
               Index           =   4
               Left            =   120
               TabIndex        =   53
               Top             =   1680
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Mon"
               Height          =   252
               Index           =   3
               Left            =   120
               TabIndex        =   52
               Top             =   1320
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Sun"
               Height          =   252
               Index           =   2
               Left            =   120
               TabIndex        =   51
               Top             =   960
               Value           =   -1  'True
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Sat"
               Height          =   252
               Index           =   1
               Left            =   120
               TabIndex        =   50
               Top             =   600
               Width           =   732
            End
            Begin VB.OptionButton optDOWEnd 
               Caption         =   "Fri"
               Height          =   252
               Index           =   0
               Left            =   120
               TabIndex        =   49
               Top             =   240
               Width           =   732
            End
         End
         Begin VB.Frame Frame8 
            Height          =   2052
            Left            =   120
            TabIndex        =   42
            Top             =   1560
            Width           =   972
            Begin VB.OptionButton optNumEnd 
               Caption         =   "last"
               Height          =   252
               Index           =   0
               Left            =   120
               TabIndex        =   47
               Top             =   1680
               Value           =   -1  'True
               Width           =   732
            End
            Begin VB.OptionButton optNumEnd 
               Caption         =   "4th"
               Height          =   252
               Index           =   4
               Left            =   120
               TabIndex        =   46
               Top             =   1320
               Width           =   732
            End
            Begin VB.OptionButton optNumEnd 
               Caption         =   "3rd"
               Height          =   252
               Index           =   3
               Left            =   120
               TabIndex        =   45
               Top             =   960
               Width           =   732
            End
            Begin VB.OptionButton optNumEnd 
               Caption         =   "2nd"
               Height          =   252
               Index           =   2
               Left            =   120
               TabIndex        =   44
               Top             =   600
               Width           =   732
            End
            Begin VB.OptionButton optNumEnd 
               Caption         =   "1st"
               Height          =   252
               Index           =   1
               Left            =   120
               TabIndex        =   43
               Top             =   240
               Width           =   732
            End
         End
         Begin VB.OptionButton optEndByDOW 
            Caption         =   "A fixed weekday "
            Height          =   252
            Left            =   120
            TabIndex        =   38
            Top             =   1200
            Value           =   -1  'True
            Width           =   2052
         End
         Begin VB.OptionButton optEndByDate 
            Caption         =   "A fixed date"
            Height          =   252
            Left            =   120
            TabIndex        =   37
            Top             =   240
            Width           =   1932
         End
      End
      Begin VB.Frame Frame10 
         Caption         =   "Of"
         Height          =   4692
         Left            =   2520
         TabIndex        =   3
         Top             =   360
         Width           =   972
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Jan"
            Height          =   252
            Index           =   1
            Left            =   120
            TabIndex        =   15
            Top             =   360
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Feb"
            Height          =   252
            Index           =   2
            Left            =   120
            TabIndex        =   14
            Top             =   720
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Mar"
            Height          =   252
            Index           =   3
            Left            =   120
            TabIndex        =   13
            Top             =   1080
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Apr"
            Height          =   252
            Index           =   4
            Left            =   120
            TabIndex        =   12
            Top             =   1440
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "May"
            Height          =   252
            Index           =   5
            Left            =   120
            TabIndex        =   11
            Top             =   1800
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Jun"
            Height          =   252
            Index           =   6
            Left            =   120
            TabIndex        =   10
            Top             =   2160
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Jul"
            Height          =   252
            Index           =   7
            Left            =   120
            TabIndex        =   9
            Top             =   2520
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Aug"
            Height          =   252
            Index           =   8
            Left            =   120
            TabIndex        =   8
            Top             =   2880
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Sep"
            Height          =   252
            Index           =   9
            Left            =   120
            TabIndex        =   7
            Top             =   3240
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Oct"
            Height          =   252
            Index           =   10
            Left            =   120
            TabIndex        =   6
            Top             =   3600
            Value           =   -1  'True
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Nov"
            Height          =   252
            Index           =   11
            Left            =   120
            TabIndex        =   5
            Top             =   3960
            Width           =   732
         End
         Begin VB.OptionButton optMonEnd 
            Caption         =   "Dec"
            Height          =   252
            Index           =   12
            Left            =   120
            TabIndex        =   4
            Top             =   4320
            Width           =   732
         End
      End
   End
End
Attribute VB_Name = "frmDST"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    Hide
End Sub

Private Sub cmdOK_Click()
    Dim i As Integer
    For i = 1 To 12
        If optMonStart(i).Value Then
            DSTStartMonth = i
            Exit For
        End If
    Next i
    If optStartByDate.Value Then
        i = RangeCheck(txtStartDate, 1, ndmnth(DSTStartMonth - 1))
        If i <= 0 Then
            Exit Sub
        End If
        DSTStartDate = i
    Else
        DSTStartDate = 0 'was -1
        For i = 0 To 4
            If optNumStart(i).Value Then
                DSTStartNum = i
                Exit For
            End If
        Next i
        For i = 0 To 6
            If optDOWStart(i).Value Then
                DSTStartDOW = i
                Exit For
            End If
        Next i
    End If
    For i = 1 To 12
        If optMonEnd(i).Value Then
            DSTFinMonth = i
            Exit For
        End If
    Next i
    If optEndByDate.Value Then
        i = RangeCheck(txtEndDate, 1, ndmnth(DSTFinMonth - 1))
        If i <= 0 Then
            Exit Sub
        End If
        DSTFinDate = i
    Else
        DSTFinDate = 0 'was -1
        For i = 0 To 4
            If optNumEnd(i).Value Then
                DSTFinNum = i
                Exit For
            End If
        Next i
        For i = 0 To 6
            If optDOWEnd(i).Value Then
                DSTEndDOW = i
                Exit For
            End If
        Next i
    End If
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub

Private Sub optEndByDate_Click()
    Dim i As Integer
    For i = 0 To 4
        optNumEnd(i).Enabled = False
    Next i
    For i = 0 To 6
        optDOWEnd(i).Enabled = False
    Next i
    txtEndDate.Enabled = True
End Sub

Private Sub optEndByDOW_Click()
    Dim i As Integer
    For i = 0 To 4
        optNumEnd(i).Enabled = True
    Next i
    For i = 0 To 6
        optDOWEnd(i).Enabled = True
    Next i
    txtEndDate.Enabled = False
End Sub

Private Sub optStartByDate_Click()
    Dim i As Integer
    For i = 0 To 4
        optNumStart(i).Enabled = False
    Next i
    For i = 0 To 6
        optDOWStart(i).Enabled = False
    Next i
    'Frame3.Enabled = False
    'Frame4.Enabled = False
    txtStartDate.Enabled = True
End Sub

Private Sub optStartByDOW_Click()
    Dim i As Integer
    For i = 0 To 4
        optNumStart(i).Enabled = True
    Next i
    For i = 0 To 6
        optDOWStart(i).Enabled = True
    Next i
    'Frame3.Enabled = True
    'Frame4.Enabled = True
    txtStartDate.Enabled = False
End Sub

