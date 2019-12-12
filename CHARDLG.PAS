unit CharDlg;


interface

uses Dialogs, Drivers, Objects;

type

  PLongintDisplay = ^TLongintDisplay;
  TLongintDisplay = object(TParamText)
    constructor Init(var R: TRect; AText: string);
    procedure SetValue(AValue: Longint);
  private
    Value: Longint;
  end;

  PCharacterDialog = ^TCharacterDialog;
  TCharacterDialog = object(TDialog)
    constructor Init;
    destructor Done; virtual;
    function DataSize: Word; virtual;
    procedure GetData(var Rec); virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure SetData(var Rec); virtual;
  private
    CodeDisplay: PLongintDisplay;
    SelCharEditor: PInputLine;
    ListBox: PListBox;
  end;


implementation

uses Global, MsgBox, Views;

type
  PCharacterCollection = ^TCharacterCollection;
  TCharacterCollection = object(TCollection)
    constructor Init;
    procedure FreeItem(Item: Pointer); virtual;
    function GetText(Item: Integer): string;
  end;

constructor TCharacterCollection.Init;
var
  i: Integer;
begin
  inherited Init(256, 0);
  for i := 0 to 255 do begin
    Insert(NewStr(Chr(i)))
  end
end;

procedure TCharacterCollection.FreeItem(Item: Pointer);
begin
  if Item <> nil then DisposeStr(Item);
end;

function TCharacterCollection.GetText(Item: Integer): string;
var
  P: PString;
begin
  P := At(Item);
  if P = nil then GetText := ''
  else GetText := P^
end;

constructor TLongintDisplay.Init(var R: TRect; AText: string);
begin
  inherited Init(R, AText, 1);
  ParamList := @Value
end;

procedure TLongintDisplay.SetValue(AValue: Longint);
begin
  if Value <> AValue then begin
    Value := AValue;
    Draw
  end;
end;


{ TCharacterDialog }

constructor TCharacterDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 75, 20);
  inherited Init(R, 'Special Characters');
  Options := Options or ofCentered;
  HelpCtx := hcCharTable;
  R.Assign(2, 2, 65, 18);
  New(ListBox, Init(R, 16, nil));
  ListBox^.NewList(New(PCharacterCollection, Init));
  Insert(ListBox);
  R.Assign(2, 1, 65, 2);
  Insert(New(PStaticText, Init(R, ' 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F')));
  R.Assign(1, 2, 2, 18);
  Insert(New(PStaticText, Init(R, '0123456789ABCDEF')));
  R.Assign(1, 18, 4, 19);
  New(CodeDisplay, Init(R, '%3d'));
  CodeDisplay^.Value := ListBox^.Focused;
  Insert(CodeDisplay);
  R.Assign(4, 18, 65, 19);
  New(SelCharEditor, Init(R, 255));
  Insert(SelCharEditor);
  R.Assign(65, 5, 74, 7);
  Insert(New(PButton, Init(R, 'O~K~', cmOK, bfDefault)));
  R.Assign(65, 7, 74, 9);
  Insert(New(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)))
end;

destructor TCharacterDialog.Done;
begin
  if ListBox <> nil then ListBox^.NewList(ListBox^.List);
  inherited Done
end;

function TCharacterDialog.DataSize: Word;
begin
  DataSize := SelCharEditor^.DataSize
end;

procedure TCharacterDialog.GetData(var Rec);
begin
  SelCharEditor^.GetData(Rec);
end;

procedure TCharacterDialog.HandleEvent(var Event: TEvent);
var
  S, Sel: string;
begin
  inherited HandleEvent(Event);
  if Event.What and evBroadcast <> 0 then
    case Event.Command of
      cmListItemSelected: begin
          CodeDisplay^.SetValue(ListBox^.Focused);
          if ListBox^.List <> nil then begin
            Sel := PCharacterCollection(ListBox^.List)^.GetText(ListBox^.Focused);
            if Sel <> '' then begin
              SelCharEditor^.GetData(S);
              S := S + Sel;
              SelCharEditor^.SetData(S);
            end;
          end;
          ClearEvent(Event)
        end;
    end;
end;

procedure TCharacterDialog.SetData(var Rec);
begin
  SelCharEditor^.SetData(Rec)
end;

end.