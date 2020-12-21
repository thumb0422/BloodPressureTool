unit DataManager;

interface

uses
  System.SysUtils, System.Win.ScktComp;

type
  TDataManager = class(TObject)
  private
    class var
      FInstance: TDataManager;
    class function GetInstance: TDataManager; static;
  public
    class property Instance: TDataManager read GetInstance;
    class procedure ReleaseInstance;
    constructor Create;
    destructor Destroy; override;
  protected
    procedure timerOnTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
  end;

implementation

{ TDataManager }

procedure TDataManager.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin

end;

procedure TDataManager.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure TDataManager.ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

constructor TDataManager.Create;
begin

end;

destructor TDataManager.Destroy;
begin

  inherited;
end;

class function TDataManager.GetInstance: TDataManager;
begin
  if FInstance = nil then
    FInstance := TDataManager.Create;
  Result := FInstance;
end;

class procedure TDataManager.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

procedure TDataManager.timerOnTimer(Sender: TObject);
begin

end;

end.

