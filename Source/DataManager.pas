unit DataManager;

interface

uses
  System.SysUtils, System.Win.ScktComp, Generics.Collections, Vcl.ExtCtrls,
  DateUtils, BPStatusModel;

type
  TDataManager = class(TObject)
  private
    class var
      FInstance: TDataManager;
    class function GetInstance: TDataManager; static;
  public
    class property Instance: TDataManager read GetInstance;
    class procedure ReleaseInstance;
    constructor Create;
    destructor Destroy; override;
  protected
    procedure timerOnTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
  private
    FTimer: TTimer;
    FSocket: TClientSocket;
    fQueue: TDictionary<string, TBPStatusModel>;
    procedure initSocket;
    procedure initTimer;
  public
    procedure start(mac: string);
    procedure stop(mac: string);
  private
    procedure bpOnLine(mac: string);
    procedure bpSend(mac: string);
  end;

implementation
uses TLog;
{ TDataManager }

procedure TDataManager.bpOnLine(mac: string);
var
  reqBuff: array of Byte;
begin
  if not Assigned(FSocket) then
  begin
    initSocket;
  end;
  if FSocket.Active = False then
  begin
    FSocket.Active := True;
  end;
  //先检测血压计是否在线
  SetLength(reqBuff, 14);
  reqBuff[0] := $FC;
  reqBuff[1] := $0C;
  reqBuff[2] := $02;
  reqBuff[3] := $01;
  reqBuff[4] := $4F;
  reqBuff[5] := $08;
  reqBuff[6] := $34;
  reqBuff[7] := $2C;
  reqBuff[8] := $22;
  reqBuff[9] := $00;
  reqBuff[10] := $4B;
  reqBuff[11] := $12;
  reqBuff[12] := $00;
  reqBuff[13] := $03;
  FSocket.Socket.SendBuf(reqBuff, SizeOf(reqBuff));
end;

procedure TDataManager.bpSend(mac: string);
var
  reqBuff: array of Byte;
begin
  if not Assigned(FSocket) then
  begin
    initSocket;
  end;
  if FSocket.Active = False then
  begin
    FSocket.Active := True;
  end;
  //发送数据
  {
  SetLength(reqBuff, 14);
  reqBuff[0] := $FC;
  reqBuff[1] := $0C;
  reqBuff[2] := $02;
  reqBuff[3] := $01;
  reqBuff[4] := $4D;
  reqBuff[5] := $08;
  reqBuff[6] := $34;
  reqBuff[7] := $2C;
  reqBuff[8] := $22;
  reqBuff[9] := $00;
  reqBuff[10] := $4B;
  reqBuff[11] := $12;
  reqBuff[12] := $00;
  reqBuff[13] := $03;
  FSocket.Socket.SendBuf(reqBuff, SizeOf(reqBuff));
  }
  FSocket.Socket.SendText(mac);
end;

procedure TDataManager.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin

end;

procedure TDataManager.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDataManager.Create;
begin
  fQueue := TDictionary<string, TBPStatusModel>.Create();
  initSocket;
  initTimer;
  FSocket.Active := True;
  FTimer.Enabled := True;
end;

destructor TDataManager.Destroy;
begin
  if Assigned(FSocket) then
  begin
    FSocket.Close;
    FSocket.Free;
  end;
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
  end;
  inherited;
end;

class function TDataManager.GetInstance: TDataManager;
begin
  if FInstance = nil then
    FInstance := TDataManager.Create;
  Result := FInstance;
end;

procedure TDataManager.initSocket;
begin
  FSocket := TClientSocket.Create(nil);
  FSocket.Address := '172.16.26.129';
  FSocket.Port := 9797;
  FSocket.Active := False;
  FSocket.OnConnect := ClientSocketConnect;
  FSocket.OnConnecting := ClientSocketConnecting;
  FSocket.OnDisconnect := ClientSocketDisconnect;
  FSocket.OnError := ClientSocketError;
  FSocket.OnRead := ClientSocketRead;
  FSocket.OnWrite := ClientSocketWrite;
end;

procedure TDataManager.initTimer;
begin
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 5 * 1000;//5秒检测一次
  FTimer.OnTimer := timerOnTimer;
  FTimer.Enabled := False;
end;

class procedure TDataManager.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

procedure TDataManager.start(mac: string);
var
  bpStatusModel: TBPStatusModel;
begin
  bpStatusModel := TBPStatusModel.Create;
  bpStatusModel.MMac := mac;
  bpStatusModel.lastTime := Now();
  fQueue.Add(mac, bpStatusModel);
end;

procedure TDataManager.stop(mac: string);
begin
  fQueue.Remove(mac);
end;

procedure TDataManager.timerOnTimer(Sender: TObject);
var
  I: Integer;
  bpStatusModel: TBPStatusModel;
  mac: string;
  timeDiff: Double;
begin
  for mac in fQueue.Keys do
  begin
    bpStatusModel := fQueue.Items[mac];
    timeDiff := SecondsBetween(Now(), bpStatusModel.lastTime);
    TDLog.Instance.writeLog(timeDiff.ToString);
    if timeDiff < 60 * 10 then // 10分钟之内不处理
    begin

    end
    else
    begin
      //发送数据
      bpSend(mac);
    end;
  end;
end;

end.

