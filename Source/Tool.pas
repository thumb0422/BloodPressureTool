unit Tool;

interface

uses
  System.SysUtils;

function StrToHex(src: string): string;

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

end.

