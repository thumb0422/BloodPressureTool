object TBPStatesForm: TTBPStatesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #34880#21387#35745#29366#24577
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 488
    Top = 120
    object refreshMenu: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = refreshMenuClick
    end
  end
end
