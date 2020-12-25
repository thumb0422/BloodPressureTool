object TDetailDataForm: TTDetailDataForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #24403#26085#25968#25454#26597#30475
  ClientHeight = 531
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 481
    Width = 331
    Height = 50
    Align = alBottom
    TabOrder = 0
    object refreshBtn: TButton
      Left = 56
      Top = 16
      Width = 75
      Height = 25
      Caption = #21047#26032'(&R)'
      TabOrder = 0
      OnClick = refreshBtnClick
    end
    object closeBtn: TButton
      Left = 200
      Top = 16
      Width = 75
      Height = 25
      Caption = #20851#38381'(&Q)'
      TabOrder = 1
      OnClick = closeBtnClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 331
    Height = 481
    Align = alClient
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'MDBP'
        Title.Caption = 'DBP'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MSBP'
        Title.Caption = 'SBP'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MHR'
        Title.Caption = 'HR'
        Width = 100
        Visible = True
      end>
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 192
    object ClientDataSet1MSBP: TStringField
      FieldName = 'MSBP'
    end
    object ClientDataSet1MDBP: TStringField
      FieldName = 'MDBP'
    end
    object ClientDataSet1MHR: TStringField
      FieldName = 'MHR'
    end
    object ClientDataSet1MMac: TStringField
      FieldName = 'MMac'
      Size = 50
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 136
    Top = 96
  end
end
