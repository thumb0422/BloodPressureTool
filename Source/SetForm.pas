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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TSetForm: TTSetForm;

implementation

{$R *.dfm}

procedure TTSetForm.Button1Click(Sender: TObject);
begin
// save
end;

procedure TTSetForm.Button2Click(Sender: TObject);
begin
//close
end;

end.
