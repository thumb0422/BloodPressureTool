unit BPStatesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Math, DetailInfoView, Vcl.Menus,
  DetailBPModel;

type
  TTBPStatesForm = class(TForm)
    ScrollBox1: TScrollBox;
    PopupMenu1: TPopupMenu;
    refreshMenu: TMenuItem;
    allStartMenu: TMenuItem;
    allStopMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure refreshMenuClick(Sender: TObject);
    procedure allStartMenuClick(Sender: TObject);
    procedure allStopMenuClick(Sender: TObject);
  private
    { Private declarations }
    fViewsDic: TDictionary<string, TDetailInfoView>;
    bpInfoArray: array of TDetailBPModel;
    procedure initBPViews;
    procedure refreshBPViewsStatus;
    procedure resizeBPViewsUI;
  public
    { Public declarations }
  end;

procedure CreateBPStatesWinForm;

var
  TBPStatesForm: TTBPStatesForm;

implementation

uses
  HDBManager, superobject, DataManager;
{$R *.dfm}

procedure CreateBPStatesWinForm;
var
  sForm: TTBPStatesForm;
begin
  sForm := TTBPStatesForm.Create(Application);
  sForm.ShowModal;
  sForm.Free;
end;

procedure TTBPStatesForm.FormShow(Sender: TObject);
begin
  refreshBPViewsStatus;
end;

procedure TTBPStatesForm.initBPViews;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  sql: string;
  bpModel: TDetailBPModel;
  n: Integer;
begin
  sql := 'Select * from T_M_Infos where 1=1 ';
  jsonData := TDBManager.Instance.getDataBySql(sql);
  if jsonData.I['rowCount'] > 0 then
  begin
    SetLength(bpInfoArray, jsonData.I['rowCount']);
    n := 0;
    for subData in jsonData['data'] do
    begin
      bpModel := TDetailBPModel.Create;
      bpModel.MNo := subData.S['MNo'];
      bpModel.MMac := subData.S['MMac'];
      bpModel.MGroup := subData.S['MGroup'];
      bpModel.MDesc := subData.S['MDesc'];
      bpInfoArray[n] := bpModel;
      n := n + 1;
    end;
  end;
  resizeBPViewsUI;
end;

procedure TTBPStatesForm.refreshMenuClick(Sender: TObject);
begin
  refreshBPViewsStatus;
end;

procedure TTBPStatesForm.resizeBPViewsUI;
var
  I: Integer;
  detailView: TDetailInfoView;
  fWidth, fHeight, fSeperateWidth: Integer;
  fCol, fRow: Integer;
  J: Integer;
  fLeft, fTop: Integer;
  dataCount: Integer;
  tmpCount: Integer;
  bpModel: TDetailBPModel;
begin
  dataCount := Length(bpInfoArray);
  fWidth := 200;
  fHeight := 80;
  fSeperateWidth := 20;
  fCol := Trunc((ScrollBox1.ClientWidth - fSeperateWidth) / (fWidth + fSeperateWidth)); //列数
  fRow := Ceil(dataCount / fCol);   //行数
  tmpCount := 0;
  fViewsDic.Clear;
  for I := 0 to fRow - 1 do
  begin
    fTop := fSeperateWidth + I * (fHeight + fSeperateWidth);
    for J := 0 to fCol - 1 do
    begin
      if tmpCount >= dataCount then
      begin
        Break;
      end;
      fLeft := fSeperateWidth + J * (fWidth + fSeperateWidth);
      if (fLeft + fWidth + fSeperateWidth) > ScrollBox1.Width then
      begin
        Continue;
      end;
      bpModel := bpInfoArray[tmpCount];
      detailView := TDetailInfoView.Create(nil);
      detailView.Parent := ScrollBox1;
      detailView.Left := fLeft;
      detailView.Top := fTop;
      detailView.Width := fWidth;
      detailView.Height := fHeight;
      detailView.data := bpModel;
      detailView.Tag := 10000 + I * J;
      fViewsDic.AddOrSetValue(bpModel.MMac, detailView);
      tmpCount := tmpCount + 1;
    end;
  end;
end;

procedure TTBPStatesForm.refreshBPViewsStatus;
var
  macView: TDetailInfoView;
  macModel: TDetailBPModel;
  mac: string;
  statusDic: TDictionary<string, TDetailBPModel>;
begin
  statusDic := TDataManager.Instance.bpQueue;
  for mac in fViewsDic.Keys do
  begin
    macView := fViewsDic[mac];
    statusDic.TryGetValue(mac, macModel);
    if Assigned(macModel) then
    begin
      macView.reloadStatus(macModel.cStatus);
    end
    else
    begin
      macView.reloadStatus(UnConnect);
    end;
  end;
end;

procedure TTBPStatesForm.allStartMenuClick(Sender: TObject);
begin
  TDataManager.Instance.startAll;
end;

procedure TTBPStatesForm.allStopMenuClick(Sender: TObject);
begin
  TDataManager.Instance.stopAll;
end;

procedure TTBPStatesForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计状态列表';
  self.Height := 800;
  self.Width := 1200;
  fViewsDic := TDictionary<string, TDetailInfoView>.Create();
  initBPViews;
end;

end.

