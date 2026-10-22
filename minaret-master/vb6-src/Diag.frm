VERSION 5.00
Begin VB.Form frmDiag 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Shadow Diagram for a Day"
   ClientHeight    =   6240
   ClientLeft      =   252
   ClientTop       =   1632
   ClientWidth     =   8628
   DrawStyle       =   5  'Transparent
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
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   6240
   ScaleWidth      =   8628
   Begin VB.CommandButton cmdPrint 
      Caption         =   "Print"
      Height          =   372
      Left            =   1800
      TabIndex        =   32
      Top             =   5160
      Width           =   972
   End
   Begin VB.CommandButton cmdCompute 
      Caption         =   "Recompute"
      Height          =   372
      Left            =   240
      TabIndex        =   18
      Top             =   5160
      Width           =   1212
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   372
      Left            =   720
      TabIndex        =   17
      Top             =   5640
      Width           =   1692
   End
   Begin VB.Frame Frame 
      Caption         =   "Date"
      Height          =   4815
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2535
      Begin VB.OptionButton optMonth 
         Caption         =   "January"
         Height          =   252
         Index           =   0
         Left            =   120
         TabIndex        =   14
         Top             =   480
         Value           =   -1  'True
         Width           =   1332
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "February"
         Height          =   252
         Index           =   1
         Left            =   120
         TabIndex        =   13
         Top             =   840
         Width           =   1332
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "March"
         Height          =   252
         Index           =   2
         Left            =   120
         TabIndex        =   12
         Top             =   1200
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "April"
         Height          =   252
         Index           =   3
         Left            =   120
         TabIndex        =   11
         Top             =   1560
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "May"
         Height          =   252
         Index           =   4
         Left            =   120
         TabIndex        =   10
         Top             =   1920
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "June"
         Height          =   252
         Index           =   5
         Left            =   120
         TabIndex        =   9
         Top             =   2280
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "July"
         Height          =   252
         Index           =   6
         Left            =   120
         TabIndex        =   8
         Top             =   2640
         Width           =   972
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "August"
         Height          =   252
         Index           =   7
         Left            =   120
         TabIndex        =   7
         Top             =   3000
         Width           =   1212
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "September"
         Height          =   252
         Index           =   8
         Left            =   120
         TabIndex        =   6
         Top             =   3360
         Width           =   1452
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "October"
         Height          =   252
         Index           =   9
         Left            =   120
         TabIndex        =   5
         Top             =   3720
         Width           =   1212
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "November"
         Height          =   252
         Index           =   10
         Left            =   120
         TabIndex        =   4
         Top             =   4080
         Width           =   1452
      End
      Begin VB.OptionButton optMonth 
         Caption         =   "December"
         Height          =   252
         Index           =   11
         Left            =   120
         TabIndex        =   3
         Top             =   4440
         Width           =   1452
      End
      Begin VB.TextBox txtYear 
         Height          =   288
         Left            =   1560
         TabIndex        =   2
         Top             =   2880
         Width           =   732
      End
      Begin VB.TextBox txtDay 
         Height          =   288
         Left            =   1560
         TabIndex        =   1
         Top             =   1560
         Width           =   492
      End
      Begin VB.Label lblDOW 
         Alignment       =   1  'Right Justify
         Caption         =   "Wednesday"
         Height          =   255
         Left            =   960
         TabIndex        =   30
         Top             =   240
         Width           =   1455
      End
      Begin VB.Label Label1 
         Caption         =   "Year"
         Height          =   252
         Index           =   1
         Left            =   1560
         TabIndex        =   16
         Top             =   2640
         Width           =   612
      End
      Begin VB.Label Label1 
         Caption         =   "Day"
         Height          =   252
         Index           =   0
         Left            =   1560
         TabIndex        =   15
         Top             =   1320
         Width           =   612
      End
   End
   Begin VB.Label lblLoc 
      Alignment       =   2  'Center
      Caption         =   "Vancouver, British Columbia"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   492
      Left            =   3000
      TabIndex        =   31
      Top             =   240
      Width           =   5412
   End
   Begin VB.Label lblQ 
      BackStyle       =   0  'Transparent
      Caption         =   "Q"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   372
      Left            =   6480
      TabIndex        =   29
      Top             =   1920
      Width           =   372
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   7
      Left            =   3360
      TabIndex        =   21
      Top             =   1800
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   6
      Left            =   3000
      TabIndex        =   28
      Top             =   2760
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   5
      Left            =   3480
      TabIndex        =   27
      Top             =   3840
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   4
      Left            =   5640
      TabIndex        =   26
      Top             =   4320
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   3
      Left            =   6840
      TabIndex        =   25
      Top             =   3720
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   2
      Left            =   7200
      TabIndex        =   24
      Top             =   2760
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   1
      Left            =   6720
      TabIndex        =   23
      Top             =   1800
      Width           =   1104
   End
   Begin VB.Label lblShad 
      BackStyle       =   0  'Transparent
      Caption         =   "12:55 PM"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.6
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   252
      Index           =   0
      Left            =   5880
      TabIndex        =   22
      Top             =   1320
      Width           =   1104
   End
   Begin VB.Line linShad 
      Index           =   3
      X1              =   5652
      X2              =   6726
      Y1              =   2892
      Y2              =   3726
   End
   Begin VB.Line linShad 
      Index           =   4
      X1              =   5652
      X2              =   5652
      Y1              =   2892
      Y2              =   4206
   End
   Begin VB.Line linShad 
      Index           =   5
      X1              =   5646
      X2              =   4680
      Y1              =   2892
      Y2              =   3846
   End
   Begin VB.Line linShad 
      Index           =   6
      X1              =   5646
      X2              =   4200
      Y1              =   2892
      Y2              =   2892
   End
   Begin VB.Line linShad 
      Index           =   7
      X1              =   5646
      X2              =   4560
      Y1              =   2892
      Y2              =   2040
   End
   Begin VB.Line linShad 
      Index           =   0
      X1              =   5652
      X2              =   5886
      Y1              =   2892
      Y2              =   1560
   End
   Begin VB.Line linShad 
      Index           =   1
      X1              =   5652
      X2              =   6726
      Y1              =   2892
      Y2              =   2040
   End
   Begin VB.Line linShad 
      Index           =   2
      X1              =   5652
      X2              =   7086
      Y1              =   2892
      Y2              =   2892
   End
   Begin VB.Label Label3 
      Caption         =   $"Diag.frx":0000
      Height          =   1212
      Left            =   3480
      TabIndex        =   20
      Top             =   5040
      Width           =   4812
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "N"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   372
      Left            =   5520
      TabIndex        =   19
      Top             =   840
      Width           =   372
   End
   Begin VB.Line linN 
      X1              =   5652
      X2              =   5652
      Y1              =   1560
      Y2              =   2892
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      FillColor       =   &H00C0FFC0&
      FillStyle       =   0  'Solid
      Height          =   2652
      Left            =   4200
      Shape           =   2  'Oval
      Top             =   1560
      Width           =   2892
   End
End
Attribute VB_Name = "frmDiag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub cmdCompute_Click()
    Dim i As Integer
    Dim j As Integer
    For i = 0 To 11
        If optMonth(i).Value Then
            ADMonth = i + 1
            Exit For
        End If
    Next i
    i = RangeCheck(txtYear, 1901, 2200)
    If i <= 0 Then
        Exit Sub
    End If
    ADYear = i
    If ADMonth = 2 Then
        j = 28 + IsLeap(ADYear)
    Else
        j = ndmnth(ADMonth - 1)
    End If
    i = RangeCheck(txtDay, 1, j)
    If i <= 0 Then
        Exit Sub
    End If
    ADday = i
    DrawShadow
    lblLoc = pname
End Sub

Private Sub cmdPrint_Click()
    PrintForm
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


