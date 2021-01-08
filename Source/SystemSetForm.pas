unit SystemSetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TSystemSet = class(TForm)
    timeLabel: TLabel;
    timeEdit: TEdit;
    saveBtn: TButton;
    Label1: TLabel;
    procedure timeEditKeyPress(Sender: TObject; var Key: Char);
    procedure saveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SystemSet: TSystemSet;

implementation

uses
  HDBManager, superobject;
{$R *.dfm}

procedure TSystemSet.FormShow(Sender: TObject);
var
  jsonData: ISuperObject;
  subData: ISuperObject;
begin
  jsonData := TDBManager.Instance.getDataBySql('Select * From T_M_Set where MKey = "1000"');
  if jsonData.I['rowCount'] > 0 then
  begin
    for subData in jsonData['data'] do
    begin
      timeEdit.Text := subData['MValue'].AsString;
    end;
  end;
end;

procedure TSystemSet.saveBtnClick(Sender: TObject);
var
  sql: string;
  sqlList: TStringList;
  I: Integer;
begin
  if Trim(timeEdit.Text) = '' then
  begin
    ShowMessage('时间间隔 不能为空!');
  end
  else
  begin
    sqlList := TStringList.Create;
    sql := 'Delete from T_M_Set where 1=1 And MKey = "1000" ';
    sqlList.Add(sql);
    sql := Format('Insert Into T_M_Set (MKey,MValue) Values (%s,%s)', ['1000', QuotedStr(Trim(timeEdit.Text))]);
    sqlList.Add(sql);
    TDBManager.Instance.execSql(sqlList);
    ShowMessage('保存成功!');
  end;
end;

procedure TSystemSet.timeEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

end.

