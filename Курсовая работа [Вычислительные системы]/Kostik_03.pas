program Kostik_03;


  const
  UsingOperators: set of char = ['+', '-', '*', '/', '^'];
  UsingNums: set of char = ['0'..'9', '.', ','];


var
  InputString: string;
  Mass: array[1..100] of char;
  MassI: integer;
  Fin: text;
  stri: string;
  procedure AddToStack(var I: integer; Data: char);
  begin
    Inc(I);
    Mass[I] := Data;
  end;

  {Функция выдачи приоритетов}
  function GetPriority(operators: char): integer;
  begin
    case operators of
      '+', '-': Result := 1;
      '*', '/': Result := 2;
      '^': Result := 3;
      '(', ')': Result := 0; //Скобки и иной мусор не даст нам двигаться дальше
    end;
  end;

  function GetFromStack(var I: integer): char;
  var
    temp: char;
  begin
    if I = 0 then
    begin
      writeln('Stack is empty');
      halt(-1);
    end;

    temp := Mass[I];
    Mass[I] := ' ';
    Dec(I);
    Result := temp;
  end;
  function IsEmpty(var I: integer): boolean;
  begin
       if I <> 0 then result:= false;
       if I = 0 then result:= true;
  end;
  function InfixToPostfix(input: string): string;
  var
    C, Z: integer;
    K, T, P: char;
    postfix: string;
    usedpoint: boolean;
  begin
    delete(input, length(input), 1);
    usedpoint := False;
    input := input + ')';
    C := 1;
    AddToStack(MassI, '(');
    while not (IsEmpty(MassI)) do
    begin
      k := input[C];
      if (k = '(') then
      begin
        AddToStack(MassI, '(');
      end
      else if (k in UsingNums) then
      begin
        while (k in UsingNums) do
        begin
          if (((k = ',') or (k = '.')) and (usedpoint <> True)) then
          begin
            if (postfix[c - 1] in UsingNums) and (input[c + 1] in UsingNums) then
            begin
              postfix := postfix + k;
              usedpoint := True;
            end;
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
        usedpoint := False;
      end
      else if (k in UsingOperators) then
      begin
        T := K; //Берём текущий символ в T;
        P := GetFromStack(MassI);
        Z := GetPriority(T);
        while (Z <= GetPriority(P)) do
        begin
          postfix := postfix + P + ' ';
          P := GetFromStack(MassI);
        end;
        AddToStack(MassI, P);
        AddToStack(MassI, T);
        //Пожалуй, тут закончили
      end
      else if (k = ')') then
      begin
        T := GetFromStack(MassI);
        while (T <> '(') do
        begin
          postfix := postfix + T + ' ';
          T := GetFromStack(MassI);
        end;
        if (isempty(MassI)) then
          break;
      end;

      Inc(c);
    end;

    Result := postfix;
  end;


begin
  MassI := 0;
  Assign(Fin, 'input.txt');
  {$I-}
       reset(Fin);
  {$I+}
  if IORESULT <> 0 then begin
      writeln('File not found!');
  end;

  while not(EOF(Fin)) do begin
     readln(Fin, stri);

  end;
  readln;
end.
