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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  procedure CreateUserWinForm;
var
  TUserForm: TTUserForm;

implementation

{$R *.dfm}
procedure CreateUserWinForm;
var
  sForm: TTUserForm;
begin
  sForm:=TTUserForm.Create(Application);
  sForm.ShowModal;
  sForm.Free;
end;

procedure TTUserForm.closeBtnClick(Sender: TObject);
begin
//
end;

procedure TTUserForm.FormCreate(Sender: TObject);
begin
  Self.Caption := '用户关联设置';
end;

procedure TTUserForm.saveBtnClick(Sender: TObject);
begin
//
end;

end.
