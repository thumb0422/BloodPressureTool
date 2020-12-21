object TSetForm: TTSetForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35774#32622
  ClientHeight = 404
  ClientWidth = 768
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 518
    Height = 404
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
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MMac'
        ReadOnly = True
        Title.Caption = 'Mac'#22320#22336
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MGroup'
        ReadOnly = True
        Title.Caption = 'IP'#22320#22336
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MDesc'
        ReadOnly = True
        Title.Caption = #22791#27880
        Width = 150
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 518
    Top = 0
    Width = 250
    Height = 404
    Align = alRight
    TabOrder = 1
    object GroupLabel: TLabel
      Left = 20
      Top = 17
      Width = 22
      Height = 13
      Caption = 'IP'#65306
    end
    object sNoLabel: TLabel
      Left = 20
      Top = 100
      Width = 36
      Height = 13
      Caption = #32534#21495#65306
    end
    object macLabel: TLabel
      Left = 20
      Top = 183
      Width = 34
      Height = 13
      Caption = 'MAC'#65306
    end
    object descLabel: TLabel
      Left = 22
      Top = 260
      Width = 36
      Height = 13
      Caption = #22791#27880#65306
    end
    object saveBtn: TButton
      Left = 168
      Top = 328
      Width = 75
      Height = 25
      Caption = #20445#23384'(&S)'
      TabOrder = 5
      OnClick = saveBtnClick
    end
    object addBtn: TButton
      Left = 6
      Top = 328
      Width = 75
      Height = 25
      Caption = #26032#22686'(&A)'
      TabOrder = 0
      OnClick = addBtnClick
    end
    object groupEdit: TDBEdit
      Left = 64
      Top = 14
      Width = 153
      Height = 21
      DataField = 'MGroup'
      DataSource = DataSource1
      TabOrder = 1
    end
    object noEdit: TDBEdit
      Left = 62
      Top = 100
      Width = 153
      Height = 21
      DataField = 'MNo'
      DataSource = DataSource1
      TabOrder = 2
    end
    object macEdit: TDBEdit
      Left = 60
      Top = 180
      Width = 153
      Height = 21
      DataField = 'MMac'
      DataSource = DataSource1
      TabOrder = 3
    end
    object descEdit: TDBEdit
      Left = 64
      Top = 260
      Width = 153
      Height = 21
      DataField = 'MDesc'
      DataSource = DataSource1
      TabOrder = 4
    end
    object delBtn: TButton
      Left = 87
      Top = 328
      Width = 75
      Height = 25
      Caption = #21024#38500'(&D)'
      TabOrder = 6
      OnClick = delBtnClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
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
  end
end
