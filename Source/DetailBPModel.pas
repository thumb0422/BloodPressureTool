unit DetailBPModel;

interface

uses
  BPModel;
type
  ConnectStatus = (UnConnect,OnLine,OnWorking);//未连接(包含未联网、未返回在线命令)、已连接、测量中
type
  TDetailBPModel = class(TBPModel)
  private
    FcStatus: ConnectStatus;
    FcDone: Boolean;
    FcReqTime: TDateTime;
    procedure SetcStatus(const Value: ConnectStatus);
    procedure SetcDone(const Value: Boolean);
    procedure SetcReqTime(const Value: TDateTime);
  public
    property cStatus: ConnectStatus read FcStatus write SetcStatus;
    property cReqTime: TDateTime read FcReqTime write SetcReqTime;
    property cDone :Boolean read FcDone write SetcDone;  //当前命令是否已经返回
  end;

implementation

{ TDetailBPModel }

procedure TDetailBPModel.SetcDone(const Value: Boolean);
begin
  FcDone := Value;
end;

procedure TDetailBPModel.SetcReqTime(const Value: TDateTime);
begin
  FcReqTime := Value;
end;

procedure TDetailBPModel.SetcStatus(const Value: ConnectStatus);
begin
  FcStatus := Value;
end;
end.

