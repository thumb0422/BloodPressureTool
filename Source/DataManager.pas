unit DataManager;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, System.Win.ScktComp, Generics.Collections,
  Vcl.ExtCtrls, DateUtils, DetailBPModel;

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
    FSocketQueue: TDictionary<string, TClientSocket>;  {ipAddress:TClientSocket}
    fQueue: TDictionary<string, TDetailBPModel>; {macAddress:TDetailBPModel}
    procedure initSocket(ip: string);
    procedure initTimer;
    function getBPStatus(mac: string): string;
    function getIPSbyMac(macModel: TDetailBPModel): string;
  public
    procedure start(macModel: TDetailBPModel);
    procedure stop(macModel: TDetailBPModel);
    procedure stopAll;
  private
    procedure bpOnLine(macModel: TDetailBPModel); //是否在线
    procedure bpSend(macModel: TDetailBPModel); //发送开始测量命令
    procedure bpSetTimer(macModel: TDetailBPModel); //设置间隔时间
  end;

implementation

uses
  TLog, HDBManager, superobject;
{ TDataManager }

procedure TDataManager.bpOnLine(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  reqBuff: array[0..13] of byte;
  iLen: integer;
  tmpSocket: TClientSocket;
begin
  tmpSocket := FSocketQueue.Items[macModel.MGroup];
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0C 02 01 4F ' + macModel.MMac + ' 03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    ZeroMemory(@reqBuff[0], 14);
    iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
    tmpSocket.Socket.SendBuf(reqBuff, iLen);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac +',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.bpSend(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  reqBuff: array[0..13] of byte;
  iLen: integer;
  tmpSocket: TClientSocket;
begin
  tmpSocket := FSocketQueue.Items[macModel.MGroup];
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0C 02 01 4D' + macModel.MMac + '03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    ZeroMemory(@reqBuff[0], 14);
    iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
    tmpSocket.Socket.SendBuf(reqBuff, iLen);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac +',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.bpSetTimer(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  reqBuff: array[0..16] of byte;
  iLen: integer;
  tmpSocket: TClientSocket;
begin
  tmpSocket := FSocketQueue.Items[macModel.MGroup];
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0F 02 01 53' + macModel.MMac + '30 39 30 03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    ZeroMemory(@reqBuff[0], 17);
    iLen := HexToBin(pChar(strData), pchar(@reqBuff[0]), Length(sourceData));
    tmpSocket.Socket.SendBuf(reqBuff, iLen);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac +',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  TDLog.Instance.writeLog('Connect:remoteHost=' + Socket.RemoteAddress +':'+Socket.RemotePort.ToString);
  
end;

procedure TDataManager.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  TDLog.Instance.writeLog('Connecting:remoteHost=' + Socket.RemoteAddress +':'+Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  TDLog.Instance.writeLog('Disconnect:remoteHost=' + Socket.RemoteAddress +':'+Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  TDLog.Instance.writeLog('Error:ErrorCode ='+ ErrorCode.ToString + ',remoteHost=' + Socket.RemoteAddress +':'+Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  rspBuff: array of Byte;
  iLength: Integer;
  rspStr: string;
  I: Integer;
  mac: string;
  rspStrTmp, macTmp: string;
  iPos: Integer;
  preStr: string; //返回数据的前一个字符来判断是什么命令 4F=是否在线 4D=开始测量  44=测量的数据 53=自动测量的时间间隔
  rspMessage: string;
  sql: string;
  sqlList: TStringList;
  rspSBP, rspDBP, rspHR: string;
  macModel: TDetailBPModel;
begin
  iLength := Socket.ReceiveLength;
  if (iLength > 0) then
  begin
    SetLength(rspBuff, iLength);
    Socket.ReceiveBuf(rspBuff[0], iLength);
  end;
  rspStr := '';
  for I := Low(rspBuff) to High(rspBuff) do
  begin
    rspStr := rspStr + ' ' + IntToHex(rspBuff[I]);
  end;
  rspStrTmp := StringReplace(LowerCase(rspStr), ' ', '', [rfReplaceAll]);
  for mac in fQueue.Keys do
  begin
    macModel := fQueue[mac];
    macTmp := StringReplace(LowerCase(mac), ' ', '', [rfReplaceAll]);
    iPos := Pos(macTmp, rspStrTmp);
    if (iPos - 2) > 0 then
    begin
      preStr := Copy(rspStrTmp, iPos - 2, 2);
      sqlList := TStringList.Create;
      if LowerCase(preStr) = '4f' then
      begin
        rspMessage := '在线命令返回';
        sql := Format('Delete from T_M_infos_Status where 1=1 and MMac = %s', [QuotedStr(mac)]);
        sqlList.Add(sql);
        sql := Format('insert into T_M_infos_Status (MMac,MStatus) values (%s,1)', [QuotedStr(mac)]);
        sqlList.Add(sql);
        macModel.onLineStatus := True;
        fQueue.AddOrSetValue(macModel.MMac, macModel);
      end
      else if LowerCase(preStr) = '4D' then
      begin
        rspMessage := '开始测量命令返回';
        bpSend(macModel);
      end
      else if LowerCase(preStr) = '44' then
      begin
        iPos := iPos + Length(macTmp);
        rspMessage := '测量数据返回';
        rspSBP := IntToStr((StrToInt(Copy(rspStrTmp,iPos,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+2,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+4,2)) - 30));
        rspDBP := IntToStr((StrToInt(Copy(rspStrTmp,iPos+6,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+8,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+10,2)) - 30));
        rspHR := IntToStr((StrToInt(Copy(rspStrTmp,iPos+12,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+14,2)) - 30))+IntToStr((StrToInt(Copy(rspStrTmp,iPos+16,2)) - 30));
        sql := Format('insert into T_M_Datas (MMac,MSBP,MDBP,MHR) values (%s,%s,%s,%s)', [QuotedStr(mac), QuotedStr(IntToStr(StrToInt(rspSBP))), QuotedStr(IntToStr(StrToInt(rspDBP))), QuotedStr(IntToStr(StrToInt(rspHR)))]);
        sqlList.Add(sql);
      end
      else if LowerCase(preStr) = '53' then
      begin
        rspMessage := '设置间隔命令返回';
      end
      else
      begin
        rspMessage := '未知消息';
        macModel.onLineStatus := False;
        fQueue.AddOrSetValue(macModel.MMac, macModel);
      end;
      TDLog.Instance.writeLog('Rsp:mac=' + mac +',rspMessage = '+rspMessage+ ',rspBuff =' + rspStr);
    end;
  end;
  if sqlList.Count > 0 then
  begin
    TDBManager.Instance.execSql(sqlList);
  end;  
end;

procedure TDataManager.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDataManager.Create;
begin
  fQueue := TDictionary<string, TDetailBPModel>.Create();
  FSocketQueue := TDictionary<string, TClientSocket>.Create();
  initTimer;
  FTimer.Enabled := True;
end;

destructor TDataManager.Destroy;
var
  tmpSocket: TClientSocket;
begin
  if Assigned(FSocketQueue) then
  begin
    for tmpSocket in FSocketQueue.Values do
    begin
      if Assigned(tmpSocket) then
      begin
        if tmpSocket.Active then
        begin
          tmpSocket.Close;
          tmpSocket.Free;
        end;
      end;
    end;
    FSocketQueue.Clear;
    FSocketQueue.Free;
  end;
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
  end;
  inherited;
end;

function TDataManager.getBPStatus(mac: string): string;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  status: string;
  sql: string;
begin
  sql := Format('Select * From T_M_Infos_Status where 1=1 and mac = %@ ', [QuotedStr(mac)]);
  jsonData := TDBManager.Instance.getDataBySql(sql);
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      status := subData.S['MStatus'];
    end;
  end;
  Result := status;
end;

class function TDataManager.GetInstance: TDataManager;
begin
  if FInstance = nil then
    FInstance := TDataManager.Create;
  Result := FInstance;
end;

function TDataManager.getIPSbyMac(macModel: TDetailBPModel): string;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  group: string;
  sql: string;
begin
  sql := Format('Select * From T_M_Infos where 1=1 and mac = %@ ', [QuotedStr(macModel.MMac)]);
  jsonData := TDBManager.Instance.getDataBySql(sql);
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      group := subData.S['MGroup'];
    end;
  end;
  Result := group;
end;

procedure TDataManager.initSocket(ip: string);
var
  tmpSocket: TClientSocket;
  ips: TArray<string>;
begin
  ips := ip.Split([':']);
  if Length(ips) > 1 then
  begin
    tmpSocket := TClientSocket.Create(nil);
    tmpSocket.Address := ips[0];
    tmpSocket.Port := ips[1].ToInteger;
    tmpSocket.Active := False;
    tmpSocket.OnConnect := ClientSocketConnect;
    tmpSocket.OnConnecting := ClientSocketConnecting;
    tmpSocket.OnDisconnect := ClientSocketDisconnect;
    tmpSocket.OnError := ClientSocketError;
    tmpSocket.OnRead := ClientSocketRead;
    tmpSocket.OnWrite := ClientSocketWrite;
    try
      tmpSocket.Open;
      FSocketQueue.AddOrSetValue(ip, tmpSocket);
    except
      on E: Exception do
      begin
        FSocketQueue.Remove(ip);
        TDLog.Instance.writeLog('打开服务失败');
      end;
    end;
  end;

end;

procedure TDataManager.initTimer;
begin
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 2 * 1000; //5秒检测一次
  FTimer.OnTimer := timerOnTimer;
  FTimer.Enabled := False;
end;

class procedure TDataManager.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

procedure TDataManager.start(macModel: TDetailBPModel);
begin
  if FSocketQueue.ContainsKey(macModel.MGroup) then
  begin

  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
  macModel.lastTime := Now();
  macModel.onLineStatus := False;
  fQueue.AddOrSetValue(macModel.MMac, macModel);
  if not Assigned(FTimer) then
  begin
    initTimer;
  end;
  if FTimer.Enabled = False then
  begin
    FTimer.Enabled := True;
  end;
//  bpOnLine(macModel);
end;

procedure TDataManager.stop(macModel: TDetailBPModel);
var
  sql: string;
  sqlList: TStringList;
begin
   fQueue.Remove(macModel.MMac);
  if fQueue.Keys.Count = 1 then
  begin
    fQueue.Clear;
    if Assigned(FTimer) then
    begin
      FTimer.Enabled := False;
    end;
  end;
  sqlList := TStringList.Create;
  sql := Format('Delete from T_M_infos_Status where 1=1 and MMac = %s', [QuotedStr(macModel.MMac)]);
  sqlList.Add(sql);
//  sql := Format('insert into T_M_infos_Status (MMac,MStatus) values (%s,1)', [QuotedStr(macModel.MMac)]);
//  sqlList.Add(sql);
  if sqlList.Count > 0 then
  begin
    TDBManager.Instance.execSql(sqlList);
  end;
end;

procedure TDataManager.stopAll;
var
  macModel: TDetailBPModel;
  mac: string;
begin
  for mac in fQueue.Keys do
  begin
    macModel := fQueue.Items[mac];
    stop(macModel);
    end;
  end;

procedure TDataManager.timerOnTimer(Sender: TObject);
var
  I: Integer;
  macModel: TDetailBPModel;
  mac: string;
  timeDiff: Double;
  isOpen: Boolean;
begin
  for mac in fQueue.Keys do
  begin
    macModel := fQueue.Items[mac];
    timeDiff := SecondsBetween(Now(), macModel.lastTime);
    if timeDiff < 20 then // todo 15分钟之内不处理
    begin

    end
    else
    begin
      if macModel.onLineStatus = False then
      begin
        bpOnLine(macModel);
      end
      else
      begin
        //发送数据
        bpSend(macModel);
        //reset status
        macModel.lastTime := Now();
        fQueue.AddOrSetValue(mac, macModel);
      end;
    end;
  end;
end;

end.

