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
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
  private
    fSocketQueue: TDictionary<string, TClientSocket>;  {ipAddress:TClientSocket}
    fTimeInterval:string;
    procedure initSocket(ip: string);
//    function getBPStatus(mac: string): string;
    function getIPSbyMac(macModel: TDetailBPModel): string;
    function getTimeInterval:string;//获取时间间隔
    procedure praseRspData(rsp: string);
  public
    bpQueue: TDictionary<string, TDetailBPModel>;
    procedure start(macModel: TDetailBPModel);
    procedure stop(macModel: TDetailBPModel);
    procedure stopAll;
    procedure startAll;
  private
    procedure bpOnLine(macModel: TDetailBPModel); //是否在线
    procedure bpSend(macModel: TDetailBPModel); //发送开始测量命令
    procedure bpSetTimeInterval(macModel: TDetailBPModel); //设置间隔时间
  end;

implementation

uses
  TLog, HDBManager, superobject, Tool;
{ TDataManager }

procedure TDataManager.bpOnLine(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  iLen: integer;
  tmpSocket: TClientSocket;
  reqMemory: TMemoryStream;
  isExist:Boolean;
begin
  isExist := fSocketQueue.TryGetValue(macModel.MGroup,tmpSocket);
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0C 02 01 4F ' + macModel.MMac + ' 03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    reqMemory := TMemoryStream.Create;
    reqMemory.Size := Length(strData) div 2;
    iLen := HexToBin(PChar(strData), reqMemory.Memory, reqMemory.Size);
    tmpSocket.Socket.SendStream(reqMemory);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac + ',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.bpSend(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  iLen: integer;
  tmpSocket: TClientSocket;
  reqMemory: TMemoryStream;
begin
  fSocketQueue.TryGetValue(macModel.MGroup,tmpSocket);
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0C 02 01 4D' + macModel.MMac + '03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    reqMemory := TMemoryStream.Create;
    reqMemory.Size := Length(strData) div 2;
    iLen := HexToBin(PChar(strData), reqMemory.Memory, reqMemory.Size);
    tmpSocket.Socket.SendStream(reqMemory);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac + ',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.bpSetTimeInterval(macModel: TDetailBPModel);
var
  sourceData, strData: string;
  iLen: integer;
  tmpSocket: TClientSocket;
  reqMemory: TMemoryStream;
begin
  fSocketQueue.TryGetValue(macModel.MGroup,tmpSocket);
  if Assigned(tmpSocket) and tmpSocket.Active then
  begin
    sourceData := 'FC 0F 02 01 53 ' + macModel.MMac + ' '+ AscIIToHex(StrToInt(macModel.MInterval)) + ' 03';
    strData := StringReplace(sourceData, ' ', '', [rfReplaceAll]);
    reqMemory := TMemoryStream.Create;
    reqMemory.Size := Length(strData) div 2;
    iLen := HexToBin(PChar(strData), reqMemory.Memory, reqMemory.Size);
    tmpSocket.Socket.SendStream(reqMemory);
    TDLog.Instance.writeLog('Req:mac=' + macModel.MMac + ',sendBuff =' + sourceData);
  end
  else
  begin
    initSocket(macModel.MGroup);
  end;
end;

procedure TDataManager.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  macModel: TDetailBPModel;
  mMac: string;
begin
  TDLog.Instance.writeLog('Connect:remoteHost=' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString);
  for mMac in bpQueue.Keys do
  begin
    macModel := bpQueue[mMac];
    if macModel.cStatus = UnConnect then
    begin
      macModel.cStatus := Connected;
      bpQueue.AddOrSetValue(macModel.MMac, macModel);
      bpOnLine(macModel);
    end;
  end;
end;

procedure TDataManager.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  TDLog.Instance.writeLog('Connecting:remoteHost=' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  mGroup: string;
  macModel: TDetailBPModel;
  mMac: string;
begin
  mGroup := Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort);
  for mMac in bpQueue.Keys do
  begin
    macModel := bpQueue.Items[mMac];
    if LowerCase(macModel.MGroup) = LowerCase(mGroup) then
    begin
      bpQueue.Remove(macModel.MMac);
    end;
  end;
  TDLog.Instance.writeLog('Disconnect:remoteHost=' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  mGroup: string;
  macModel: TDetailBPModel;
  mMac: string;
begin
  mGroup := Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort);
  for mMac in bpQueue.Keys do
  begin
    macModel := bpQueue.Items[mMac];
    if LowerCase(macModel.MGroup) = LowerCase(mGroup) then
    begin
      bpQueue.Remove(macModel.MMac);
    end;
  end;
  TDLog.Instance.writeLog('Error:ErrorCode =' + ErrorCode.ToString + ',remoteHost=' + Socket.RemoteAddress + ':' + Socket.RemotePort.ToString);
end;

procedure TDataManager.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  rspBuff: array of Byte;
  iLength: Integer;
  rspStr: string;
  I: Integer;
  rspStrTmp, macTmp: string;
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
  praseRspData(rspStrTmp);
end;

procedure TDataManager.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDataManager.Create;
begin
  bpQueue := TDictionary<string, TDetailBPModel>.Create();
  fSocketQueue := TDictionary<string, TClientSocket>.Create();
  fTimeInterval := getTimeInterval;
  if Length(fTimeInterval) = 0 then
  begin
    fTimeInterval := '15';
  end;
end;

destructor TDataManager.Destroy;
var
  tmpSocket: TClientSocket;
begin
  if Assigned(fSocketQueue) then
  begin
    for tmpSocket in fSocketQueue.Values do
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
    fSocketQueue.Clear;
    fSocketQueue.Free;
  end;
  inherited;
end;

//function TDataManager.getBPStatus(mac: string): string;
//var
//  jsonData: ISuperObject;
//  subData: ISuperObject;
//  status: string;
//  sql: string;
//begin
//  sql := Format('Select * From T_M_Infos_Status where 1=1 and mac = %@ ', [QuotedStr(mac)]);
//  jsonData := TDBManager.Instance.getDataBySql(sql);
//  if jsonData.I['rowCount'] > 0 then
//  begin
//    for subData in jsonData['data'] do
//    begin
//      status := subData.S['MStatus'];
//    end;
//  end;
//  Result := status;
//end;

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

function TDataManager.getTimeInterval: string;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
begin
  jsonData := TDBManager.Instance.getDataBySql('Select * From T_M_Set where MKey = "1000"');
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      Result := subData['MValue'].AsString;
    end;
  end;
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
      fSocketQueue.AddOrSetValue(ip, tmpSocket);
    except
      on E: Exception do
      begin
        fSocketQueue.Remove(ip);
        TDLog.Instance.writeLog('打开' + ip + '服务失败');
      end;
    end;
  end;

end;

procedure TDataManager.praseRspData(rsp: string);
var
  mac: string;
  rspStrTmp, macTmp: string;
  iPos: Integer;
  preStr: string; //返回数据的前一个字符来判断是什么命令 4F=是否在线 4D=开始测量  44=测量的数据 53=自动测量的时间间隔
  rspMessage: string;
  sql: string;
  sqlList: TStringList;
  rspSBP, rspDBP, rspHR: string;
  macModel: TDetailBPModel;
  leftStr: string; //解析完一次剩下的数据
begin
  rspStrTmp := rsp;
  sqlList := TStringList.Create;
  for mac in bpQueue.Keys do
  begin
    macModel := bpQueue[mac];
    macTmp := StringReplace(LowerCase(mac), ' ', '', [rfReplaceAll]);
    iPos := Pos(macTmp, rspStrTmp);
    if (iPos - 2) > 0 then
    begin
      preStr := Copy(rspStrTmp, iPos - 2, 2);
      if LowerCase(preStr) = '4f' then
      begin
        rspMessage := '在线命令返回';
//        sql := Format('Delete from T_M_infos_Status where 1=1 and MMac = %s', [QuotedStr(mac)]);
//        sqlList.Add(sql);
//        sql := Format('insert into T_M_infos_Status (MMac,MStatus) values (%s,1)', [QuotedStr(mac)]);
//        sqlList.Add(sql);
        macModel.cStatus := OnLine;
        bpQueue.AddOrSetValue(macModel.MMac, macModel);
        bpSetTimeInterval(macModel);
        leftStr := Copy(rspStrTmp, iPos + Length(macTmp) + 2, Length(rspStrTmp) - (iPos + Length(macTmp) + 1));
      end
      else if LowerCase(preStr) = '4D' then
      begin
        rspMessage := '开始测量命令返回';
        bpSend(macModel);
        leftStr := Copy(rspStrTmp, iPos + Length(macTmp) + 2, Length(rspStrTmp) - (iPos + Length(macTmp) + 1));
      end
      else if LowerCase(preStr) = '44' then
      begin
        leftStr := Copy(rspStrTmp, iPos + Length(macTmp) + 6 *3 + 2, Length(rspStrTmp) - (iPos + Length(macTmp) + 6 *3  + 1));
        iPos := iPos + Length(macTmp);
        rspMessage := '测量数据返回';
        rspSBP := IntToStr((HexToAscII(Copy(rspStrTmp, iPos, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 2, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 4, 2))));
        rspDBP := IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 6, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 8, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 10, 2))));
        rspHR := IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 12, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 14, 2)))) + IntToStr((HexToAscII(Copy(rspStrTmp, iPos + 16, 2))));
        sql := Format('insert into T_M_Datas (MMac,MSBP,MDBP,MHR) values (%s,%s,%s,%s)', [QuotedStr(mac), QuotedStr(IntToStr(StrToInt(rspSBP))), QuotedStr(IntToStr(StrToInt(rspDBP))), QuotedStr(IntToStr(StrToInt(rspHR)))]);
        sqlList.Add(sql);
      end
      else if LowerCase(preStr) = '53' then
      begin
        leftStr := Copy(rspStrTmp, iPos + Length(macTmp) + 2 *3 +2, Length(rspStrTmp) - (iPos + Length(macTmp) + 2 *3 +1));
        rspMessage := '设置间隔命令返回';
      end
      else
      begin
        rspMessage := '未知消息';
        macModel.cStatus := Connected;
        bpQueue.AddOrSetValue(macModel.MMac, macModel);
        leftStr := '';
      end;
      TDLog.Instance.writeLog('Rsp:mac=' + mac + ',rspMessage = ' + rspMessage + ',rspBuff =' + rspStrTmp);
    end;
  end;
  if sqlList.Count > 0 then
  begin
    TDBManager.Instance.execSql(sqlList);
  end;
  if Length(leftStr) > 0 then
  begin
    TDLog.Instance.writeLog('Rsp:mac=' + mac + '粘包,leftBuff =' + leftStr);
    praseRspData(leftStr);
  end;
end;

class procedure TDataManager.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

procedure TDataManager.start(macModel: TDetailBPModel);
var
  tmpSocket: TClientSocket;
begin
  if fSocketQueue.ContainsKey(macModel.MGroup) then
  begin
    tmpSocket := fSocketQueue.Items[macModel.MGroup];
    if Assigned(tmpSocket) then
    begin
      if tmpSocket.Active then
      begin
        macModel.cStatus := Connected;
        bpQueue.AddOrSetValue(macModel.MMac, macModel);
        bpOnLine(macModel);
      end
      else
      begin
        try
          macModel.cStatus := UnConnect;
          bpQueue.AddOrSetValue(macModel.MMac, macModel);
          fSocketQueue.AddOrSetValue(macModel.MGroup, tmpSocket);
          tmpSocket.Open;
        except
          on E: Exception do
          begin
            bpQueue.Remove(macModel.MMac);
            fSocketQueue.Remove(macModel.MGroup);
            TDLog.Instance.writeLog('打开' + macModel.MGroup + '服务失败');
          end;
        end;
      end;
    end;
  end
  else
  begin
    initSocket(macModel.MGroup);
    macModel.cStatus := UnConnect;
    bpQueue.AddOrSetValue(macModel.MMac, macModel);
  end;
end;

procedure TDataManager.startAll;
var
  macModel: TDetailBPModel;
  mac: string;
begin
  for mac in bpQueue.Keys do
  begin
    macModel := bpQueue.Items[mac];
    start(macModel);
  end;
end;

procedure TDataManager.stop(macModel: TDetailBPModel);
var
  sql: string;
  sqlList: TStringList;
begin
  bpQueue.Remove(macModel.MMac);
  if bpQueue.Keys.Count = 0 then
  begin
    bpQueue.Clear;
  end;
  macModel.MInterval := '0';
  bpSetTimeInterval(macModel);
//  sqlList := TStringList.Create;
//  sql := Format('Delete from T_M_infos_Status where 1=1 and MMac = %s', [QuotedStr(macModel.MMac)]);
//  sqlList.Add(sql);
//  if sqlList.Count > 0 then
//  begin
//    TDBManager.Instance.execSql(sqlList);
//  end;
end;

procedure TDataManager.stopAll;
var
  macModel: TDetailBPModel;
  mac: string;
begin
  for mac in bpQueue.Keys do
  begin
    macModel := bpQueue.Items[mac];
    stop(macModel);
  end;
end;

end.

