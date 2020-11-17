unit TLog;

interface

uses
  System.SysUtils, System.SyncObjs;

type
  TDLog = class(TObject)
  private
    class var
      FInstance: TDLog;
    class function GetInstance: TDLog; static;
  public
    class property Instance: TDLog read GetInstance;
    class procedure ReleaseInstance;
    constructor Create;
    destructor Destroy; override;
    procedure writeLog(str: string);
  end;

implementation

var
  CriticalSection: TCriticalSection;

{ TDLog }

constructor TDLog.Create;
begin

end;

destructor TDLog.Destroy;
begin

  inherited;
end;

class function TDLog.GetInstance: TDLog;
begin
  if FInstance = nil then
    FInstance := TDLog.Create;
  Result := FInstance;
end;

class procedure TDLog.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

procedure TDLog.writeLog(str: string);
var
  wLogFile: TextFile;
  DateTime: TDateTime;
  strTxtName, strContent: string;
begin
  CriticalSection.Acquire;
  try
    DateTime := now;
    strTxtName := ExtractFilePath(paramstr(0)) + FormatdateTime('yyyy-mm-dd', DateTime) + '.log';
    AssignFile(wLogFile, strTxtName);
    if FileExists(strTxtName) then
      Append(wLogFile)
    else
    begin
      ReWrite(wLogFile);
    end;
    strContent := FormatdateTime('hh:nn:ss:zz', DateTime) + ' ' + str;
    Writeln(wLogFile, strContent);
    CloseFile(wLogFile);
  finally
    CriticalSection.Release;
  end;
end;

initialization
  CriticalSection := TCriticalSection.Create;

finalization
  CriticalSection.Free;

end.

