unit Tool;

interface

uses
  System.SysUtils;

function StrToHex(src: string): string;

function HexToStr(src: string): string;

function HexToAscII(src: string): Integer;

implementation

function StrToHex(src: string): string;
var
  i: integer;
  des: string;
begin
  des := '';
  for i := 1 to Length(src) do
  begin
    des := des + IntToHex(Ord(src[i]), 2) + ' ';
  end;
  Result := des;
end;

function HexToStr(src: string): string;

  function HexToInt(hex: string): integer;
  var
    i: integer;

    function Ncf(num, f: integer): integer;
    var
      i: integer;
    begin
      Result := 1;
      if f = 0 then
        exit;
      for i := 1 to f do
        result := result * num;
    end;

    function HexCharToInt(HexToken: char): integer;
    begin
      if HexToken > #97 then
        HexToken := Chr(Ord(HexToken) - 32);
      Result := 0;
      if (HexToken > #47) and (HexToken < #58) then { chars 0....9 }
        Result := Ord(HexToken) - 48
      else if (HexToken > #64) and (HexToken < #71) then { chars A....F }
        Result := Ord(HexToken) - 65 + 10;
    end;

  begin
    result := 0;
    hex := ansiuppercase(trim(hex));
    if hex = '' then
      exit;
    for i := 1 to length(hex) do
      result := result + HexCharToInt(hex[i]) * ncf(16, length(hex) - i);
  end;

var
  s, t: string;
  i, j: integer;
  p: pchar;
begin
  s := '';
  i := 1;
  while i < Length(src) do
  begin
    t := src[i] + src[i + 1];
    s := s + chr(HexToInt(t));
    i := i + 2;
  end;
  result := s;
end;

function HexToAscII(src: string): integer;
var
  i: Integer;
  tmpStr: string;
begin
  tmpStr := '';
  i := 1;
  while i < Length(src) do
  begin
    tmpStr := tmpStr + Chr(StrToIntDef('$' + Copy(src, i, 2), 0));
    Inc(i, 2);
  end;
  Result := StrToInt(tmpStr)
end;

end.

