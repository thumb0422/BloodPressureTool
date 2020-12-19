program BloodPressureProject;

uses
  SvcMgr,
  Forms,
  Windows,
  SysUtils,
  WinSysServer in 'WinSysServer.pas' {frm_SysServer},
  DMWinServer in 'DMWinServer.pas' {dmWinSysServer: TDataModule},
  USysServer in 'USysServer.pas',
  TLog in 'TLog.pas',
  TDBManager in 'TDBManager.pas',
  ComDefine in 'ComDefine.pas',
  SetForm in 'SetForm.pas' {TSetForm},
  UserForm in 'UserForm.pas' {TUserForm},
  BPStatesForm in 'BPStatesForm.pas' {TBPStatesForm},
  BPModel in 'BPModel.pas';

{$R *.res}

//var
//  frm_Setup:Tfrm_Setup;
begin
  if not SysServer_Installing then
  begin
    CreateMutex(nil, True,PChar(_SysServerMutexID));// 'SCKTSRVR');
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
    Application.CreateForm(Tfrm_SysServer, frm_SysServer);
  SvcMgr.Application.Run;
  end
  else
  begin
    Forms.Application.ShowMainForm := False;
    Forms.Application.Initialize;
    Forms.Application.CreateForm(Tfrm_SysServer, frm_SysServer);
    frm_SysServer.Initialize(False);
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
