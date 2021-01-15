program BloodPressureProject;

uses
  SvcMgr,
  Forms,
  Windows,
  SysUtils,
  MidasLib,
  WinSysServer in 'WinSysServer.pas' {frm_SysServer},
  DMWinServer in 'DMWinServer.pas' {dmWinSysServer: TDataModule},
  USysServer in 'USysServer.pas',
  TLog in 'TLog.pas',
  ComDefine in 'ComDefine.pas',
  SetForm in 'SetForm.pas' {TSetForm},
  UserForm in 'UserForm.pas' {TUserForm},
  BPStatesForm in 'BPStatesForm.pas' {TBPStatesForm},
  BPModel in 'BPModel.pas',
  SQLite3 in 'plugin\SQLite3.pas',
  SQLiteTable3 in 'plugin\SQLiteTable3.pas',
  superdate in 'plugin\superdate.pas',
  superobject in 'plugin\superobject.pas',
  supertimezone in 'plugin\supertimezone.pas',
  supertypes in 'plugin\supertypes.pas',
  superxmlparser in 'plugin\superxmlparser.pas',
  HDBManager in 'HDBManager.pas',
  DetailInfoView in 'DetailInfoView.pas',
  DetailBPModel in 'DetailBPModel.pas',
  DataManager in 'DataManager.pas',
  DetailDataForm in 'DetailDataForm.pas' {TDetailDataForm},
  Tool in 'Tool.pas',
  SystemSetForm in 'SystemSetForm.pas' {SystemSet},
  Vcl.Themes,
  Vcl.Styles,
  BPIntervalForm in 'BPIntervalForm.pas' {BPIntervalSetForm};

{$R *.res}

//var
//  frm_Setup:Tfrm_Setup;
begin
  if not SysServer_Installing then
  begin
    CreateMutex(nil, True, PChar(_SysServerMutexID)); // 'SCKTSRVR');
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      MessageBox(0, PChar(SAlreadyRunning), _SysServerDisplayName, MB_ICONERROR);
      Halt;
    end;
  end;

  if SysServer_Installing or SysServer_StartService then
  begin
    SvcMgr.Application.Initialize;
    UserSysService := TUserSysService.CreateNew(SvcMgr.Application, 0);
    SvcMgr.Application.Title := _SysServerMainTitle;
//    TStyleManager.TrySetStyle('Luna');
    Application.CreateForm(Tfrm_SysServer, frm_SysServer);
  Application.CreateForm(TBPIntervalSetForm, BPIntervalSetForm);
  SvcMgr.Application.Run;
  end
  else
  begin
    Forms.Application.ShowMainForm := False;
    Forms.Application.Initialize;
    Forms.Application.CreateForm(Tfrm_SysServer, frm_SysServer);
    Forms.Application.Title := '血压计助手';
//    TStyleManager.TrySetStyle('Luna');
    frm_SysServer.Initialize(False);

//    TStyleManager.TrySetStyle('Glossy');
    Forms.Application.Run;
  end;        {
  Application.Initialize;
 // FDBConfing.AddDBConn(dbSQLServer,'中心服务器');
//  FDBConfing.AddDBConn(dbOracle,'电表服务器');
//  FDBConfing.AddDBConn(dbAccess,'皮带秤数据库');
//  FDBConfing.AddDBConn(dbKing,'组态王服务器');
 // Application.CreateForm(Tfrm_Setup, frm_Setup);
  CreateWinSetup(TDBConfInfo.GetDBConfig);
 // frm_Setup.SetConfig(TDBConfInfo.GetDBConfig);
  Application.Run;  }
end.

