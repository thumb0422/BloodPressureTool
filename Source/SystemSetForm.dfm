object SystemSet: TSystemSet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35774#32622
  ClientHeight = 219
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object timeLabel: TLabel
    Left = 48
    Top = 64
    Width = 60
    Height = 13
    Caption = #26102#38388#38388#38548#65306
  end
  object Label1: TLabel
    Left = 239
    Top = 64
    Width = 24
    Height = 13
    Caption = #20998#38047
  end
  object timeEdit: TEdit
    Left = 112
    Top = 61
    Width = 121
    Height = 21
    TabOrder = 0
    OnKeyPress = timeEditKeyPress
  end
  object saveBtn: TButton
    Left = 56
    Top = 120
    Width = 185
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = saveBtnClick
  end
end
