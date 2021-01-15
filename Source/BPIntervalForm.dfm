object BPIntervalSetForm: TBPIntervalSetForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #38388#38548#21629#20196#35774#32622
  ClientHeight = 218
  ClientWidth = 184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 40
    Width = 100
    Height = 13
    Caption = #27979#37327#38388#38548':'#65288#20998#38047#65289
  end
  object IntervalEdit: TEdit
    Left = 40
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 0
    OnKeyPress = IntervalEditKeyPress
  end
  object saveBtn: TButton
    Left = 40
    Top = 136
    Width = 121
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = saveBtnClick
  end
end
