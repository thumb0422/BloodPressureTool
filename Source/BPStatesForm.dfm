object TBPStatesForm: TTBPStatesForm
  Left = 0
  Top = 0
  Caption = #34880#21387#35745#29366#24577
  ClientHeight = 590
  ClientWidth = 790
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 790
    Height = 590
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 0
    ExplicitWidth = 800
    ExplicitHeight = 600
  end
  object PopupMenu1: TPopupMenu
    Left = 488
    Top = 120
    object refreshMenu: TMenuItem
      Caption = #20840#37096#21047#26032'(&R)'
      OnClick = refreshMenuClick
    end
    object allStartMenu: TMenuItem
      Caption = #20840#37096#24320#22987'(&S)'
      Visible = False
      OnClick = allStartMenuClick
    end
    object allStopMenu: TMenuItem
      Caption = #20840#37096#20572#27490'(&E)'
      Visible = False
      OnClick = allStopMenuClick
    end
  end
end
