unit DetailInfoView;

interface

uses
  System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, System.SysUtils, Vcl.Forms,
  Generics.Collections, Vcl.Menus, Winapi.Windows, System.Win.ScktComp,
  DetailBPModel;

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
    procedure onPopSendClick(Sender: TObject);
    procedure onPopIntervalClick(Sender: TObject);
    procedure onPopStopClick(Sender: TObject);
    procedure onPopQryClick(Sender: TObject);
    procedure onPopStatusClick(Sender: TObject);
  private
    menuItemStart, menuItemSend,menuItemInterval, menuItemStop, menuItemQry: TMenuItem;
    procedure reloadPopMenuStatus(status: ConnectStatus);
    procedure PopupMenu1Popup(Sender: TObject);
  end;

implementation

uses
  HDBManager, superobject, TLog, DetailDataForm, DataManager,BPIntervalForm;
{ TDetailInfoView }

constructor TDetailInfoView.Create(AOwner: TComponent);
begin
  inherited;
  FPopMenu := TPopupMenu.Create(Self);
  FPopMenu.OnPopup := PopupMenu1Popup;

  menuItemStart := TMenuItem.Create(FPopMenu);
  menuItemStart.Caption := '启动';
  menuItemStart.OnClick := onPopStartClick;
  FPopMenu.Items.Add(menuItemStart);

  FPopMenu.Items.Add(NewLine);

  menuItemSend := TMenuItem.Create(FPopMenu);
  menuItemSend.Caption := '测量';
  menuItemSend.OnClick := onPopSendClick;
  FPopMenu.Items.Add(menuItemSend);

  FPopMenu.Items.Add(NewLine);

  menuItemInterval := TMenuItem.Create(FPopMenu);
  menuItemInterval.Caption := '设置测量间隔';
  menuItemInterval.OnClick := onPopIntervalClick;
  FPopMenu.Items.Add(menuItemInterval);

  FPopMenu.Items.Add(NewLine);

  menuItemQry := TMenuItem.Create(FPopMenu);
  menuItemQry.Caption := '查看';
  menuItemQry.OnClick := onPopQryClick;
  FPopMenu.Items.Add(menuItemQry);

  FPopMenu.Items.Add(NewLine);

  menuItemStop := TMenuItem.Create(FPopMenu);
  menuItemStop.Caption := '停止';
  menuItemStop.OnClick := onPopStopClick;
  FPopMenu.Items.Add(menuItemStop);

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

procedure TDetailInfoView.onPopIntervalClick(Sender: TObject);
var
  sForm: TBPIntervalSetForm;
begin
  sForm := TBPIntervalSetForm.Create(Application);
  sForm.macModel := data;
  sForm.ShowModal;
  sForm.Free;
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

procedure TDetailInfoView.onPopSendClick(Sender: TObject);
begin
  TDataManager.Instance.send(data);
end;

procedure TDetailInfoView.onPopStartClick(Sender: TObject);
begin
  TDataManager.Instance.start(data);
end;

procedure TDetailInfoView.onPopStatusClick(Sender: TObject);
var
  macModel: TDetailBPModel;
  statusDic: TDictionary<string, TDetailBPModel>;
begin
  statusDic := TDataManager.Instance.bpQueue;
  statusDic.TryGetValue(Fdata.MMac, macModel);
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

procedure TDetailInfoView.PopupMenu1Popup(Sender: TObject);
var
  macModel: TDetailBPModel;
  statusDic: TDictionary<string, TDetailBPModel>;
begin
  statusDic := TDataManager.Instance.bpQueue;
  statusDic.TryGetValue(Fdata.MMac, macModel);
  if Assigned(macModel) then
  begin
    reloadPopMenuStatus(macModel.cStatus);
  end
  else
  begin
    reloadPopMenuStatus(UnConnect);
  end;
end;

procedure TDetailInfoView.reloadStatus(status: ConnectStatus);
begin
  case status of
    UnConnect:
      begin
        statusLabel.Caption := '未启动';
      end;
    OnLine:
      begin
        statusLabel.Caption := '已连接';
      end;
    OnWorking:
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

procedure TDetailInfoView.reloadPopMenuStatus(status: ConnectStatus);
begin
  case status of
    UnConnect:
      begin
        menuItemStart.Enabled := True;
        menuItemSend.Enabled := False;
        menuItemStop.Enabled := False;
        menuItemInterval.Enabled := False;
      end;
    OnLine:
      begin
        menuItemStart.Enabled := False;
        menuItemSend.Enabled := True;
        menuItemStop.Enabled := True;
        menuItemInterval.Enabled := True;
      end;
    OnWorking:
      begin
        menuItemStart.Enabled := False;
        menuItemSend.Enabled := True;
        menuItemStop.Enabled := True;
        menuItemInterval.Enabled := True;
      end;
  end;
end;

end.

