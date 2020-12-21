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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 559
    Width = 800
    Height = 41
    Align = alBottom
    TabOrder = 0
    object startBtn: TBitBtn
      Left = 200
      Top = 6
      Width = 75
      Height = 25
      Caption = #21551#21160'(&S)'
      TabOrder = 0
      OnClick = startBtnClick
    end
    object stopBtn: TBitBtn
      Left = 325
      Top = 6
      Width = 75
      Height = 25
      Caption = #20572#27490'(&E)'
      TabOrder = 1
      OnClick = stopBtnClick
    end
    object refreshBtn: TBitBtn
      Left = 450
      Top = 6
      Width = 75
      Height = 25
      Caption = #21047#26032'(&R)'
      TabOrder = 2
      OnClick = refreshBtnClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 800
    Height = 559
    Align = alClient
    TabOrder = 1
  end
end
