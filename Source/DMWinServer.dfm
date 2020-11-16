object dmWinSysServer: TdmWinSysServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 616
  Top = 251
  Height = 260
  Width = 317
  object tmr_Save: TTimer
    Enabled = False
    OnTimer = tmr_SaveTimer
    Left = 168
    Top = 16
  end
  object con_SQL: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 16
  end
  object qry_SQL: TADOQuery
    Connection = con_SQL
    Parameters = <>
    Left = 104
    Top = 16
  end
  object qry_Open: TADOQuery
    Connection = con_SQL
    Parameters = <>
    Left = 64
    Top = 80
  end
  object tmrKingConn: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrKingConnTimer
    Left = 232
    Top = 72
  end
end
