unit SetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids,BPModel, Datasnap.DBClient, Datasnap.Provider;

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
    Button1: TButton;
    descEdit: TEdit;
    addBtn: TButton;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1MNo: TStringField;
    ClientDataSet1MMac: TStringField;
    ClientDataSet1MGroup: TStringField;
    ClientDataSet1MDesc: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure addBtnClick(Sender: TObject);
  private
    { Private declarations }
//    function praseModelToDataSet
    procedure generateDatas;
  public
    { Public declarations }
  end;
procedure CreateSetWinForm;
var
  TSetForm: TTSetForm;

implementation

{$R *.dfm}
procedure CreateSetWinForm;
var
  sForm: TTSetForm;
begin
  sForm:=TTSetForm.Create(Application);
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

procedure TTSetForm.Button1Click(Sender: TObject);
begin
// save
end;

procedure TTSetForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计信息录入';
//  self.ClientDataSet1 := TClientDataSet.Create(Self);
//  Self.generateDatas;
end;

procedure TTSetForm.generateDatas;
var
  I: Integer;
begin
self.ClientDataSet1.DisableControls;
  self.ClientDataSet1.Active := False;
  self.ClientDataSet1.Open;
  for I := 0 to 10 do
  begin
    self.ClientDataSet1.Append;
    self.ClientDataSet1.ParamByName('MNo').AsString := IntToStr(i*100 + 1);
    self.ClientDataSet1.ParamByName('MMac').AsString := 'XXXXXXXX';
    self.ClientDataSet1.ParamByName('MGroup').AsString := '192.168.1.'+ IntToStr(i*3);
    self.ClientDataSet1.ParamByName('MDesc').AsString := '测试' + IntToStr(i*4);
    self.ClientDataSet1.Post;
  end;
  self.ClientDataSet1.EnableControls;
end;

end.
