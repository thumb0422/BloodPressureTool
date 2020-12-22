unit SetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.DBGrids, Datasnap.DBClient, Vcl.DBCtrls, Vcl.Mask, Vcl.Grids, Vcl.Menus;

type
  TTSetForm = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    GroupLabel: TLabel;
    sNoLabel: TLabel;
    macLabel: TLabel;
    descLabel: TLabel;
    saveBtn: TButton;
    addBtn: TButton;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1MNo: TStringField;
    ClientDataSet1MMac: TStringField;
    ClientDataSet1MGroup: TStringField;
    ClientDataSet1MDesc: TStringField;
    groupEdit: TDBEdit;
    noEdit: TDBEdit;
    macEdit: TDBEdit;
    descEdit: TDBEdit;
    delBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure addBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure delBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure QryDatas;
  public
    { Public declarations }
  end;

procedure CreateSetWinForm;

var
  TSetForm: TTSetForm;

implementation

uses
  HDBManager, superobject;
{$R *.dfm}

procedure CreateSetWinForm;
var
  sForm: TTSetForm;
begin
  sForm := TTSetForm.Create(Application);
  sForm.ShowModal;
  sForm.Free;
end;

procedure TTSetForm.addBtnClick(Sender: TObject);
begin
  if ClientDataSet1.Active = False then
  begin
    ClientDataSet1.Open;
  end;
  ClientDataSet1.Append;
end;

procedure TTSetForm.delBtnClick(Sender: TObject);
begin
  ClientDataSet1.Delete;
end;

procedure TTSetForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计信息录入';
  QryDatas;
end;

procedure TTSetForm.QryDatas;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
begin
  ClientDataSet1.Close;
  ClientDataSet1.CreateDataSet;
  jsonData := TDBManager.Instance.getDataBySql('Select * From T_M_Infos Order By id');
  with ClientDataSet1 do
  begin
    if jsonData.I['rowCount'] > 0 then
    begin
      for subData in jsonData['data'] do
      begin
        Append;
        ClientDataSet1.FieldByName('MNo').AsString := subData.S['MNo'];
        ClientDataSet1.FieldByName('MMac').AsString := subData['MMac'].AsString;
        ClientDataSet1.FieldByName('MGroup').AsString := subData['MGroup'].AsString;
        ClientDataSet1.FieldByName('MDesc').AsString := subData['MDesc'].AsString;
        Post;
      end;
    end;
  end;

  if ClientDataSet1.Active = False then
  begin
    ClientDataSet1.Open;
  end;
end;

procedure TTSetForm.saveBtnClick(Sender: TObject);
var
  sql: string;
  sqlList: TStringList;
  I: Integer;
begin
  if Trim(groupEdit.Text) = '' then
  begin
    ShowMessage('IP 不能为空');
  end
  else if Trim(noEdit.Text) = '' then
  begin
    ShowMessage('编号 不能为空');
  end
  else if Trim(macEdit.Text) = '' then
  begin
    ShowMessage('mac 不能为空');
  end
  else
  begin
    if ClientDataSet1.Active = True then
    begin
      if ClientDataSet1.State = dsEdit then
        ClientDataSet1.Post;
    end;
    sqlList := TStringList.Create;
    sql := 'Delete from T_M_Infos where 1=1 ';
    sqlList.Add(sql);
    ClientDataSet1.DisableControls;
    ClientDataSet1.First;
    while not ClientDataSet1.Eof do
    begin
      sql := Format('Insert Into T_M_Infos (MNo,MMac,MGroup,MDesc) Values (%s,%S,%s,%s)', [QuotedStr(ClientDataSet1.FieldByName('MNo').AsString), QuotedStr(ClientDataSet1.FieldByName('MMac').AsString), QuotedStr(ClientDataSet1.FieldByName('MGroup').AsString), QuotedStr(ClientDataSet1.FieldByName('MDesc').AsString)]);
      sqlList.Add(sql);
      ClientDataSet1.Next;
    end;
    ClientDataSet1.EnableControls;
    TDBManager.Instance.execSql(sqlList);
    QryDatas;
  end;

end;

end.

