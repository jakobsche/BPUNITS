unit AJString;

interface

uses Objects;

(* Achtung: Die folgenden Funktionen funktionieren fÅr deutsche Umlaute nur
   unter DOS richtig. FÅr Windows mu· der Quellcode angepa·t werden. *)

function LowerCase(x: string): string; (* wandelt x in Kleinbuchstaben um *)

function UpperCase(x: string): string; (* wandelt x in Gro·buchstaben um *)

function StrAlloc(Size: Word): PChar;

function StringValue(StrPtr: PString): string;

implementation

function LowerCase(x: string): string;
var
  i: Byte;
  y: array[Byte] of Byte absolute x;
begin
  for i := 1 to y[0] do
    if x[i] in ['A'..'Z', 'é', 'ô', 'ö'] then y[i] := y[i] or $20;
  LowerCase := x
end;

function UpperCase(x: string): string;
var
  i: Byte;
  y: array[Byte] of Byte absolute x;
begin
  for i := 1 to y[0] do
    if x[i] in ['a'..'z', 'Ñ', 'î', 'Å'] then y[i] := y[i] and not $20;
  UpperCase := x
end;

function StrAlloc(Size: Word): PChar;
var P: PChar;
begin
  GetMem(P, Size);
  StrAlloc := P
end;

function StringValue(StrPtr: PString): string;
begin
  if Assigned(StrPtr) then StringValue := StrPtr^
  else StringValue := ''
end;

end.
