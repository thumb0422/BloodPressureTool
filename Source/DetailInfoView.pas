unit DetailInfoView;

interface

uses
  System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, System.SysUtils, Vcl.Forms,Generics.Collections,
  Vcl.Menus, Winapi.Windows, System.Win.ScktComp, DetailBPModel;

type
  TBPInfoStatus = (BPInfoStatusInit, BPInfoStatusConnecting, BPInfoStatusConnected, BPInfoStatusError);

type
  TDetailInfoView = class(TPanel)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    descLabel: TLabel; //血压计名称
    statusLabel: TLabel; //血压计状态
    FPopMenu: TPopupMenu;
    Fdata: TDetailBPModel;
    FBPStatus: TBPInfoStatus;
    procedure Setdata(const Value: TDetailBPModel); //当前状态
  public
    property data: TDetailBPModel read Fdata write Setdata;
    procedure reloadStatus(status: ConnectStatus);
  protected
    procedure onPopStartClick(Sender: TObject);
    procedure onPopStopClick(Sender: TObject);
    procedure onPopQryClick(Sender: TObject);
    procedure onPopStatusClick(Sender: TObject);
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
    Add(NewItem('启动', 0, False, True, onPopStartClick, 0, 'MenuItem1'));
    Add(NewLine);
    Add(NewItem('关闭', 0, False, True, onPopStopClick, 0, 'MenuItem2'));
    Add(NewLine);
    Add(NewItem('刷新', 0, False, True, onPopStatusClick, 0, 'MenuItem3'));
    Add(NewLine);
    Add(NewItem('查看', 0, False, True, onPopQryClick, 0, 'MenuItem4'));
  end;

  Self.PopupMenu := FPopMenu;
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

procedure TDetailInfoView.onPopStatusClick(Sender: TObject);
var
  macView: TDetailInfoView;
  macModel: TDetailBPModel;
  statusDic: TDictionary<string, TDetailBPModel>;
begin
  statusDic := TDataManager.Instance.bpQueue;
  statusDic.TryGetValue(Fdata.MMac,macModel);
  if Assigned(macModel) then
  begin
    reloadStatus(macModel.cStatus);
  end
  else
  begin
    reloadStatus(UnConnect);
  end;
end;

procedure TDetailInfoView.onPopStopClick(Sender: TObject);
begin
  TDataManager.Instance.stop(data);
end;

procedure TDetailInfoView.reloadStatus(status: ConnectStatus);
begin
  case status of
    UnConnect:
      begin
        statusLabel.Caption := '未启动';
      end;
    Connected:
      begin
        statusLabel.Caption := '已连接';
      end;
    OnLine:
      begin
        statusLabel.Caption := '测量中';
      end;
  end;
end;

procedure TDetailInfoView.Setdata(const Value: TDetailBPModel);
begin
  Fdata := Value;
  descLabel.Caption := '血压计-' + Fdata.MNo;
end;

end.

