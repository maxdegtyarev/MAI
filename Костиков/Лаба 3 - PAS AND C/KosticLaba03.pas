program KosticLaba03;

const
  STACK_SIZE = 30;
  UsingNums: set of char = ['0'..'9'];
  UsingOperators: set of char = ['+', '-', '*', '/', '^', '%'];
type
  Stack = ^Node;

  Node = record
    Data: array[1..STACK_SIZE] of integer;
    S: integer;
  end;

  Stack_C = ^Node_C;

  Node_C = record
    Data: array[1..STACK_SIZE] of char;
    S: integer;
  end;

var
  Head: Stack;
  Head_C: Stack_C;
  fIn, fout: Text;
  InStr, BUFF: string;
  Sym: char;
  E: integer;
  mm: BOOLEAN;
  procedure AddToStack(var H: Stack; Data: integer);
  begin
    //Если стек только начали использзовать
    //Добавляем в стек
    H^.S := H^.S + 1;
    H^.Data[H^.S] := Data;
  end;

  function Gorner(NUM: string): integer;
  var
    BASE, REZ, K: integer;
  begin
    BASE := 10;
    rez := 0;
    K := 1;
    while K <= length(NUM) do
    begin
      if NUM[K] in UsingNums then
      begin
        REZ := REZ * BASE + (Ord(NUM[K]) - Ord('0'));
      end
      else
      begin
        REZ := REZ * BASE + (Ord(NUM[K]) - Ord('0') + Ord('A'));
      end;
      Inc(K);
    end;
    Result := REZ;
  end;

  function Antigorner(NUM: integer): string;
  var
    RS: string;
    Base: integer;
  begin
    Base := 10;
    rs := '';
    while NUM <> 0 do
    begin
      if NUM mod Base <= 9 then
      begin
        RS := chr(NUM mod Base + Ord('0')) + RS;
      end;
      NUM := NUM div BASE;
    end;
    Result := RS;
  end;

  function GetPriority(operators: char): integer;
  begin
    case operators of
      '+', '-': Result := 1;
      '*', '/', '%': Result := 2;
      '^': Result := 3;
      '(', ')': Result := 0;
    end;
  end;

  procedure char_AddToStack(var H: Stack_C; Data: char);
  begin
    //Если стек только начали использзовать
    //Добавляем в стек
    H^.S := H^.S + 1;
    H^.Data[H^.S] := Data;
  end;

  function GetElementFromStack(var H: Stack): integer;
  var
    Rez: integer;
  begin
    if H^.S <= 0 then
      writeln('EMPTY');
    Rez := H^.Data[H^.S];
    H^.S := H^.S - 1;
    Result := Rez;
  end;

  function char_GetElementFromStack(var H: Stack_C): char;
  var
    Rez: char;
  begin
    if H^.S <= 0 then
      writeln('EMPTY');
    Rez := H^.Data[H^.S];
    H^.S := H^.S - 1;
    Result := Rez;
  end;

  procedure ErrorHandler(Kek: string);
  begin
    writeln('ERROR-> ', kek);
    readln;
    halt;

  end;

  function Stepen(A, B: integer): integer;
  begin
    if B = 0 then
      Result := 1;
    if B = 1 then
      Result := 1;
    if B < 0 then
    begin
      Result := 1;

    end
    else
    begin
      while B <> 0 do
      begin
        A := A * A;
        B := B - 1;
      end;
      Result := A;
    end;
  end;

  procedure Schet(var H: Stack; Operation: char);
  var
    x, y: integer;
  begin

    case Operation of
      '+':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        x := x + y;
        AddToStack(H, x);
      end;
      '-':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        x := y - x;
        AddToStack(h, x);
      end;
      '*':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        x := y * x;
        AddToStack(h, x);
      end;
      '/':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        if x = 0 then
          ErrorHandler('#1 DIVIDE ON ZIRO MOTHERFUCKER!!!');
        x := y div x;
        AddToStack(h, x);
      end;
      '^':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        x := Stepen(y, x);
        AddToStack(h, x);
      end;
      '%':
      begin
        x := GetElementFromStack(H);
        y := GetElementFromStack(H);
        x := y mod x;
        AddToStack(h, x);
      end;
    end;
  end;

  function char_stack_IsEmpty(var H: Stack_C): boolean;
  begin
    if H^.S <> 0 then
      Result := False
    else
      Result := True;
  end;

  {#Infix to postfix}
  function InfixToPostfix(input: string): string;
  var
    C, Z: integer;
    K, T, P: char;
    buff, postfix: string;

  begin
    input := input + ')';
    buff := '';
    C := 1;
    char_AddToStack(Head_C, '(');
    while not (char_stack_IsEmpty(Head_C)) do
    begin
      k := input[C];
      if (k = '(') then
      begin
        char_AddToStack(Head_C, '(');
      end //Если число
      else if (k in UsingNums) then
      begin
        while (k in UsingNums) do
        begin
          postfix := postfix + k;
          buff := buff + k;
          Inc(c);
          k := input[c];
        end;
        AddToStack(Head, Gorner(buff));
        buff := '';
        postfix := postfix + ' ';
        c := c - 1;
      end
      else if (k in UsingOperators) then
      begin
        T := K; //Select current in T;
        P := char_GetElementFromStack(Head_C);
        Z := GetPriority(T);
        while (Z <= GetPriority(P)) do
        begin
          postfix := postfix + P + ' ';
          Schet(Head, P);
          //Сразу считаем
          P := char_GetElementFromStack(Head_C);
        end;
        char_AddToStack(Head_C, P);
        char_AddToStack(Head_C, T);
        //End
      end
      else if (k = ')') then
      begin
        T := char_GetElementFromStack(Head_C);
        while (T <> '(') do
        begin
          postfix := postfix + T + ' ';
          Schet(Head, T);
          T := char_GetElementFromStack(Head_C);
        end;
        if (char_Stack_IsEmpty(Head_C)) then
          break;
      end;

      Inc(c);
    end;

    Result := postfix;
  end;

begin
  new(Head);
  new(Head_C);
  Head_C^.S := 0;
  Head^.S := 0;
  Assign(fIn, 'in.txt');
  Assign(fOut, 'out.txt');
  {$I-}
  reset(fIn);
  rewrite(fout);
  {$I+}
  mm:= false;
  if IORESULT <> 0 then errorhandler('File Error');

  while not(EOF(fIn)) do begin
     readln(fIn,inStr);
     for E:= 1 to Length(inStr) do begin
        Sym:= inStr[E];
        if Sym = ';' then begin
          MM:= TRUE;
            write(Fout, BUFF);
            write(Fout,' = ');
            write(Fout, InfixToPostfix(BUFF));
            write(Fout,' = ');
            write(Fout, Antigorner(GetElementFromStack(Head)));
            writeln(Fout);
            BUFF:= '';
        end
        else
        begin
           BUFF:= BUFF + Sym;
        end;
     end;
     IF mm = false then ErrorHandler('IDIOT');
  end;
  close(fin);
  close(fout);
  readln;
  //Начинаем решение задачи

end.
