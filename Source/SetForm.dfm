object TSetForm: TTSetForm
  Left = 0
  Top = 0
  Caption = #35774#32622
  ClientHeight = 295
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupLabel: TLabel
    Left = 32
    Top = 41
    Width = 36
    Height = 13
    Caption = #32452#21035#65306
  end
  object sNoLabel: TLabel
    Left = 32
    Top = 112
    Width = 36
    Height = 13
    Caption = #32534#21495#65306
  end
  object macLabel: TLabel
    Left = 32
    Top = 183
    Width = 34
    Height = 13
    Caption = 'MAC'#65306
  end
  object groupEdit: TEdit
    Left = 120
    Top = 37
    Width = 220
    Height = 24
    TabOrder = 0
  end
  object sNoEdit: TEdit
    Left = 120
    Top = 108
    Width = 220
    Height = 24
    TabOrder = 1
    Text = 'Edit1'
  end
  object macEdit: TEdit
    Left = 120
    Top = 179
    Width = 220
    Height = 24
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 56
    Top = 240
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 208
    Top = 240
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 4
    OnClick = Button2Click
  end
end
