unit DetailBPModel;

interface

uses
  BPModel;
type
  ConnectStatus = (UnConnect,OnLine,OnWorking);//δ���ӡ������ӡ�������
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

