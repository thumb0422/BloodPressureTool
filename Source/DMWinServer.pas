unit DMWinServer;

interface

uses
  SysUtils, Messages, Windows, Classes, Forms, DB, ADODB, ExtCtrls, USysServer,
  Dialogs;

type
  TdmWinSysServer = class(TDataModule)
    tmr_Save: TTimer;
    con_SQL: TADOConnection;
    qry_SQL: TADOQuery;
    qry_Open: TADOQuery;
    tmrKingConn: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure tmr_SaveTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure tmrKingConnTimer(Sender: TObject);
  private
    { Private declarations }
    FWindowHandle: HWND;
    FIsRun: Boolean;
  private
    FReadRecordCount: Integer; //总共读取的条数
    FUploadRecordCount: Integer; //总共提交的数据条数
    FUploadSQLList: TStringList;  //上传的SQL语句
    FMySection: TRTLCriticalSection; //临界区
    function UploadSQLExcel(conn: TADOConnection; isAll: Boolean): Integer;
    function OpenSQLExcel(conn: TADOConnection; const sqlstr: string): TADOQuery;
  private //窗体，可以用来处理消息
    FMainHandle: THandle;
    procedure WndProc(var Msg: TMessage);
  private
  private
  private
    FPrevReadSS_Time: TDateTime; //上一次读取的时间
    procedure RefreshConfig;
  public
    { Public declarations }
    {启动系统的业务功能}
    procedure Run;
    {停止系统的业务}
    procedure Stop;
    {设置当前是否有错误或警告}
    procedure SetDMServerICONState(value: TDMServerICONState);
    procedure ShowAbout; //关于
    procedure ShowSetup; //设置
    procedure ShowWinDataMonitor; //数据监测窗体
//    procedure ShowWinKingEQU;
  public
  end;

implementation

uses
  DateUtils, Contnrs, StrUtils, Controls, Math,ComDefine;

{$R *.dfm}


{ TdmWinSysServer }

procedure TdmWinSysServer.Run;
var
  i: Integer;
  Err: string;
begin
  FIsRun := False;
//启动系统的业务功能
  SetDMServerICONState(dsiOK);
  //刷新参数
  RefreshConfig;

 { begin  //启动失败
    SetDMServerICONState(dsiWarning);
    DMServerAddLog('启动失败。 '+#13+Err);
      //设置警告
    SetDMServerICONState(dsiWarning);
    PostMessage(GetDMMainHandle,WM_DMServerState,CO_DMServerState_Stop,0);
  end }

  //通知界面，程序启动
  tmr_Save.Enabled := True;
  //通知首页，程序启动
  PostMessage(GetDMMainHandle, WM_DMServerState, CO_DMServerState_Run, 0);
  FIsRun := True;

end;

procedure TdmWinSysServer.Stop;
begin
  FIsRun := False;
//停止系统的业务功能
  tmr_Save.Enabled := False;

  SetDMServerICONState(dsiOK);
  //通知首页，停止完成
  PostMessage(GetDMMainHandle, WM_DMServerState, CO_DMServerState_Stop, 0);
end;

procedure TdmWinSysServer.DataModuleCreate(Sender: TObject);
var
  i: Integer;
begin
  FWindowHandle := Classes.AllocateHWnd(WndProc);
  FUploadSQLList := TStringList.Create;
  InitializeCriticalSection(FMySection);
end;

function TdmWinSysServer.UploadSQLExcel(conn: TADOConnection; isAll: Boolean): Integer;
var
  i, L: Integer;
  Err: string;
begin
  if FUploadSQLList.Count = 0 then
  begin
    DMServerAddLog('上传数据取消，空的SQL语句 ');
    Exit;
  end;
  //进入临界区
  EnterCriticalSection(FMySection);

  Result := -1;
  if False = conn.Connected then
  begin
  {  if False=TDBConfInfo.GetDBConfig.GetConn(dbSQLServer,conn,Err) then
    begin
      DMServerAddLog('数据库连接失败，不能上传实时数据... '+#13+Err);
      //设置警告
      SetDMServerICONState(dsiWarning);
      Exit;
    end
    else
      DMServerAddLog('上传数据库连接成功 ');  }
  end;

  try
    qry_SQL.SQL.Clear;
    i := 0;
    L := FUploadSQLList.Count;
    if isAll then
    begin
      for i := 0 to FUploadSQLList.Count - 1 do
      begin
        qry_SQL.SQL.Add(FUploadSQLList.Strings[i]);
        FUploadRecordCount := FUploadRecordCount + 1;
      end;
      FUploadSQLList.Clear;

      try
        if qry_SQL.SQL.Count > 0 then
          qry_SQL.ExecSQL;
        qry_SQL.SQL.Clear;

        Application.ProcessMessages;
      except
        on E: Exception do
        begin
          DMServerAddLog('上传到服务器错误。' + #13 + E.Message);
          conn.Close;
        end;
      end;
    end
    else
    begin
      while FUploadSQLList.Count > 0 do
      begin
        qry_SQL.SQL.Add(FUploadSQLList.Strings[i]);
        FUploadSQLList.Delete(i);
        if (qry_SQL.SQL.Count > 10) or ((qry_SQL.SQL.Count > 0) and (FUploadSQLList.Count = 0)) then
        begin
          try
            qry_SQL.ExecSQL;
            qry_SQL.SQL.Clear;

            FUploadRecordCount := FUploadRecordCount + 1;
            Application.ProcessMessages;
          except
            on E: Exception do
            begin
              DMServerAddLog('上传到服务器错误。' + #13 + E.Message);
              conn.Close;
              Break;
            end;
          end;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(FMySection);
   // InterlockedExchange(FIsUploadEnd,0);
  end;
end;

procedure TdmWinSysServer.ShowSetup;
begin
  Showmessage('设置窗体');
  //if CreateWinSetup(TDBConfInfo. GetDBConfig) then
  //  RefreshConfig;
end;

procedure TdmWinSysServer.RefreshConfig;
var
  bo: Boolean;
begin
  Showmessage('刷新当前的参数');
//刷新当前的设置
//  FLEDDataList.MaxShowCount:=TDBConfInfo.GetDBConfig.GeneralSetup.ShowMaxCount_SS;
  bo := tmr_Save.Enabled;
  tmr_Save.Enabled := False;
  tmr_Save.Interval := 10000; //  TDBConfInfo.GetDBConfig.GeneralSetup. Read_Interval*1000;
  tmr_Save.Enabled := bo;
end;

procedure TdmWinSysServer.tmr_SaveTimer(Sender: TObject);
begin
//定时保存数据
  Showmessage('定时保存');
  //SaveToDB;
end;

procedure TdmWinSysServer.SetDMServerICONState(value: TDMServerICONState);
begin
  {设置系统运行图标状态 正常，警告，错误}
  case value of
    dsiOK:
      PostMessage(GetDMMainHandle, WM_DMServerICONState, MB_OK, 0);
    dsiWarning:
      PostMessage(GetDMMainHandle, WM_DMServerICONState, MB_ICONWARNING, 0);
    dsiError:
      PostMessage(GetDMMainHandle, WM_DMServerICONState, MB_ICONERROR, 0);
  end;
end;

procedure TdmWinSysServer.ShowAbout;
begin

end;

procedure TdmWinSysServer.ShowWinDataMonitor;
begin
  Showmessage('数据监测窗体');
  //if Assigned(FKvStationList) then
  //if FKvStationList.ActiveID>=0 then
  //  CreateWinDataMonitor(con_SQL, FKvStationList.Items[FKvStationList.ActiveID])
end;

function TdmWinSysServer.OpenSQLExcel(conn: TADOConnection; const sqlstr: string): TADOQuery;
var
  i, L: Integer;
  Err: string;
begin
{  Result:=nil;
  if False=conn.Connected then
  begin
    if False=TDBConfInfo.GetDBConfig.GetConn(dbSQLServer,conn,Err) then
    begin
      DMServerAddLog('数据库连接失败，不能读取数据 '+#13+Err);
      //设置警告
      SetDMServerICONState(dsiWarning);
      Exit;
    end
    else
      DMServerAddLog('读取数据库连接成功 ');
  end;

  qry_Open.SQL.Clear;
  qry_Open.SQL.Text:=sqlstr;
  try
    qry_Open.Open;
    Result:=qry_Open;
  except on E:Exception do
    begin
      DMServerAddLog('读取数据错误。'+#13+E.Message);
      qry_Open.Close;
    end;
  end;}
end;

procedure TdmWinSysServer.DataModuleDestroy(Sender: TObject);
var
  i: Integer;
begin
 //释放
  DeleteCriticalSection(FMySection);
 // MSComm_HZ.Free;
end;

procedure TdmWinSysServer.WndProc(var Msg: TMessage);
begin
   { if Msg.Msg = WM_DTCKReceive then
      try
       // DTCKReceive(WParam,LParam);
      except
        Application.HandleException(Self);
      end
    else    }

  Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TdmWinSysServer.tmrKingConnTimer(Sender: TObject);
begin
  tmrKingConn.Enabled := False;
  if tmrKingConn.Tag = 0 then  //先停止运行
  begin
    Stop;
    tmrKingConn.Tag := 1;
    tmrKingConn.Enabled := True;
  end
  else if tmrKingConn.Tag > 0 then
  begin
    Run;
    if FIsRun then
    begin
      tmrKingConn.Tag := -1;
      DMServerAddLog('准备重新连接失败，五秒后重试...');
    end
    else
    begin
      tmrKingConn.Tag := tmrKingConn.Tag + 1;
      tmrKingConn.Enabled := True;
      DMServerAddLog('准备重新连接成功。');
    end;
  end;
end;

end.

