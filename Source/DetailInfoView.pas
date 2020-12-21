unit DetailInfoView;

interface

uses
  System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, System.SysUtils,System.Win.ScktComp,
  DetailBPModel;

type
  TDetailInfoView = class(TPanel)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    descLabel: TLabel; //血压计名称
    statusLabel: TLabel; //血压计状态
    FTimer: TTimer;
    FSocket:TClientSocket;
    Fdata: TDetailBPModel;
    procedure Setdata(const Value: TDetailBPModel); //当前状态
    procedure qryStatus;
  public
    property data: TDetailBPModel read Fdata write Setdata;
  protected
    procedure timerOnTimer(Sender: TObject);
  end;

implementation

uses
  HDBManager, superobject;
{ TDetailInfoView }

constructor TDetailInfoView.Create(AOwner: TComponent);
begin
  inherited;

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

end;

destructor TDetailInfoView.Destroy;
begin
  if Assigned(FTimer) then
    FTimer.Free;
  if Assigned(statusLabel) then
    statusLabel.Free;
  if Assigned(descLabel) then
    descLabel.Free;
  inherited;
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
begin

end;

end.

