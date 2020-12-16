unit SetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TTSetForm = class(TForm)
    GroupLabel: TLabel;
    sNoLabel: TLabel;
    macLabel: TLabel;
    groupEdit: TEdit;
    sNoEdit: TEdit;
    macEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    descLabel: TLabel;
    descEdit: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
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

procedure TTSetForm.Button1Click(Sender: TObject);
begin
// save
end;

procedure TTSetForm.Button2Click(Sender: TObject);
begin
//close
end;

procedure TTSetForm.FormCreate(Sender: TObject);
begin
  self.Caption := '血压计信息录入';
end;

end.
