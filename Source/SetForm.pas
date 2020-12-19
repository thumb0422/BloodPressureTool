unit SetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, BPModel, Datasnap.DBClient, Datasnap.Provider;

type
  TTSetForm = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    GroupLabel: TLabel;
    sNoLabel: TLabel;
    macLabel: TLabel;
    descLabel: TLabel;
    groupEdit: TEdit;
    sNoEdit: TEdit;
    macEdit: TEdit;
    saveBtn: TButton;
    descEdit: TEdit;
    addBtn: TButton;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1MNo: TStringField;
    ClientDataSet1MMac: TStringField;
    ClientDataSet1MGroup: TStringField;
    ClientDataSet1MDesc: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure addBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
  private
    { Private declarations }
//    function praseModelToDataSet
    procedure generateDatas;
    procedure checkDataValid;
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
  self.sNoEdit.Clear;
  self.groupEdit.Clear;
  self.macEdit.Clear;
  self.descEdit.Clear;
end;

procedure TTSetForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计信息录入';
//  Self.generateDatas;
  QryDatas
end;

procedure TTSetForm.generateDatas;
var
  I: Integer;
begin
  ClientDataSet1.CreateDataSet;
  ClientDataSet1.DisableControls;
  for I := 0 to 10 do
  begin
    with ClientDataSet1 do
    begin
      Append;
      ClientDataSet1.FieldByName('MNo').AsString := IntToStr(I * 100 + 1);
      ClientDataSet1.FieldByName('MMac').AsString := 'XXXXXXXX';
      ClientDataSet1.FieldByName('MGroup').AsString := '192.168.1.' + IntToStr(I * 3);
      ClientDataSet1.FieldByName('MDesc').AsString := '测试' + IntToStr(I * 4);
      Post;
    end;

  end;
  self.ClientDataSet1.EnableControls;
  if ClientDataSet1.Active = False then
  begin
    ClientDataSet1.Open;
  end;
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
begin
  //todo  check data valid
  checkDataValid;
  sqlList := TStringList.Create;
  sql := Format('Delete from T_M_Infos where 1=1 and MMac = %s', [QuotedStr(macEdit.Text)]);
  sqlList.Add(sql);
  sql := Format('Insert Into T_M_Infos (MNo,MMac,MGroup,MDesc) Values (%s,%S,%s,%s)', [QuotedStr(sNoEdit.Text), QuotedStr(macEdit.Text), QuotedStr(groupEdit.Text), QuotedStr(descEdit.Text)]);
  sqlList.Add(sql);
  TDBManager.Instance.execSql(sqlList);
  QryDatas;
end;

procedure checkDataValid;
begin

end;
end.

