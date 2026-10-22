VERSION 5.00
Begin VB.Form frmAngle 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Qibla  Angle"
   ClientHeight    =   4008
   ClientLeft      =   816
   ClientTop       =   2760
   ClientWidth     =   7452
   ControlBox      =   0   'False
   FillColor       =   &H00C0C0C0&
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8.4
      Charset         =   178
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4008
   ScaleWidth      =   7452
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdPrint 
      Caption         =   "Print"
      Height          =   492
      Left            =   480
      TabIndex        =   10
      Top             =   3120
      Width           =   1092
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   492
      Left            =   2040
      TabIndex        =   7
      Top             =   3120
      Width           =   1212
   End
   Begin VB.Label lblLoc 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Vancouver, British Columbia"
      Height          =   372
      Left            =   360
      TabIndex        =   9
      Top             =   360
      Width           =   3492
   End
   Begin VB.Line linQ 
      BorderWidth     =   2
      X1              =   5400
      X2              =   6240
      Y1              =   1920
      Y2              =   840
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
      TabIndex        =   8
      Top             =   360
      Width           =   372
   End
   Begin VB.Label lblQib 
      BackStyle       =   0  'Transparent
      Caption         =   "of  north"
      Height          =   372
      Left            =   2160
      TabIndex        =   6
      Top             =   2040
      Width           =   1092
   End
   Begin VB.Label lblAngle 
      BackStyle       =   0  'Transparent
      Caption         =   "56   35   west"
      Height          =   372
      Left            =   360
      TabIndex        =   5
      Top             =   2040
      Width           =   1692
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "The  QIBLA  is"
      Height          =   372
      Left            =   840
      TabIndex        =   4
      Top             =   1680
      Width           =   1812
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "S"
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
      Left            =   5280
      TabIndex        =   3
      Top             =   2880
      Width           =   372
   End
   Begin VB.Label Label3 
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
      Left            =   5280
      TabIndex        =   2
      Top             =   480
      Width           =   372
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "E"
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
      Left            =   6600
      TabIndex        =   1
      Top             =   1680
      Width           =   372
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "W"
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
      Left            =   3960
      TabIndex        =   0
      Top             =   1680
      Width           =   372
   End
   Begin VB.Line Line2 
      X1              =   5400
      X2              =   5400
      Y1              =   3240
      Y2              =   600
   End
   Begin VB.Line Line1 
      X1              =   3960
      X2              =   6840
      Y1              =   1920
      Y2              =   1920
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00000000&
      FillColor       =   &H00C0FFC0&
      FillStyle       =   0  'Solid
      Height          =   2652
      Left            =   3960
      Shape           =   2  'Oval
      Top             =   600
      Width           =   2892
   End
End
Attribute VB_Name = "frmAngle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdPrint_Click()
    PrintForm
End Sub

Private Sub Command1_Click()
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


