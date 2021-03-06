unit OP;

interface

uses Objects;

type
  TCharSet = set of Char;

const
  Space: TCharSet = [#9, ' ']; { enth�lt Zeichen, die als Leerraum zu
    interpretieren sind, kann bei Bedarf ge�ndert werden. }

function Parse(x, Separator: string; var Right: string): string; { gibt den
  Teil von x vor der Zeichenkette Separator zur�ck. Wenn Separator nicht in
  x enthalten ist, wird x vollst�ndig zur�ckgegeben. Der Teil von x, der �brig-
  bleibt, wird in Right zur�ckgegeben. Der R�ckgabewert und Right werdeb ggf.
  um f�hrenden und abschlie�enden Leerraum (Zeichen in Space) verk�rzt. }

procedure ParseStringList(x, Separator: string; var List: array of string);
{ Zerlegt eine durch den String Separator getrennte Aufz�hling, die in x
  �bergeben wird, in ein Array of string, das in List zur�ckgegeben wird. List
  mu� eine Variable ausreichender Gr��e sein. Ist List zu klein, wird nur ein
  passendes Anfangsst�ck von x zerlegt. }

function StringValue(x: PString): string; { ergibt immer einen g�ltigen String,
  wenn x vom Typ PString oder kompatibel ist. x=nil ergibt ''. Die Wertzuweisung
  zu x k�nnte z.B. mit AssignStr erfolgen. }

function SetStringValue(var x: PString; S: string): PString;

function Trimm(x: string): string; { entfernt f�hrenden und abschlie�enden Leer-
  raum (Zeichen in Space) aus x und gibt die so ver�nderte Zeichenkette zur�ck }

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
