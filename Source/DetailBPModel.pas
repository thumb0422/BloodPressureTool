unit DetailBPModel;

interface

uses
  BPModel;

type
  TDetailBPModel = class(TBPModel)
  private
    FlastTime: TDateTime;
    FonLineStatus: Boolean;
    procedure SetlastTime(const Value: TDateTime);
    procedure SetonLineStatus(const Value: Boolean);
  public
    property lastTime: TDateTime read FlastTime write SetlastTime;
    property onLineStatus:Boolean read FonLineStatus write SetonLineStatus;
  end;

implementation

{ TDetailBPModel }

procedure TDetailBPModel.SetlastTime(const Value: TDateTime);
begin
  FlastTime := Value;
end;

procedure TDetailBPModel.SetonLineStatus(const Value: Boolean);
begin
  FonLineStatus := Value;
end;

end.

