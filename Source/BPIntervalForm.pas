unit BPIntervalForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DetailBPModel, Vcl.StdCtrls;

type
  TBPIntervalSetForm = class(TForm)
    Label1: TLabel;
    IntervalEdit: TEdit;
    saveBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure IntervalEditKeyPress(Sender: TObject; var Key: Char);
  private
    FmacModel: TDetailBPModel;
    procedure SetmacModel(const Value: TDetailBPModel);
    { Private declarations }
  public
    { Public declarations }
    property macModel: TDetailBPModel read FmacModel write SetmacModel;
  end;

var
  BPIntervalSetForm: TBPIntervalSetForm;

implementation

uses
  HDBManager, superobject, TLog, DataManager;
{$R *.dfm}

{ TBPIntervalSetForm }

procedure TBPIntervalSetForm.FormShow(Sender: TObject);
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  sql: string;
begin
  self.Caption :=  '血压计-' + macModel.MNo;
  sql := Format('Select * from T_M_Infos where 1=1 and MMac = %s ', [QuotedStr(macModel.MMac)]);
  jsonData := TDBManager.Instance.getDataBySql(sql);
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      IntervalEdit.Text := subData['MInterval'].AsString;
    end;
  end;
end;

procedure TBPIntervalSetForm.IntervalEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TBPIntervalSetForm.saveBtnClick(Sender: TObject);
var
  sqlList: TStringList;
  sql: string;
begin
  if Length(Trim(IntervalEdit.Text)) < 1 then
  begin
    ShowMessage('测量间隔 不能为空');
  end
  else
  begin
    sqlList := TStringList.Create;
    sql := Format('Delete from T_M_Infos where 1=1 and MMac = %s ', [QuotedStr(macModel.MMac)]);
    sqlList.Add(sql);
    sql := Format('Insert Into T_M_Infos (MNo,MMac,MGroup,MDesc,MInterval) Values (%s,%S,%s,%s,%s)', [QuotedStr(macModel.MNo), QuotedStr(macModel.MMac), QuotedStr(macModel.MGroup), QuotedStr(macModel.MDesc), QuotedStr(IntervalEdit.Text)]);
    sqlList.Add(sql);
    TDBManager.Instance.execSql(sqlList);
    TDataManager.Instance.setInterval(macModel);
  end;
end;

procedure TBPIntervalSetForm.SetmacModel(const Value: TDetailBPModel);
begin
  FmacModel := Value;
end;

end.

