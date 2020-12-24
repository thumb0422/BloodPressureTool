unit DataManager;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, System.Win.ScktComp, Generics.Collections,
  Vcl.ExtCtrls, DateUtils, BPStatusModel;

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
    procedure bpOnLine(mac: string); //是否在线
    procedure bpSend(mac: string); //发送开始测量命令
    procedure bpSetTimer(mac: string); //设置间隔时间
  end;

implementation

uses
  TLog, Tool;
{ TDataManager }

procedure TDataManager.bpOnLine(mac: string);
var
  sourceData, strData: string;
  reqBuff: array[0..13] of byte;
  iLen: integer;
begin
  sourceData := 'FC 0C 02 01 4F 08 34 2C 22 00 4B 12 00 03';
  strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
  ZeroMemory(@reqBuff[0], 14);
  iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
  FSocket.Socket.SendBuf(reqBuff, iLen);
end;

procedure TDataManager.bpSend(mac: string);
var
  sourceData, strData: string;
  reqBuff: array[0..13] of byte;
  iLen: integer;
begin
  sourceData := 'FC 0C 02 01 4D 08 34 2C 22 00 4B 12 00 03';
  strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
  ZeroMemory(@reqBuff[0], 14);
  iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
  FSocket.Socket.SendBuf(reqBuff, iLen);
end;

procedure TDataManager.bpSetTimer(mac: string);
var
  sourceData, strData: string;
  reqBuff: array[0..16] of byte;
  iLen: integer;
begin
  sourceData := 'FC 0F 02 01 53 08 34 2C 22 00 4B 12 00 30 39 30 03';
  strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
  ZeroMemory(@reqBuff[0], 17);
  iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
  FSocket.Socket.SendBuf(reqBuff, iLen);
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
var
  rspBuff: array of Byte;
  iLength: Integer;
begin
  iLength := Socket.ReceiveLength;
  if (iLength > 0) then
  begin
    SetLength(rspBuff, iLength);
    Socket.ReceiveBuf(rspBuff[0], iLength);
  end;

end;

procedure TDataManager.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDataManager.Create;
begin
  fQueue := TDictionary<string, TBPStatusModel>.Create();
  initSocket;
  initTimer;
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
  try
    FSocket.Open;
  except
    on E: Exception do
    begin
      TDLog.Instance.writeLog('打开服务失败');
    end;
  end;
end;

procedure TDataManager.initTimer;
begin
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 5 * 1000; //5秒检测一次
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
  bpSend(mac);
  bpStatusModel := TBPStatusModel.Create;
  bpStatusModel.MMac := mac;
  bpStatusModel.lastTime := Now();
  fQueue.AddOrSetValue(mac, bpStatusModel);
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
  isOpen: Boolean;
begin
  for mac in fQueue.Keys do
  begin
    bpStatusModel := fQueue.Items[mac];
    timeDiff := SecondsBetween(Now(), bpStatusModel.lastTime);
    TDLog.Instance.writeLog(timeDiff.ToString);
    if timeDiff < 10 then // 10分钟之内不处理
    begin

    end
    else
    begin
      isOpen := FSocket.Active;
      //发送数据
//      bpSend(mac);
      bpOnLine(mac);
      //reset status
      bpStatusModel.lastTime := Now();
      fQueue.AddOrSetValue(mac, bpStatusModel);
    end;
  end;
end;

end.

