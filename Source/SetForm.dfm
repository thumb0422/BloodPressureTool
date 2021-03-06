object TSetForm: TTSetForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #34880#21387#35745#20449#24687#24405#20837
  ClientHeight = 435
  ClientWidth = 773
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 523
    Height = 435
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'MNo'
        ReadOnly = True
        Title.Caption = #32534#21495
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MMac'
        ReadOnly = True
        Title.Caption = 'Mac'#22320#22336
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MGroup'
        ReadOnly = True
        Title.Caption = 'IP'#22320#22336
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MInterval'
        Title.Caption = #38388#38548#26102#38388
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'MDesc'
        ReadOnly = True
        Title.Caption = #22791#27880
        Width = 120
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 523
    Top = 0
    Width = 250
    Height = 435
    Align = alRight
    TabOrder = 1
    object GroupLabel: TLabel
      Left = 12
      Top = 13
      Width = 26
      Height = 14
      Caption = 'IP'#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sNoLabel: TLabel
      Left = 12
      Top = 86
      Width = 39
      Height = 14
      Caption = #32534#21495#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object macLabel: TLabel
      Left = 12
      Top = 159
      Width = 41
      Height = 14
      Caption = 'MAC'#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object descLabel: TLabel
      Left = 12
      Top = 241
      Width = 39
      Height = 14
      Caption = #22791#27880#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object saveBtn: TButton
      Left = 134
      Top = 336
      Width = 75
      Height = 25
      Caption = #20445#23384'(&S)'
      TabOrder = 5
      OnClick = saveBtnClick
    end
    object addBtn: TButton
      Left = 31
      Top = 305
      Width = 75
      Height = 25
      Caption = #26032#22686'(&A)'
      TabOrder = 4
      OnClick = addBtnClick
    end
    object groupEdit: TDBEdit
      Left = 80
      Top = 11
      Width = 153
      Height = 21
      DataField = 'MGroup'
      DataSource = DataSource1
      TabOrder = 0
    end
    object noEdit: TDBEdit
      Left = 80
      Top = 84
      Width = 153
      Height = 21
      DataField = 'MNo'
      DataSource = DataSource1
      TabOrder = 1
    end
    object macEdit: TDBEdit
      Left = 80
      Top = 157
      Width = 153
      Height = 21
      DataField = 'MMac'
      DataSource = DataSource1
      TabOrder = 2
    end
    object descEdit: TDBEdit
      Left = 80
      Top = 239
      Width = 153
      Height = 21
      DataField = 'MDesc'
      DataSource = DataSource1
      TabOrder = 3
    end
    object delBtn: TButton
      Left = 31
      Top = 336
      Width = 75
      Height = 25
      Caption = #21024#38500'(&D)'
      TabOrder = 6
      OnClick = delBtnClick
    end
    object editBtn: TButton
      Left = 134
      Top = 305
      Width = 75
      Height = 25
      Caption = #20462#25913'&E)'
      TabOrder = 7
      OnClick = editBtnClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    OnStateChange = DataSource1StateChange
    Left = 144
    Top = 136
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 288
    Top = 136
    object ClientDataSet1MNo: TStringField
      FieldName = 'MNo'
      Size = 50
    end
    object ClientDataSet1MMac: TStringField
      FieldName = 'MMac'
      Size = 50
    end
    object ClientDataSet1MGroup: TStringField
      FieldName = 'MGroup'
      Size = 50
    end
    object ClientDataSet1MDesc: TStringField
      FieldName = 'MDesc'
      Size = 250
    end
    object ClientDataSet1MInterval: TStringField
      FieldName = 'MInterval'
      Size = 5
    end
  end
end
