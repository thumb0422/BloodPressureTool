unit DetailInfoView;

interface

uses
  System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, System.SysUtils, Vcl.Forms,
  Vcl.Menus, Winapi.Windows, System.Win.ScktComp, DetailBPModel;

type
  TBPInfoStatus = (BPInfoStatusInit, BPInfoStatusConnecting, BPInfoStatusConnected, BPInfoStatusError);

type
  TDetailInfoView = class(TPanel)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    descLabel: TLabel; //血压计名称
    statusLabel: TLabel; //血压计状态
    FTimer: TTimer;
    FPopMenu: TPopupMenu;
    FSocket: TClientSocket;
    Fdata: TDetailBPModel;
    FBPStatus: TBPInfoStatus;
    procedure Setdata(const Value: TDetailBPModel); //当前状态
    procedure qryStatus;
    procedure initClientSocket;
    procedure praseRspData;
  public
    property data: TDetailBPModel read Fdata write Setdata;
  protected
    procedure timerOnTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure onPopStartClick(Sender: TObject);
    procedure onPopStopClick(Sender: TObject);
    procedure onPopQryClick(Sender: TObject);
  end;

implementation

uses
  HDBManager, superobject, TLog,DetailDataForm;
{ TDetailInfoView }

procedure TDetailInfoView.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDetailInfoView.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDetailInfoView.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDetailInfoView.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin

end;

procedure TDetailInfoView.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i, L: Integer;
  buff: array of Byte;
begin
  L := Socket.ReceiveLength;
  if L <= 0 then
    exit;
  SetLength(buff, L);
  i := Socket.ReceiveBuf(buff[0], L);
  if i < L then
  begin
    //处理粘包
  end
  else
  begin

  end;
end;

procedure TDetailInfoView.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDetailInfoView.Create(AOwner: TComponent);
begin
  inherited;

  FPopMenu := TPopupMenu.Create(Self);
  with FPopMenu.Items do
  begin
    Add(NewItem('启动', 0, False, True, onPopStartClick, 0, 'MenuItem1'));
    Add(NewLine);
    Add(NewItem('关闭', 0, False, True, onPopStopClick, 0, 'MenuItem2'));
    Add(NewLine);
    Add(NewItem('查看', 0, False, True, onPopQryClick, 0, 'MenuItem3'));
  end;

  Self.PopupMenu := FPopMenu;
  descLabel := TLabel.Create(Self);
  descLabel.Caption := '血压计-';
  descLabel.Alignment := taLeftJustify;
  descLabel.Left := 5;
  descLabel.Top := 5;
  descLabel.Width := 120;
  descLabel.Height := 20;
  descLabel.Transparent := True;
  descLabel.Parent := Self;

  statusLabel := TLabel.Create(Self);
  statusLabel.Caption := '未启动';
  statusLabel.Alignment := taCenter;
  statusLabel.Left := 5;
  statusLabel.Top := 30;
  statusLabel.Width := 120;
  statusLabel.Height := 20;
  statusLabel.Transparent := True;
  statusLabel.Parent := Self;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 1000 * 10;
  FTimer.OnTimer := timerOnTimer;
  FTimer.Enabled := False;

  initClientSocket;
end;

destructor TDetailInfoView.Destroy;
begin
  if Assigned(FTimer) then
    FTimer.Free;
  if Assigned(statusLabel) then
    statusLabel.Free;
  if Assigned(descLabel) then
    descLabel.Free;
  if Assigned(FSocket) then
  begin
    FSocket.Close;
    FSocket.Free;
  end;
  inherited;
end;

procedure TDetailInfoView.initClientSocket;
begin
  FSocket := TClientSocket.Create(Self);
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

procedure TDetailInfoView.onPopQryClick(Sender: TObject);
var
  sForm: TTDetailDataForm;
begin
  sForm := TTDetailDataForm.Create(Application);
  sForm.bpModel := data;
  sForm.ShowModal;
  sForm.Free;
end;

procedure TDetailInfoView.onPopStartClick(Sender: TObject);
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := True;
  end;
end;

procedure TDetailInfoView.onPopStopClick(Sender: TObject);
begin
  if Assigned(FTimer) then
  begin
    FTimer.Enabled := False;
    if Assigned(FSocket) then
    begin
      FSocket.Close;
    end;
  end;
end;

procedure TDetailInfoView.praseRspData;
begin

end;

procedure TDetailInfoView.qryStatus;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  sql: string;
  status: string;
begin
  sql := Format('Select MStatus from T_M_Infos_Status where 1=1 and MMac = %s', [QuotedStr(Fdata.MMac)]);
  jsonData := TDBManager.Instance.getDataBySql(sql);
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      status := subData.S['MStatus'];
    end;
  end;
  if status = '0' then
  begin
    statusLabel.Caption := '未启动';
  end
  else if status = '1' then
  begin
    statusLabel.Caption := '已启动';
  end
  else
  begin
    statusLabel.Caption := '启动中';
  end;
end;

procedure TDetailInfoView.Setdata(const Value: TDetailBPModel);
begin
  Fdata := Value;
  descLabel.Caption := '血压计-' + Fdata.MDesc;
  qryStatus;
end;

procedure TDetailInfoView.timerOnTimer(Sender: TObject);
var
  reqBuff: array of Byte;
begin
  if not Assigned(FSocket) then
  begin
    initClientSocket;
  end;
  if FSocket.Active = False then
  begin
    FSocket.Active := True;
  end;
//  FSocket.Socket.SendText('123456789');
  //先检测血压计是否在线
  SetLength(reqBuff,14);
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
  FSocket.Socket.SendBuf(reqBuff,SizeOf(reqBuff));
end;

end.

