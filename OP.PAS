unit OP;

interface

uses Objects;

type
  TCharSet = set of Char;

const
  Space: TCharSet = [#9, ' ']; { enthält Zeichen, die als Leerraum zu
    interpretieren sind, kann bei Bedarf geändert werden. }

function Parse(x, Separator: string; var Right: string): string; { gibt den
  Teil von x vor der Zeichenkette Separator zurück. Wenn Separator nicht in
  x enthalten ist, wird x vollständig zurückgegeben. Der Teil von x, der übrig-
  bleibt, wird in Right zurückgegeben. Der Rückgabewert und Right werdeb ggf.
  um führenden und abschließenden Leerraum (Zeichen in Space) verkürzt. }

procedure ParseStringList(x, Separator: string; var List: array of string);
{ Zerlegt eine durch den String Separator getrennte Aufzähling, die in x
  übergeben wird, in ein Array of string, das in List zurückgegeben wird. List
  muß eine Variable ausreichender Größe sein. Ist List zu klein, wird nur ein
  passendes Anfangsstück von x zerlegt. }

function StringValue(x: PString): string; { ergibt immer einen gültigen String,
  wenn x vom Typ PString oder kompatibel ist. x=nil ergibt ''. Die Wertzuweisung
  zu x könnte z.B. mit AssignStr erfolgen. }

function SetStringValue(var x: PString; S: string): PString;

function Trimm(x: string): string; { entfernt führenden und abschließenden Leer-
  raum (Zeichen in Space) aus x und gibt die so veränderte Zeichenkette zurück }

implementation

function Parse(x, Separator: string; var Right: string): string;
var n, P: Byte;
begin
  x := Trimm(x);
  P := Pos(Separator, x);
  if P > 0 then begin
    Parse := Trimm(Copy(x, 1, P - 1));
    Right := Trimm(Copy(x, P + Length(Separator), 255))
  end
  else begin
    Parse := x;
    Right := ''
  end
end;

procedure ParseStringList(x, Separator: string; var List: array of string);
var
  i, n: Integer;
begin
  n := High(List);
  for i := Low(List) to n do List[i] := Parse(x, Separator, x)
end;

function StringValue(x: PString): string;
begin
  if Assigned(x) then StringValue := x^
  else StringValue := ''
end;

function SetStringValue(var x: PString; S: string): PString;
begin
  if x <> nil then DisposeStr(x);
  x := NewStr(S);
  SetStringValue := x;
end;

function Trimm(x: string): string;
var
  i, j, n: Byte;
begin
  n := Length(x);
  for i := 1 to n do
    if not (x[i] in Space) then Break;
  for j := n downto i do
    if not (x[j] in Space) then Break;
  Trimm := Copy(x, i, j + 1 - i);
end;

end.
