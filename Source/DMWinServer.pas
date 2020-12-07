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
    FReadRecordCount: Integer; //�ܹ���ȡ������
    FUploadRecordCount: Integer; //�ܹ��ύ����������
    FUploadSQLList: TStringList;  //�ϴ���SQL���
    FMySection: TRTLCriticalSection; //�ٽ���
    function UploadSQLExcel(conn: TADOConnection; isAll: Boolean): Integer;
    function OpenSQLExcel(conn: TADOConnection; const sqlstr: string): TADOQuery;
  private //���壬��������������Ϣ
    FMainHandle: THandle;
    procedure WndProc(var Msg: TMessage);
  private
  private
  private
    FPrevReadSS_Time: TDateTime; //��һ�ζ�ȡ��ʱ��
    procedure RefreshConfig;
  public
    { Public declarations }
    {����ϵͳ��ҵ����}
    procedure Run;
    {ֹͣϵͳ��ҵ��}
    procedure Stop;
    {���õ�ǰ�Ƿ��д���򾯸�}
    procedure SetDMServerICONState(value: TDMServerICONState);
    procedure ShowAbout; //����
    procedure ShowSetup; //����
    procedure ShowWinDataMonitor; //���ݼ�ⴰ��
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
//����ϵͳ��ҵ����
  SetDMServerICONState(dsiOK);
  //ˢ�²���
  RefreshConfig;

 { begin  //����ʧ��
    SetDMServerICONState(dsiWarning);
    DMServerAddLog('����ʧ�ܡ� '+#13+Err);
      //���þ���
    SetDMServerICONState(dsiWarning);
    PostMessage(GetDMMainHandle,WM_DMServerState,CO_DMServerState_Stop,0);
  end }

  //֪ͨ���棬��������
  tmr_Save.Enabled := True;
  //֪ͨ��ҳ����������
  PostMessage(GetDMMainHandle, WM_DMServerState, CO_DMServerState_Run, 0);
  FIsRun := True;

end;

procedure TdmWinSysServer.Stop;
begin
  FIsRun := False;
//ֹͣϵͳ��ҵ����
  tmr_Save.Enabled := False;

  SetDMServerICONState(dsiOK);
  //֪ͨ��ҳ��ֹͣ���
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
    DMServerAddLog('�ϴ�����ȡ�����յ�SQL��� ');
    Exit;
  end;
  //�����ٽ���
  EnterCriticalSection(FMySection);

  Result := -1;
  if False = conn.Connected then
  begin
  {  if False=TDBConfInfo.GetDBConfig.GetConn(dbSQLServer,conn,Err) then
    begin
      DMServerAddLog('���ݿ�����ʧ�ܣ������ϴ�ʵʱ����... '+#13+Err);
      //���þ���
      SetDMServerICONState(dsiWarning);
      Exit;
    end
    else
      DMServerAddLog('�ϴ����ݿ����ӳɹ� ');  }
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
          DMServerAddLog('�ϴ�������������' + #13 + E.Message);
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
              DMServerAddLog('�ϴ�������������' + #13 + E.Message);
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
  Showmessage('���ô���');
  //if CreateWinSetup(TDBConfInfo. GetDBConfig) then
  //  RefreshConfig;
end;

procedure TdmWinSysServer.RefreshConfig;
var
  bo: Boolean;
begin
  Showmessage('ˢ�µ�ǰ�Ĳ���');
//ˢ�µ�ǰ������
//  FLEDDataList.MaxShowCount:=TDBConfInfo.GetDBConfig.GeneralSetup.ShowMaxCount_SS;
  bo := tmr_Save.Enabled;
  tmr_Save.Enabled := False;
  tmr_Save.Interval := 10000; //  TDBConfInfo.GetDBConfig.GeneralSetup. Read_Interval*1000;
  tmr_Save.Enabled := bo;
end;

procedure TdmWinSysServer.tmr_SaveTimer(Sender: TObject);
begin
//��ʱ��������
  Showmessage('��ʱ����');
  //SaveToDB;
end;

procedure TdmWinSysServer.SetDMServerICONState(value: TDMServerICONState);
begin
  {����ϵͳ����ͼ��״̬ ���������棬����}
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
  Showmessage('���ݼ�ⴰ��');
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
      DMServerAddLog('���ݿ�����ʧ�ܣ����ܶ�ȡ���� '+#13+Err);
      //���þ���
      SetDMServerICONState(dsiWarning);
      Exit;
    end
    else
      DMServerAddLog('��ȡ���ݿ����ӳɹ� ');
  end;

  qry_Open.SQL.Clear;
  qry_Open.SQL.Text:=sqlstr;
  try
    qry_Open.Open;
    Result:=qry_Open;
  except on E:Exception do
    begin
      DMServerAddLog('��ȡ���ݴ���'+#13+E.Message);
      qry_Open.Close;
    end;
  end;}
end;

procedure TdmWinSysServer.DataModuleDestroy(Sender: TObject);
var
  i: Integer;
begin
 //�ͷ�
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
  if tmrKingConn.Tag = 0 then  //��ֹͣ����
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
      DMServerAddLog('׼����������ʧ�ܣ����������...');
    end
    else
    begin
      tmrKingConn.Tag := tmrKingConn.Tag + 1;
      tmrKingConn.Enabled := True;
      DMServerAddLog('׼���������ӳɹ���');
    end;
  end;
end;

end.

