{*******************************************************}
{                                                       }
{       HimsSoft                                        }
{                                                       }
{       °æÈ¨ËùÓÐ (C) 2019 thumb0422@163.com             }
{                                                       }
{*******************************************************}

unit HDBManager;

interface
uses System.Classes,System.SysUtils, SQLiteTable3,superobject;
  type
  TDBManager = class
  private
    class var FInstance: TDBManager;
    class function GetInstance: TDBManager; static;
  public
    class property Instance: TDBManager read GetInstance;
    class procedure ReleaseInstance;
    procedure execSql(sqls:TStringList);
    function getDataBySql(sql:string):ISuperObject;
    procedure execSqlByFromLocalFile(filePath:string = '');
    constructor Create;
    destructor Destroy; override;
  private
    fDB: TSQLiteDatabase;
    fTB: TSQLIteTable;
  end;

implementation
{ TDBManager }

constructor TDBManager.Create;
var
  slDBpath: string;
begin
  slDBpath := ExtractFilePath(paramstr(0)) + 'db.db';
  fDB := TSQLiteDatabase.Create(slDBpath);
  execSqlByFromLocalFile('');
end;

destructor TDBManager.Destroy;
begin
  fDB.Free;
  fTB.Free;
  inherited;
end;

procedure TDBManager.execSql(sqls: TStringList);
var
  I: Integer;
begin
  if Assigned(fDB) then
  begin
    fDB.BeginTransaction;
    for I := 0 to sqls.Count - 1 do
    begin
      fDB.ExecSQL(sqls[I]);
    end;
    fDB.Commit;
  end;
end;

procedure TDBManager.execSqlByFromLocalFile(filePath:string = '');
var sourceScript,destScript:TStringList;
    lscriptStr1,lscriptStr2:string;
    sqlPath :string;
    I: Integer;
begin
  if filePath = '' then
  begin
    sqlPath := ExtractFilePath(paramstr(0)) + 'sql.sql';
  end
  else
  begin
    sqlPath := ExtractFilePath(paramstr(0)) + filePath;
  end;
  if FileExists(sqlPath) then
  begin
    destScript := TStringList.Create;
    sourceScript := TStringList.Create;
    sourceScript.LoadFromFile(sqlPath);
    lscriptStr1 := '';
    for I := 0 to sourceScript.Count-1 do
    begin
       lscriptStr2 := sourceScript[I];
       if lscriptStr2.IsEmpty then
       begin
         Continue;
       end;
       if Pos(';',lscriptStr2) = 0  then
       begin
         lscriptStr1 := lscriptStr1 + lscriptStr2;
       end
       else
       begin
         lscriptStr1 := lscriptStr1 + lscriptStr2;
         destScript.Add(lscriptStr1);
         lscriptStr1 := '';
       end;
    end;
    execSql(destScript);
  end;
end;

function TDBManager.getDataBySql(sql: string):ISuperObject;
var
  lTB: TSQLIteTable;
  lColStr, lRowStr: string;
  J: Integer;
  lJson,arrayJson, subJson: ISuperObject;
begin
  lJson := SO;
  if Assigned(fDB) then
  begin
    lTB := fDB.GetTable(sql);
    try
      if lTB.Count > 0 then
      begin
        lColStr := '';
        lRowStr := '';
        lJson.S['rowCount'] := IntToStr(lTB.Count);
        lJson.S['colCount'] := IntToStr(lTB.ColCount);
        arrayJson:= SA([]);
        with lTB do
        begin
          MoveFirst;
          while not EOF do
          begin
            subJson := SO;
            for J := 0 to lTB.ColCount - 1 do
            begin
              lColStr := lTB.Columns[J];
              lRowStr := lTB.FieldAsString(J);
              subJson.S[lColStr] := lRowStr;
            end;
            arrayJson.AsArray.Add(subJson);
            Next;
          end;
        end;
        lJson.O['data'] :=arrayJson;
      end
      else
      begin

      end;
    finally
      lTB.Free;
    end;
  end;
  Result := lJson;
end;

class function TDBManager.GetInstance: TDBManager;
begin
  if FInstance = nil then
    FInstance := TDBManager.Create;
  Result := FInstance;
end;

class procedure TDBManager.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

end.
