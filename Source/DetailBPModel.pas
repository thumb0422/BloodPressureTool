unit DetailBPModel;

interface

uses
  BPModel;
type
  ConnectStatus = (UnConnect,OnLine,OnWorking);//δ����(����δ������δ������������)�������ӡ�������
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
    property cDone :Boolean read FcDone write SetcDone;  //��ǰ�����Ƿ��Ѿ�����
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

