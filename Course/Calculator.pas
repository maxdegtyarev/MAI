{
        2017, �����ॢ ���ᨬ.
        ��㯯�: �80-112�-17
        �������� ��몭������� �஡��
        �����: 1.0
}

program Calculator;

uses
  Math,
  crt,
  SysUtils;

{�᭮��� ����⠭��}
const
  UsingOperators: set of char = ['+', '-', '*', '/', '^'];
  UsingNums: set of char = ['0'..'9'];
  PI = 3.14159;


  {������ �������� ������: �⥪}
type
  Stack = ^Node;

  Node = record
    Data: real;
    Next: Stack;
  end;

var
  FD: real;
  InputCommand: string;
  InputString: string;
  Head: Stack;



  //�㭪樨 � ��楤���


  {��ࠡ��稪 �訡��}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('����������� ������!!! -> ' + TypeOfError);
    readln();
    halt(1);
  end;

  {�㭪�� �������஢���� ��ࠦ���� ���� x|y/z � ���筮� �᫮ ⨯� Real}
  function toR(input: string): real;
  var
    C: integer;
    R, T, F: real;
    K: boolean;
    L, G, B: string;
  begin

    C := 1;
    K := False;
    while C <= length(input) do
    begin
      if input[C] = '|' then
      begin
        K := True;
        Inc(C);
      end;
      if input[C] = '/' then
      begin
        T := StrToFloat(L);
        F := StrToFloat(G);
        Inc(C);

        while C <= length(input) do
        begin
          B := B + input[C];
          Inc(C);
        end;

        R := StrToFloat(B);
        if R = 0 then
          ErrorHandler('#1 : ����⪠ ������� �� ����. �஢���� �ଠ� �室���� ��ࠦ����');
        break;
      end;
      if not (K) then
      begin
        L := L + input[C];
      end
      else
      begin
        G := G + input[C];
      end;
      Inc(C);
    end;
    //����砥� १����
    F := F / R;
    T := T + F;
    Result := T;

  end;



  {######��������� �㭪樮���� �⥪�######}

  {#��楤�� ���������� � �⥪ (��� ������������ �����)}
  procedure AddToStack(var H: Stack; d: real);
  var
    Temp: Stack;
  begin
    new(Temp);
    Temp^.Data := d;
    Temp^.Next := H;
    H := Temp;

  end;

  {#��楤�� ���� ��� ����⮢ �⥪�}
  procedure PrintStack(var H: Stack);
  var
    HeadClone: Stack;
  begin
    HeadClone := H;
    while (HeadClone^.Next <> nil) do
    begin
      writeln(HeadClone^.Data);
      HeadClone := HeadClone^.Next;
    end;
  end;

  {#�㭪��, ����� �뤠�� ��� ����� �⥪�}
  function GetElementFromStack(var H: Stack): real;
  var
    R: real;
    Temp: Stack;
  begin
    if H^.Next <> nil then
    begin
      R := H^.Data;
      Temp := H;
      H := H^.Next;
      Dispose(Temp);
      Result := R;
    end
    else
    begin
      ErrorHandler('#2 �⥪ ���⮩!');
    end;
  end;

  {########����� �㭪樮���� �⥪�#########}

  {++++++++��砫� �㭪樮���� �������஢++++++++}

  {#�㭪��, ����� ����砥� �� ����䨪� ����筮� �᫮}
  function PostfixToReal(inval: string): real;
  var
    x, y: real;
    C: integer;
    TMP, BUFFER: string;
    Sym: char;
  begin
    TMP := inval + '$';
    C := 1;
    while (TMP[C] <> '$') do
    begin
      //��稭��� ��室 ��ப�
      Sym := TMP[C];
      if (Sym in UsingNums) then
      begin
        while ((Sym <> ' ') and (not (Sym in UsingOperators))) do
        begin
          BUFFER := BUFFER + Sym;
          Inc(C);
          Sym := TMP[C];
        end;
        AddToStack(Head, StrToFloat(BUFFER));
        BUFFER := '';
        C := C - 1;
      end
      else if (Sym in UsingOperators) then
      begin
        case Sym of
          '+':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := x + y;
            AddToStack(Head, x);
          end;
          '-':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            if (x > y) then
            begin
              x := x - y;
            end
            else
              x := y - x;
            AddToStack(Head, x);
          end;
          '*':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := x * y;
            AddToStack(Head, x);
          end;
          '/':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            if (y = 0) then
            begin
              ErrorHandler('����⪠ ������� �� ����');
            end;
            if (x > y) then
            begin
              x := x / y;
            end
            else
            begin
              x := y / x;
            end;
            AddToStack(Head, x);
          end;

        end;
      end;

      Inc(C);
    end;

  end;

  {+++++++++����� �㭪樮���� �������஢++++++++++}

  procedure DialogMenu();
  begin
    writeln('���� ���������� � �������� �஡��!');

    while True do
    begin
      writeln('');
      writeln('������ ����⢨�, ���஥ �� ��� ᮢ�����:');
      writeln('������ 1, �᫨ �� ��� ����� ��ࠦ���� � ���᮫�');
      writeln('2, �᫨ �� ��� ������ ��ࠦ���� ��� ������⢮ ��ࠦ���� �� 䠩��');
      writeln('3, ��� ������ �����, ��� �� ����� ������������ � �ᥬ �㭪樮����� ');
      writeln('4, �᫨ �� ��� ����� ��ࠦ���� � ��ࠬ��ࠬ�, ��⥬ ������ ��ࠬ���');
      writeln('5, �᫨ �� ��� ������� ��ࠦ���� � ����䨪᭮� �ଥ');
      writeln('0, ��� ��室� �� �ணࠬ��');
      Write('����:');
      readln(InputCommand);
      case InputCommand of
        '1':
        begin
          clrscr;
          writeln('');
          Write('������ ��⥬���᪮� ��ࠦ����: ');
          Read(InputString);
          writeln(toR(InputString));
          readln();
          readln();
          clrscr;
        end;
        '5':
        begin
          clrscr;
          writeln('');
          Write('������ ����䨪᭮� ��ࠦ����. ��᫠ ������ ��������� �१ �஡�� ');
          Read(InputString);
          writeln('�ᯥ譮 ����祭 �⢥�:');
          writeln('');
          writeln('� 楫�� �ଥ:');
          writeln(Round(PostfixToReal(InputString)));
          writeln('');
          writeln('� �஡��� �ଥ:');
          writeln(PostfixToReal(InputString));
          readln();
          readln();
          clrscr;
        end;
        '0':
          halt(0);
        else
          writeln('�����४�� ����!');
      end;
    end;
  end;

begin
  //���樠������ �⥪��
  new(Head);
  Head^.Next := nil;
  DialogMenu();
end.
