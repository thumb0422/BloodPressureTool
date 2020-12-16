object TUserForm: TTUserForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #29992#25143#19982#34880#21387#35745#35774#32622
  ClientHeight = 220
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object userLabel: TLabel
    Left = 32
    Top = 40
    Width = 47
    Height = 13
    Caption = #29992#25143'ID'#65306
  end
  object bpLabel: TLabel
    Left = 32
    Top = 88
    Width = 48
    Height = 13
    Caption = #34880#21387#35745#65306
  end
  object userEdit: TEdit
    Left = 104
    Top = 37
    Width = 150
    Height = 21
    TabOrder = 0
  end
  object bpEdit: TEdit
    Left = 104
    Top = 85
    Width = 150
    Height = 21
    TabOrder = 1
  end
  object saveBtn: TButton
    Left = 32
    Top = 160
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 2
    OnClick = saveBtnClick
  end
  object closeBtn: TButton
    Left = 144
    Top = 160
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 3
    OnClick = closeBtnClick
  end
end
