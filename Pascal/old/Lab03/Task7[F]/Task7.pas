{
 Задача 7
}
program Task7;

uses
  crt;

type
  Matrix = array[1..100, 1..100] of integer;
  Matrix2 = array[1..100, 1..100] of integer;
  RezMatrix = array[1..100, 1..100] of integer;
  CS = set of char;
var
  Q: Matrix;
  Q2: Matrix2;
  RQ: RezMatrix;
  K, i, j, z, l, p, Mode, Modes, n, m, e: integer; //1 - e, 2- r, 3 - f
  R: integer;
  S, S2: string;
  InputFile: Text;
  GA, UseOutFile: boolean;
  Author, About, Group: string;
  Commands: CS;
begin
  GA := False;
  UseOutFile := False;
  Author := 'Maxim Degtyarev';
  About := 'Task 7';
  Group := 'M80-112B-17';

  if paramcount <> 0 then
  begin
    for i := 1 to ParamCount do
    begin
      case ParamStr(i) of
        '-h': Include(Commands, 'h');
        '-i': Include(Commands, 'i');
        '-g': Include(Commands, 'g');
        '-c': Include(Commands, 'c');
        '-e': Include(Commands, 'e');
        '-r': Include(Commands, 'r');
        '-f':
        begin
          Include(Commands, 'f');
          S := ParamStr(ParamCount - 1);
          S2 := ParamStr(ParamCount);
        end;
        '-o': Include(Commands, 'o');
      end;
    end;
  end;

  //Быстро прогоняем по основным командам
  if 'c' in Commands then
    clrscr;
  if 'h' in Commands then
    writeln(About);
  if 'i' in Commands then
    writeln(Author);
  if 'g' in Commands then
    writeln(Group);
  if 'o' in Commands then
    UseOutFile := True;


  if (('e' in commands) and ('f' in commands)) or
    (('e' in commands) and ('r' in commands)) or
    (('f' in commands) and ('r' in commands)) then
  begin
    writeln('Too many modes!');
    readln;
    halt(-1);
  end
  else if not ('e' in commands) and not ('f' in commands) and not ('r' in commands) then
  begin
    writeln('You have not entered modes. Please enter -e or -r or -f');
    readln(S);
    case S of
      '-e':
      begin
        Include(Commands, 'e');
      end;
      '-r':
      begin
        Include(Commands, 'r');
      end;
      '-f':
      begin
        Include(Commands, 'f');
        writeln('Enter your file:');
        readln(S);
        writeln('Enter your file 2');
        readln(S2);
      end;
      else
      begin
        writeln('##Idiot!');
        halt(-1);
      end;
    end;
  end;

  //Теперь разбираемся с модами


  if 'e' in Commands then //Если хочет ввести данные вручную
  begin
    z := 1;
    while (z <> 0) do
    begin
      readln(S);
      val(S, n, z);
      readln(S);
      val(S, m, z);
      readln(S);
      val(S, e, z);
      if (z <> 0) or (n < 0) or (m < 0) or (e < 0) or (n > 100) or
        (m > 100) or (e > 100) then
        writeln('Not correct!');
    end;
    writeln('Enter input data for matrix 1');
    for i := 1 to n do
    begin
      for j := 1 to m do
      begin
        z := 1;
        while (z <> 0) do
        begin
          readln(S);
          val(S, K, z);
          if z <> 0 then
            writeln('Not correct!');
        end;
        Q[i, j] := K;
      end;
    end;

    writeln('Enter input data for matrix 2');
    for i := 1 to m do
    begin
      for j := 1 to e do
      begin
        z := 1;
        while (z <> 0) do
        begin
          readln(S);
          val(S, K, z);
          if z <> 0 then
            writeln('Not correct!');
        end;
        Q2[i, j] := K;
      end;
    end;
  end;
  if 'r' in Commands then//Если хочет ввести данные рандомно
  begin
    randomize;
    n := 1 + random(10);
    m := 1 + random(10);
    e := 1 + random(10);
    for i := 1 to n do
    begin
      for j := 1 to m do
      begin
        Q[i, j] := random(10);
      end;
    end;
    for i := 1 to m do
    begin
      for j := 1 to e do
      begin
        Q2[i, j] := random(10);
      end;
    end;
  end;
  if 'f' in Commands then //Если хочет ввести данные из файла
  begin
    z := 1;
    while (z <> 0) do
    begin
      readln(S);
      val(S, n, z);
      readln(S);
      val(S, m, z);
      readln(S);
      val(S, e, z);
      if (z <> 0) or (n < 0) or (m < 0) or (e < 0) or (n > 100) or
        (m > 100) or (e > 100) then
        writeln('Not correct!');
    end;
    writeln('Oppening file ' + S);
    Assign(InputFile, S);
      {$I-}
    reset(InputFile);
      {$I+}
    if IORESULT <> 0 then
    begin
      writeln('File not Found!');
      halt;
    end;

    for i := 1 to n do
    begin
      for j := 1 to m do
      begin
        Read(InputFile, Q[i, j]);
      end;
    end;
    Close(InputFile);

    writeln('Oppening file2 ' + S2);
    Assign(InputFile, S2);
            {$I-}
    reset(InputFile);
            {$I+}
    if IORESULT <> 0 then
    begin
      writeln('File not Found!');
      halt;
    end;

    for i := 1 to m do
    begin
      for j := 1 to e do
      begin
        Read(InputFile, Q2[i, j]);
      end;
    end;

    Close(InputFile);
  end;


  if UseOutFile then
  begin
    Assign(InputFile, 'out.txt');
  {$I-}
    rewrite(InputFile);
  {$I+}
    if IORESULT <> 0 then
      writeln('Errro');
  end;

  writeln('Matrix 1');
  for i := 1 to n do
  begin
    for j := 1 to m do
    begin
      if UseOutFile then
      begin
        Write(InputFile, Q[i, j]);
        Write(InputFile, ' ');
      end
      else
      begin
        Write(Q[i, j]);
        Write(' ');
      end;

    end;
    if UseOutFile then
    begin
      Writeln(InputFile, ' ');
    end
    else
      Writeln;
  end;
  if UseOutFile then
  begin
    WriteLn(InputFile, ' ');
  end;
  writeln('Matrix 2');
  for i := 1 to m do
  begin
    for j := 1 to e do
    begin
      if UseOutFile then
      begin
        Write(InputFile, Q2[i, j]);
        Write(InputFile, ' ');
      end
      else
      begin
        Write(Q2[i, j]);
        Write(' ');
      end;

    end;
    if UseOutFile then
    begin
      Writeln(InputFile, ' ');
    end
    else
      Writeln;
  end;

  //1 шаг - осуществляем расчёт произведения матриц

  for i := 1 to n do
  begin
    for j := 1 to e do
    begin
      for p := 1 to m do
      begin
        RQ[i, j] := RQ[i, j] + Q[i, p] * Q2[p, j];
      end;
    end;
  end;
  if UseOutFile then
  begin
    WriteLn(InputFile, ' ');
  end;
  writeln('M1*M2 = ');
  for i := 1 to n do
  begin
    for j := 1 to e do
    begin
      if UseOutFile then
      begin
        Write(InputFile, RQ[i, j]);
        Write(InputFile, ' ');
      end
      else
      begin
        Write(RQ[i, j]);
        Write(' ');
      end;

    end;
    if UseOutFile then
    begin
      Writeln(InputFile, ' ');
    end
    else
      Writeln;
  end;
  if UseOutFile then
  begin
    WriteLn(InputFile, ' ');
  end;
  //2 шаг - сортировка результатов
  writeln('Sorting matrix');
  for i := 1 to n do
  begin
    //Если строка чётная
    if i mod 2 = 0 then
    begin
      for p := 1 to e do
      begin
        for l := 1 to e - 1 do
        begin
          if RQ[i, l] > RQ[i, l + 1] then
          begin
            Mode := RQ[i, l];
            RQ[i, l] := RQ[i, l + 1];
            RQ[i, l + 1] := Mode;
          end;
        end;
      end;
    end
    else
    begin
      for p := 1 to e do
      begin
        for l := 1 to e - 1 do
        begin
          if RQ[i, l] < RQ[i, l + 1] then
          begin
            Mode := RQ[i, l];
            RQ[i, l] := RQ[i, l + 1];
            RQ[i, l + 1] := Mode;
          end;
        end;
      end;
    end;
  end;
  if UseOutFile then
  begin
    WriteLn(InputFile, ' ');
  end;
  writeln('Sorted matrix');
  for i := 1 to n do
  begin
    for j := 1 to e do
    begin
      if UseOutFile then
      begin
        Write(InputFile, RQ[i, j]);
        Write(InputFile, ' ');
      end
      else
      begin
        Write(RQ[i, j]);
        Write(' ');
      end;

    end;
    if UseOutFile then
    begin
      Writeln(InputFile, ' ');
    end
    else
      Writeln;
  end;

  if UseOutFile then
    Close(InputFile);
  readln;

end.
