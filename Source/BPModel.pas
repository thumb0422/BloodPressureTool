unit BPModel;

interface
uses System;

type
  TBPModel = class
  private
    FMDesc: string;
    FMGroup: string;
    FMNo: string;
    FMMac: string;
    procedure SetMDesc(const Value: string);
    procedure SetMGroup(const Value: string);
    procedure SetMMac(const Value: string);
    procedure SetMNo(const Value: string);

  public
    property MNo: string read FMNo write SetMNo;
    property MMac: string read FMMac write SetMMac;
    property MGroup: string read FMGroup write SetMGroup;
    property MDesc: string read FMDesc write SetMDesc;

  public
    procedure saveData;
  end;

implementation

{ TBPModel }

procedure TBPModel.saveData;
begin
//remove data  from DB
//save data to DB
end;

procedure TBPModel.SetMDesc(const Value: string);
begin
  FMDesc := Value;
end;

procedure TBPModel.SetMGroup(const Value: string);
begin
  FMGroup := Value;
end;

procedure TBPModel.SetMMac(const Value: string);
begin
  FMMac := Value;
end;

procedure TBPModel.SetMNo(const Value: string);
begin
  FMNo := Value;
end;

end.

