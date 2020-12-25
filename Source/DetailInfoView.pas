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
    descLabel: TLabel; //Ѫѹ������
    statusLabel: TLabel; //Ѫѹ��״̬
    FPopMenu: TPopupMenu;
    Fdata: TDetailBPModel;
    FBPStatus: TBPInfoStatus;
    procedure Setdata(const Value: TDetailBPModel); //��ǰ״̬
    procedure qryStatus;
  public
    property data: TDetailBPModel read Fdata write Setdata;
  protected
    procedure onPopStartClick(Sender: TObject);
    procedure onPopStopClick(Sender: TObject);
    procedure onPopQryClick(Sender: TObject);
  end;

implementation

uses
  HDBManager, superobject, TLog, DetailDataForm, DataManager;
{ TDetailInfoView }

constructor TDetailInfoView.Create(AOwner: TComponent);
begin
  inherited;

  FPopMenu := TPopupMenu.Create(Self);
  with FPopMenu.Items do
  begin
    Add(NewItem('����', 0, False, True, onPopStartClick, 0, 'MenuItem1'));
    Add(NewLine);
    Add(NewItem('�ر�', 0, False, True, onPopStopClick, 0, 'MenuItem2'));
    Add(NewLine);
    Add(NewItem('�鿴', 0, False, True, onPopQryClick, 0, 'MenuItem3'));
  end;

  Self.PopupMenu := FPopMenu;
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
end;

destructor TDetailInfoView.Destroy;
begin
  if Assigned(statusLabel) then
    statusLabel.Free;
  if Assigned(descLabel) then
    descLabel.Free;
  inherited;
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
  TDataManager.Instance.start(data);
end;

procedure TDetailInfoView.onPopStopClick(Sender: TObject);
begin
  TDataManager.Instance.stop(data);
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
  if status = '1' then
  begin
    statusLabel.Caption := '������';
  end
  else
  begin
    statusLabel.Caption := 'δ����';
  end;
end;

procedure TDetailInfoView.Setdata(const Value: TDetailBPModel);
begin
  Fdata := Value;
  descLabel.Caption := 'Ѫѹ��-' + Fdata.MNo;
  qryStatus;
end;

end.

