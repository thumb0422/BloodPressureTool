unit BPStatesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.StdCtrls, System.Math, DetailInfoView;

type
  TTBPStatesForm = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    startBtn: TBitBtn;
    stopBtn: TBitBtn;
    refreshBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure startBtnClick(Sender: TObject);
    procedure stopBtnClick(Sender: TObject);
    procedure refreshBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure initBPView;
  public
    { Public declarations }
  end;

procedure CreateBPStatesWinForm;

var
  TBPStatesForm: TTBPStatesForm;

implementation

uses
  HDBManager, superobject, DetailBPModel;
{$R *.dfm}

procedure CreateBPStatesWinForm;
var
  sForm: TTBPStatesForm;
begin
  sForm := TTBPStatesForm.Create(Application);
  sForm.ShowModal;
  sForm.Free;
end;

procedure TTBPStatesForm.initBPView;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  sql: string;
  bpInfoArray: array of TDetailBPModel;
  bpModel: TDetailBPModel;
  n: Integer;
  I: Integer;
  detailView: TDetailInfoView;
  fWidth, fHeight, fSeperateWidth: Integer;
  fCol, fRow: Integer;
  J: Integer;
  fLeft, fTop: Integer;
  dataCount: Integer;
  tmpCount: Integer;
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
  dataCount := Length(bpInfoArray);
  fWidth := 200;
  fHeight := 80;
  fSeperateWidth := 20;
  fCol := Trunc((ScrollBox1.ClientWidth - fSeperateWidth) / (fWidth + fSeperateWidth)); //列数
  fRow := Ceil(dataCount / fCol);   //行数
  tmpCount := 0;
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
      tmpCount := tmpCount + 1;
    end;
  end;
end;

procedure TTBPStatesForm.refreshBtnClick(Sender: TObject);
begin
//
end;

procedure TTBPStatesForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计状态列表';
  self.Height := 1200;
  self.Width := 1800;
  initBPView;
end;

procedure TTBPStatesForm.startBtnClick(Sender: TObject);
begin
//
end;

procedure TTBPStatesForm.stopBtnClick(Sender: TObject);
begin
//
end;

end.

