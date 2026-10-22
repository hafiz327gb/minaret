VERSION 5.00
Begin VB.Form frmAbout 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About Minaret"
   ClientHeight    =   4896
   ClientLeft      =   6156
   ClientTop       =   1452
   ClientWidth     =   5376
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   7.8
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4896
   ScaleWidth      =   5376
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdClose 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      Caption         =   "CLOSE"
      Default         =   -1  'True
      Height          =   372
      Left            =   3840
      TabIndex        =   4
      Top             =   4080
      Width           =   972
   End
   Begin VB.Label Label9 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "k.abdali@acm.org"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   372
      Left            =   360
      TabIndex        =   7
      Top             =   3600
      Width           =   1572
   End
   Begin VB.Image Image1 
      Appearance      =   0  'Flat
      Height          =   732
      Left            =   600
      Picture         =   "About.frx":0000
      Stretch         =   -1  'True
      Top             =   480
      Width           =   732
   End
   Begin VB.Label Label8 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   " Version 4.0.0 for 32-bit Windows                       May 2009"
      ForeColor       =   &H80000008&
      Height          =   372
      Left            =   1800
      TabIndex        =   6
      Top             =   840
      Width           =   3012
   End
   Begin VB.Label Label7 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "M I N A R E T"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   492
      Left            =   1920
      TabIndex        =   5
      Top             =   360
      Width           =   2652
   End
   Begin VB.Label Label4 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "http://geomete.com/abdali"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   252
      Left            =   360
      TabIndex        =   3
      Top             =   2640
      Width           =   2892
   End
   Begin VB.Label Label3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "by: Kamal Abdali"
      ForeColor       =   &H80000008&
      Height          =   252
      Left            =   360
      TabIndex        =   2
      Top             =   2400
      Width           =   2772
   End
   Begin VB.Label Label2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "For bug reports, suggestions, comments, and enquiries, contact the author at:"
      ForeColor       =   &H80000008&
      Height          =   492
      Left            =   360
      TabIndex        =   1
      Top             =   3120
      Width           =   4812
   End
   Begin VB.Label Label1 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "This program computes Islamic prayer schedules, the qibla direction, and the Hijri calendar.  It is free for personal use."
      ForeColor       =   &H80000008&
      Height          =   735
      Left            =   360
      TabIndex        =   0
      Top             =   1560
      Width           =   4815
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    Hide
End Sub

Private Sub Form_Load()
    top = (Screen.Height - Height) / 2
    Left = (Screen.Width - Width) / 2
End Sub


Private Sub Label8_Click()

End Sub
