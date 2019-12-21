unit Patch;

interface

function HexToStr(x: Longint): string;

implementation

uses Drivers;

function HexToStr(x: Longint): string;
var y: string;
begin
  FormatStr(y, '%x', x);
  HexToStr := y
end;

end.