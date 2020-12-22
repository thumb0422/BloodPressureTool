unit BPStatusModel;

interface

type
  TBPStatusModel = class
  private
    FlastTime: TDateTime;
    FMMac: string;
    procedure SetlastTime(const Value: TDateTime);
    procedure SetMMac(const Value: string);
  public
    property MMac: string read FMMac write SetMMac;
    property lastTime: TDateTime read FlastTime write SetlastTime;
  end;

implementation

{ TBPStatusModel }

procedure TBPStatusModel.SetlastTime(const Value: TDateTime);
begin
  FlastTime := Value;
end;

procedure TBPStatusModel.SetMMac(const Value: string);
begin
  FMMac := Value;
end;

end.

