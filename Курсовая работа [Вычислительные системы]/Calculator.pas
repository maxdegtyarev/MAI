{
        2017, �����ॢ ���ᨬ.
        ��㯯�: �80-112�-17
        �������� ��몭������� �஡��
        �����: 1.1
}

program Calculator;

uses
  Math,
  crt,
  SysUtils;

{�᭮��� ����⠭��}
const
  UsingOperators: set of char =
    ['+', '-', '*', '/', '^', '!', 's', 'c', 't', 'g', 'l', 'q', 'm'];

  UsingNums: set of char = ['0'..'9', '.', ','];
  UsingNumsF: set of char = ['0'..'9', '.', ','];
  Nums: set of char = ['0'..'9', '.', '(', ',', ')', '+', '-', '*',
    '/', '^', '!', 's', 'c', 't', 'g', 'l', 'q', ' ','m'];
  FUNCTIONS = 9;


  {������ �������� ������: �⥪}
type
  Stack = ^Node;

  Node = record
    Data: real;
    Next: Stack;
  end;
  C_Stack = ^Nodec;

  Nodec = record
    Data: char;
    Next: C_stack;
  end;


var
  InputCommand, InputString: string;
  Head: Stack;
  Head_C: C_Stack;
  InputFile, OutFile: Text;
  Functions_IN: array[1..FUNCTIONS] of string;
  Functions_OUT: array[1..FUNCTIONS] of string;
  MemoryR, Cache: real;
  MemoryI: integer;
  Smem, Smemi, MemC: string;
  MemO: char;

  {#######��������� �㭪樨#############}

  {��ࠡ��稪 �訡��}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('����������� ������!!! -> ' + TypeOfError);
    readln;
    readln;
    halt(1);
  end;

  procedure ErrorDialog(TypeOfError: string);
  var
    tf: string;
    k: integer;
  begin
    tf := '                                                ';
    k := 1;
    while k <= length(TypeOfError) do
    begin
      tf[k] := TypeOfError[k];
      Inc(k);
    end;
    clrscr;
    writeln('�����������������������������������������������������������������������������Ŀ');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                     �訡��! ' + tf + '�');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    writeln('�������������������������������������������������������������������������������');
    writeln;
    writeln('������� ENTER ��� �����������');
    readln;
  end;

  function Factorial(input: real): real;
  var
    R, Rez: integer;
    T: integer;
  begin
    R := 1;
    Rez := 1;
    T := Round(input);
    if T = 0 then
      Result := 0;
    while (R <= T) do
    begin
      Rez := Rez * R;
      Inc(R);
    end;
    Result := Rez;
  end;

  {�㭪�� �뤠� �ਮ��⮢}
  function GetPriority(operators: char): integer;
  begin
    case operators of
      '+', '-': Result := 1;
      '*', '/': Result := 2;
      '^': Result := 3;
      '(', ')': Result := 0; //������ � ���� ���� �� ���� ��� ��������� �����
    end;
  end;

  {#######����� ���������� �㭪権##########}



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

  {#��楤�� ���������� � �⥪ (��� ��������)}
  procedure char_AddToStack(var H: c_stack; Data: char);
  var
    Temp: C_Stack;
  begin
    new(Temp);
    Temp^.Data := Data;
    Temp^.Next := H;
    H := Temp;
  end;

  {#�㭪��, ����� �뤠�� ��� ������� �⥪�}
  function GetElementFromStack(var H: Stack): real;
  var
    R: real;
    Temp: Stack;
  begin
    if H <> nil then
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

  {#�㭪��, ����� �뤠� ��� ������� �஢᪮�� �⥪�}
  function char_GetElementFromStack(var H: c_stack): char;
  var
    Temp: C_stack;
    c: char;
  begin
    if H <> nil then
    begin
      Temp := H;
      H := H^.Next;
      c := Temp^.Data;
      dispose(Temp);
      Result := c;
    end
    else
    begin
      ErrorHandler('#3 �⥪ ᨬ����� ���⮩');
    end;
  end;

  {#�㭪��, ����� �஢���� ������ ᨬ���쭮�� �⥪�}
  function char_Stack_IsEmpty(var H: c_stack): boolean;
  begin
    if H^.Next = nil then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  {########����� �㭪樮���� �⥪�#########}

  {++++++++��砫� �㭪樮���� �������஢++++++++}

  {#�㭪��, ����� ����砥� �� ����䨪� ����筮� �᫮}
  function PostFixToReal(inval: string): real;
  var
    x, y: real;
    C: integer;
    TMP, BUFFER: string;
    Sym: char;
  begin
    TMP := inval + '�';

    C := 1;
    while (TMP[C] <> '�') do
    begin
      //��稭��� ��室 ��ப�
      Sym := TMP[C];
      if (Sym in UsingNums) then
      begin
        while ((Sym <> ' ') and (not (Sym in UsingOperators))) do
        begin
          if (Sym = '.') then
            Sym := ',';
          BUFFER := BUFFER + Sym;
          Inc(C);
          Sym := TMP[C];
        end;

        //�᫨ ��ࠦ���� ��諮 �஢��� �� ���४⭮���, � ������ �� ����室��� ����⢨�
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
            if (x = 0) then
            begin
              ErrorDialog('#4 ����⪠ ������� �� ����');
            end
            else
            begin
              x := y / x;
              AddToStack(Head, x);
            end;
          end;
          '^':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := Power(y, x);
            AddToStack(Head, x);
          end;
          '!':
          begin
            x := GetElementFromStack(Head);
            x := Factorial(x);
            AddToStack(Head, x);
          end;
          's':
          begin
            x := GetElementFromStack(Head);
            x := sin(x);
            AddToStack(Head, x);
          end;
          'c':
          begin
            x := GetElementFromStack(Head);
            x := cos(x);
            AddToStack(Head, x);
          end;
          't':
          begin
            x := GetElementFromStack(Head);
            x := tan(x);
            AddToStack(Head, x);
          end;
          'g':
          begin
            x := GetElementFromStack(Head);
            if round(sin(x)) = 0 then
              ErrorHandler('#5 ����⪠ ������� �� ����');

            x := (cos(x) / sin(x));
            AddToStack(Head, x);
          end;
          'l':
          begin
            x := GetElementFromStack(Head);
            x := ln(x);
            AddToStack(Head, x);
          end;
          'q':
          begin
            x := GetElementFromStack(Head);
            if x < 0 then ErrorHandler('Can not make SQRT < 0');
            x := sqrt(x);
            AddToStack(Head, x);
          end;
          'm':
          begin
            x := GetElementFromStack(Head);
            x := 0 - x;
            AddToStack(Head, x);
          end;
        end;
      end;

      Inc(C);
    end;

  end;

  {#�㭪�� �������஢���� ��䨪� � ����䨪�}
  function InfixToPostfix(input: string): string;
  var
    C, Z: integer;
    K, T, P: char;
    postfix: string;
    dp: string;
  begin
    dp := '1';
    input := input + ')';
    C := 1;
    char_AddToStack(Head_C, '(');
    while not (char_stack_IsEmpty(Head_C)) do
    begin
      k := input[C];
      if (k = '(') then
      begin
        char_AddToStack(Head_C, '(');
      end
      else if (k in UsingNums) then
      begin
        while (k in UsingNums) do
        begin
          if ((k = ',') or (k = '.')) then
          begin
            postfix := postfix + ',';
          end
          else
          begin
            postfix := postfix + k;
          end;
          Inc(c);
          k := input[c];
        end;
        postfix := postfix + ' ';
        c := c - 1;
        dp := '1';
      end
      else if (k in UsingOperators) then
      begin
        T := K; //���� ⥪�騩 ᨬ��� � T;
        P := char_GetElementFromStack(Head_C);
        Z := GetPriority(T);
        while (Z <= GetPriority(P)) do
        begin
          postfix := postfix + P + ' ';
          P := char_GetElementFromStack(Head_C);
        end;
        char_AddToStack(Head_C, P);
        char_AddToStack(Head_C, T);
        //������, ��� �����稫�
      end
      else if (k = ')') then
      begin
        T := char_GetElementFromStack(Head_C);
        while (T <> '(') do
        begin
          postfix := postfix + T + ' ';
          T := char_GetElementFromStack(Head_C);
        end;
        if (char_Stack_IsEmpty(Head_C)) then
          break;
      end;

      Inc(c);
    end;

    Result := postfix;
  end;

  procedure CheckIn(input: string);
  var
    Pc, Cr, Cc, Lns, Punk: integer;

  begin

    Cr := 1;
    Punk := 0;
    Cc := 0;
    while (Cr <= Length(input)) do
    begin
      if input[Cr] = '(' then
        Inc(Cc);
      if input[Cr] = ')' then
        Dec(Cc);
      if not (input[Cr] in Nums) then
        ErrorHandler('#8 �����४⭮� ��ࠦ����!!!');
      if input[Cr] in UsingNums then
      begin
        Inc(Cr);
        while (input[Cr] <> ' ') and not (input[Cr] in UsingOperators) and
          (Cr <= Length(input)) and (input[cr] <> ')') do
        begin
          if (input[Cr] = '.') or (input[Cr] = ',') then
            Inc(Punk);

          Inc(Cr);
          Inc(Lns);
        end;
        if (Punk > 1) or (Lns > 32) then
          ErrorHandler('#6 �����४⭮� ��ࠦ����!!!');
        Punk := 0;
        Lns := 0;
        Cr := Cr - 1;
      end;
      Inc(Cr);
    end;
    if Punk + Cc <> 0 then
      ErrorHandler('#7 �����४⭮� ��ࠦ����!!!');
  end;

  function Preprocessor(input: string): string;
  var
    s: string;
    i, k: integer;

  begin
    k := 1;
    s := input;
    while k <= FUNCTIONS do
    begin
      while (pos(Functions_IN[k], s) <> 0) do
      begin
        i := pos(Functions_IN[k], s);
        Delete(s, i, length(Functions_IN[k]));
        insert(Functions_OUT[k], s, i);
      end;
      Inc(k);
    end;
    Result := s;

  end;

  procedure Help;
  begin
    clrscr;
    writeln;
    writeln('�����������������������������������������������������������������������������Ŀ');
    writeln('�                                                                             �');
    writeln('�    ���� ���������� � �ணࠬ�� ����� ���짮��⥫�!                       �');
    writeln('�                                                                             �');
    writeln('�    ������ run ��� ����祭�� ������樨                                    �');
    writeln('�                                                                             �');
    writeln('�    ������ 0 ��� ��室� �� �ணࠬ�� ����� ���짮��⥫�!                  �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    Write('�->����:     ');
    Readln(InputString);
    writeln('�������������������������������������������������������������������������������');
    case InputString of
      '0': exit;
      'run':
      begin
        writeln('�����������������������������������������������������������������������������Ŀ');
        writeln('�                                                                             �');
        writeln('�    � ������� ����� �ᯮ�짮���� ᫥���騥 �᫠, ����樨, �㭪樨:       �');
        writeln('�    + ���� �᫠, �.� -1000, 54, 979 � �.�                                  �');
        writeln('�    + ��樮����� �᫠, �.� 259.7, 25.8                                    �');
        writeln('�    + ��몭������ �஡�, �.� � �ணࠬ�� �������� ��� 6|8/10 ��� 21/77      �');
        writeln('�    + ������, �.� ���뢠�騥 � ����뢠�騥 ᪮��� ( )                       �');
        writeln('�    + ����⠭��, �.� �᫮ �� �������� ��� p, � �᫮ � �������� ��� e       �');
        writeln('�    + �������, �.�                                                         �');
        writeln('�    + ������ ᫮�����: +                                                   �');
        writeln('�    + ������ ���⠭��: -                                                  �');
        writeln('�    + ������ 㬭������: *                                                  �');
        writeln('�    + ������ �������: /                                                    �');
        writeln('�    + ������ ���������� � �⥯���: ^                                       �');
        writeln('�    + ������ ����祭�� 䠪�ਠ�� �᫠: !                                 �');
        writeln('�    + �ਣ��������᪨� �㭪樨, �� �⮬ �� ��㬥��� ������ ���� � rad   �');
        writeln('�    + �����: sin()                                                           �');
        writeln('�    + ��ᨭ��: cos()                                                         �');
        writeln('�    + �������: tg()                                                          �');
        writeln('�    + ��⠭����: ctg()                                                       �');
        writeln('�    + �㭪�� ���᪨����� �᫠ �� ��� ����� ����, �.� sqrt()              �');
        writeln('�    + ������ ����⥫쭮�� �᫠ ��稭����� � ᨬ���� "m"                   �');
        writeln('�                                                                             �');
        writeln('�������������������������������������������������������������������������������');
        readln;
      end;
      else
        ErrorDialog('�訡��! ������� ����୮� ���祭��!');
    end;
  end;

  procedure WorkWithFile;
  begin
    clrscr;
    writeln;
    writeln('�����������������������������������������������������������������������������Ŀ');
    writeln('�                                                                             �');
    writeln('�    ������ ���� � 䠩��, ����� ᮤ�ন� ����ᠭ�� ��ࠦ����              �');
    writeln('�                                                                             �');
    writeln('�    ���ਬ��: file.txt                                                       �');
    writeln('�                                                                             �');
    writeln('�    ��ଠ� 䠩�� ������ ���� ᫥���騩:  ����� ��ࠦ����_1                   �');
    writeln('�                                         ����� ��ࠦ����_2                   �');
    writeln('�                                         ...                                 �');
    writeln('�                                         ����� ��ࠦ����_n                   �');
    writeln('�                                                                             �');
    writeln('�                                                                             �');
    Write('�->����:     ');
    Readln(InputString);
    writeln('�������������������������������������������������������������������������������');

    //Associate
    Assign(InputFile, InputString);
    Assign(OutFile, InputString + '_RESULT.txt');
    {$I-}
    reset(InputFile);
    rewrite(OutFile);
    {$I+}

    if IOresult <> 0 then
    begin
      ErrorDialog('�ந��諠 �訡�� �� ࠡ�� � 䠩����');
      readln();
      exit;
    end;

    writeln;
    writeln('�����������������������������������������������������������������������������Ŀ');
    writeln('�                         �������� ����� �� 䠩��                           �');
    writeln('�                                                                             �');

    while (not (EOF(InputFile))) do
    begin
      readln(InputFile, InputString);
      CheckIn(Preprocessor(InputString));
      MemoryR := Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring)));
      MemoryI := Round(Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring))));
      Write('�-> ����� �ଠ: ');
      Write(MemoryI);
      Write('  ����⢥���� �ଠ:');
      Write(MemoryR);
      str(MemoryR, smem);
      str(MemoryI, smemi);
      writeln(OutFile, InputString + ' = ' + smem + ' = ' + smemi);
      smem := '';
      smemi := '';
      writeln;
    end;
    writeln('�                                                                             �');
    writeln('�                         �������� ����ᠭ� � 䠩� _RESULT.txt              �');
    writeln('�������������������������������������������������������������������������������');

    Close(InputFile);
    Close(OutFile);
    readln();
  end;

  procedure DialogMenu;

  begin
    Postfixtoreal(Infixtopostfix('1'));
    writeln('��������������������������������������������������������������������������������');
    writeln('����� ���������� � �������� �஡��!');
    while True do
    begin
      clrscr;
      writeln('�����������������������������������������������������������������������������Ŀ');
      writeln('�                                                                             �');
      writeln('������� ����⢨�, ���஥ �� ��� ᮢ�����:                               �');
      writeln('�                                                                             �');
      writeln('�  ������:                                                                   �');
      writeln('�                                                                             �');
      writeln('� ~ 1, �᫨ �� ��� ����� ��ࠦ���� � ���᮫�                              �');
      writeln('�                                                                             �');
      writeln('� ~ 2, �᫨ �� ��� ������ ��ࠦ���� ��� ������⢮ ��ࠦ���� �� 䠩��    �');
      writeln('�                                                                             �');
      writeln('� ~ 3, �᫨ ��� �㦭� ������                                                  �');
      writeln('�                                                                             �');
      writeln('�                                                                             �');
      writeln('� ~ 0, ��� ��室� �� �ணࠬ��                                                �');
      writeln('�                                                                             �');
      writeln('�                                                                             �');
      writeln('�                                                                             �');
      writeln('�                                                                             �');
      writeln('�                                                   (c) 2017, �����ॢ ���ᨬ �');
      writeln('�������������������������������������������������������������������������������');
      Write('�-> ����:  ');
      readln(InputCommand);
      case InputCommand of
        '1':
        begin
          clrscr;
          writeln;
          writeln('�����������������������������������������������������������������������������Ŀ');
          writeln('�                                                                             �');
          writeln('�    ������ ��⥬���᪮� ��ࠦ����. ��᫠ ������ ��������� �१ �஡��    �');
          writeln('�                                                                             �');
          writeln('�    ���ਬ��: (5+2)/2-4*3                                                    �');
          writeln('�    �᫨ �� ��� ������� ����⥫쭮� �᫮, ���� -16, � ����� m16     �');
          writeln('�    ��ᯮ������ ᫥���饩 �������                                         �');
          writeln('�    ��� 㤮��⢠ ���⠩� ������ �������� � ��ᯫ��樨 �ணࠬ��        �');
          writeln('�    �� �ᯮ���� ��ࠦ����, ����� �� 㬥����� � Double,�த� 5000000^99 �');
          writeln('�                                                                             �');
          Write('�->����:     ');
          Read(InputString);
          CheckIn(Preprocessor(InputString));
          ReadLN(MemC);
          writeln('�������������������������������������������������������������������������������');
          writeln('�����������������������������������������������������������������������������Ŀ');
          writeln(
            '�                            �ᯥ譮 ����祭 �⢥�:                           �');
          writeln(
            '�                                                                             �');
          writeln(
            '�                                                                             �');
          writeln(
            '�� 楫�� �ଥ (c ���㣫����� �� 楫��):                                      �');
          Write('�>>>  ');
          MemoryR := Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring)));


          //�᫨
          case memO of
            '+': MemoryR := MemoryR + cache;
            '-': MemoryR := cache - MemoryR;
            '*': MemoryR := MemoryR * cache;
            '/': MemoryR := cache / MemoryR;
          end;

          //���㣫塞
          MemoryI := Round(MemoryR);

          writeln(MemoryI);
          writeln('�                                                                             �');
          writeln('�� ����⢥���� �ଥ:                                                        �');
          writeln(
            '�                                                                             �');
          Write('�>>>  ');
          writeln(MemoryR: 0: 2);


          readln();
          clrscr;
        end;
        '2': WorkWithFile;
        '3': Help;
        '0':
          halt(-1);
        else
          ErrorDialog('������� �����४⭮� ���祭��!');
      end;
    end;
  end;



begin
  //���樠������ �⥪��
  Head_C := nil;
  Head := nil;

  //�४���������騥 �㭪樨
  Functions_IN[1] := 'sin';
  Functions_IN[2] := 'cos';
  Functions_IN[3] := 'tg';
  Functions_IN[4] := 'ctg';
  Functions_IN[5] := 'ln';
  Functions_IN[6] := 'p';
  Functions_IN[7] := 'e';
  Functions_IN[8] := '|';
  Functions_IN[9] := 'sqrt';
  Functions_OUT[1] := 's';
  Functions_OUT[2] := 'c';
  Functions_OUT[3] := 't';
  Functions_OUT[4] := 'g';
  Functions_OUT[5] := 'l';
  Functions_OUT[6] := '314159265358/100000000000';
  Functions_OUT[7] := '271828182845/100000000000';
  Functions_OUT[8] := '+';
  Functions_OUT[9] := 'q';
  //��뢠�� ���������� ����
  DialogMenu();
end.
