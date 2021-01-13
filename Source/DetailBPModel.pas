unit DetailBPModel;

interface

uses
  BPModel;
type
  ConnectStatus = (UnConnect,OnLine,OnWorking);//未连接、已连接、测量中
type
  TDetailBPModel = class(TBPModel)
  private
    FlastTime: TDateTime;
    FcStatus: ConnectStatus;
    procedure SetlastTime(const Value: TDateTime);
    procedure SetcStatus(const Value: ConnectStatus);
  public
    property lastTime: TDateTime read FlastTime write SetlastTime;
    property cStatus: ConnectStatus read FcStatus write SetcStatus;
  end;

implementation

{ TDetailBPModel }

procedure TDetailBPModel.SetcStatus(const Value: ConnectStatus);
begin
  FcStatus := Value;
end;

procedure TDetailBPModel.SetlastTime(const Value: TDateTime);
begin
  FlastTime := Value;
end;

end.

