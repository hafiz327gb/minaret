VERSION 5.00
Begin VB.Form frmWelcome 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Welcome"
   ClientHeight    =   4800
   ClientLeft      =   9585
   ClientTop       =   3810
   ClientWidth     =   7020
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4800
   ScaleWidth      =   7020
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdClose 
      Caption         =   "CLOSE"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   492
      Left            =   2280
      TabIndex        =   5
      Top             =   4080
      Width           =   1332
   End
   Begin VB.Image Image2 
      Height          =   480
      Left            =   480
      Picture         =   "Welcome.frx":0000
      Top             =   2160
      Width           =   480
   End
   Begin VB.Label Label12 
      Caption         =   "in the"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3000
      TabIndex        =   11
      Top             =   2520
      Width           =   615
   End
   Begin VB.Label Label10 
      Caption         =   "Open Gazetteer"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   1080
      TabIndex        =   10
      Top             =   2520
      Width           =   1695
   End
   Begin VB.Image Image1 
      Appearance      =   0  'Flat
      Height          =   516
      Left            =   240
      Picture         =   "Welcome.frx":0442
      Stretch         =   -1  'True
      Top             =   120
      Width           =   516
   End
   Begin VB.Label Label11 
      Caption         =   "menu."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5880
      TabIndex        =   9
      Top             =   3240
      Width           =   735
   End
   Begin VB.Label Label9 
      Caption         =   "menu."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5040
      TabIndex        =   8
      Top             =   2520
      Width           =   855
   End
   Begin VB.Label Label8 
      Caption         =   "Help"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   5160
      TabIndex        =   7
      Top             =   3240
      Width           =   615
   End
   Begin VB.Label Label7 
      Caption         =   "Location"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   3960
      TabIndex        =   6
      Top             =   2520
      Width           =   1095
   End
   Begin VB.Label Label6 
      Caption         =   "Get more info about the program using the "
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   3240
      Width           =   4695
   End
   Begin VB.Label Label5 
      Caption         =   "To start, specify your location using"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1523
      TabIndex        =   3
      Top             =   2160
      Width           =   3975
   End
   Begin VB.Label Label4 
      Caption         =   "and the Hijri calendar."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800080&
      Height          =   375
      Left            =   2183
      TabIndex        =   2
      Top             =   1320
      Width           =   2655
   End
   Begin VB.Label Label3 
      Caption         =   "For computing Islamic prayer hours, the qibla direction,"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   10.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800080&
      Height          =   375
      Left            =   623
      TabIndex        =   1
      Top             =   960
      Width           =   5775
   End
   Begin VB.Label Label2 
      Caption         =   "M  I  N  A  R  E  T"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   28.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00008000&
      Height          =   612
      Left            =   1224
      TabIndex        =   0
      Top             =   120
      Width           =   4572
   End
End
Attribute VB_Name = "frmWelcome"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Hide
End Sub

