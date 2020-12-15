unit UserForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TTUserForm = class(TForm)
    userLabel: TLabel;
    bpLabel: TLabel;
    userEdit: TEdit;
    bpEdit: TEdit;
    saveBtn: TButton;
    closeBtn: TButton;
    procedure saveBtnClick(Sender: TObject);
    procedure closeBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TUserForm: TTUserForm;

implementation

{$R *.dfm}

procedure TTUserForm.closeBtnClick(Sender: TObject);
begin
//
end;

procedure TTUserForm.saveBtnClick(Sender: TObject);
begin
//
end;

end.
