unit DetailDataForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,DetailBPModel;

type
  TTDetailDataForm = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    refreshBtn: TButton;
    closeBtn: TButton;
    ClientDataSet1MSBP: TStringField;
    ClientDataSet1MDBP: TStringField;
    ClientDataSet1MHR: TStringField;
    ClientDataSet1MMac: TStringField;
    procedure refreshBtnClick(Sender: TObject);
    procedure closeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FbpModel: TDetailBPModel;

    procedure QryData;
    procedure SetbpModel(const Value: TDetailBPModel);
    { Private declarations }
  public
    { Public declarations }
    property bpModel:TDetailBPModel read FbpModel write SetbpModel;
  end;

var
  TDetailDataForm: TTDetailDataForm;

implementation

uses
  HDBManager, superobject;
{$R *.dfm}

procedure TTDetailDataForm.closeBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TTDetailDataForm.FormCreate(Sender: TObject);
begin
//
end;

procedure TTDetailDataForm.FormShow(Sender: TObject);
begin
  Self.Caption := bpModel.MDesc + ':' + FormatDateTime('yyyy-mm-dd', now()) + '日数据查看';
  QryData;
end;

procedure TTDetailDataForm.QryData;
var
  jsonData: ISuperObject;
  subData: ISuperObject;
  sql: string;
  todayStr, beginTime, endTime: string;
begin
  todayStr := FormatDateTime('yyyy-mm-dd', now());
  beginTime := todayStr + ' 00:00:00';
  endTime := todayStr + ' 23:59:59';
  sql := Format('Select * from T_M_Datas where 1=1 and MMac = %s and  MDate between %s  and %s order by MDate', [QuotedStr(bpModel.MMac), QuotedStr(beginTime), QuotedStr(endTime)]);
  jsonData := TDBManager.Instance.getDataBySql(sql);
  ClientDataSet1.Close;
  ClientDataSet1.CreateDataSet;
  with ClientDataSet1 do
  begin
    if jsonData.I['rowCount'] > 0 then
    begin
      for subData in jsonData['data'] do
      begin
        Append;
        ClientDataSet1.FieldByName('MMac').AsString := subData.S['MMac'];
        ClientDataSet1.FieldByName('MSBP').AsString := subData['MSBP'].AsString;
        ClientDataSet1.FieldByName('MDBP').AsString := subData['MDBP'].AsString;
        ClientDataSet1.FieldByName('MHR').AsString := subData['MHR'].AsString;
        Post;
      end;
    end;
  end;

  if ClientDataSet1.Active = False then
  begin
    ClientDataSet1.Open;
  end;
end;

procedure TTDetailDataForm.refreshBtnClick(Sender: TObject);
begin
  QryData;
end;
procedure TTDetailDataForm.SetbpModel(const Value: TDetailBPModel);
begin
  FbpModel := Value;
end;

end.

