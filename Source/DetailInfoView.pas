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
    descLabel: TLabel; //Ѫѹ������
    statusLabel: TLabel; //Ѫѹ��״̬
    FTimer: TTimer;
    FSocket:TClientSocket;
    Fdata: TDetailBPModel;
    procedure Setdata(const Value: TDetailBPModel); //��ǰ״̬
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
  descLabel.Caption := 'Ѫѹ��-';
  descLabel.Alignment := taLeftJustify;
  descLabel.Left := 5;
  descLabel.Top := 5;
  descLabel.Width := 120;
  descLabel.Height := 20;
  descLabel.Transparent := True;
  descLabel.Parent := Self;

  statusLabel := TLabel.Create(Self);
  statusLabel.Caption := 'δ����';
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
    statusLabel.Caption := 'δ����';
  end
  else if status = '1' then
  begin
    statusLabel.Caption := '������';
  end
  else
  begin
    statusLabel.Caption := '������';
  end;
end;

procedure TDetailInfoView.Setdata(const Value: TDetailBPModel);
begin
  Fdata := Value;
  descLabel.Caption := 'Ѫѹ��-' + Fdata.MDesc;
  qryStatus;
end;

procedure TDetailInfoView.timerOnTimer(Sender: TObject);
begin

end;

end.

