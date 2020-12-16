unit BPStatesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TTBPStatesForm = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    startBtn: TBitBtn;
    stopBtn: TBitBtn;
    refreshBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure startBtnClick(Sender: TObject);
    procedure stopBtnClick(Sender: TObject);
    procedure refreshBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
procedure CreateBPStatesWinForm;
var
  TBPStatesForm: TTBPStatesForm;

implementation

{$R *.dfm}

procedure CreateBPStatesWinForm;
var
  sForm: TTBPStatesForm;
begin
  sForm:=TTBPStatesForm.Create(Application);
  sForm.ShowModal;
  sForm.Free;
end;
procedure TTBPStatesForm.refreshBtnClick(Sender: TObject);
begin
//
end;

procedure TTBPStatesForm.FormCreate(Sender: TObject);
begin
  self.Caption := 'ÑªÑ¹¼Æ×´Ì¬ÁÐ±í';
  self.Height := 1200;
  self.Width := 1800;
end;

procedure TTBPStatesForm.startBtnClick(Sender: TObject);
begin
//
end;

procedure TTBPStatesForm.stopBtnClick(Sender: TObject);
begin
//
end;

end.
