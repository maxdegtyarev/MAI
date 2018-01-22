program Task3;

uses
  crt;

type
  Matrix = array[1..100, 1..100] of integer;
  CS = set of char;

var
  Q: Matrix;
  i, j, k, min, flag, N, M, l, z, p, Mode, Modes: integer;
  R: integer;
  S,V: string;
  InputFile: Text;
  UseOutFile: boolean;
  Author, About, Group: string;
  Commands: CS;
begin
  UseOutFile := False;
  Author := 'Maxim Degtyarev';
  About := 'Task 3';
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
          S := ParamStr(ParamCount);
        end;
        '-o': Include(Commands, 'o');
      end;
    end;
  end;

  //Быстро прогоняем по основным командам
  if 'h' in Commands then
    writeln(About);
  if 'i' in Commands then
    writeln(Author);
  if 'g' in Commands then
    writeln(Group);
  if 'o' in Commands then
    UseOutFile := True;
  if 'c' in Commands then
    clrscr;

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
    writeln('Enter input NxM');
    z := 1;
    while (z <> 0) do
    begin
      readln(S);
      val(S, N, z);
      readln(S);
      val(S, M, z);
      if (z <> 0) or (N > 100) or (N <= 0) or (M > 100) or (M <= 0) then
        writeln('Not correct!');
    end;
    writeln('Enter input data for matrix');
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
        if K <= 0 then
        begin
          writeln('K must be > 0');
          readln;
          halt(-1);
        end;
        Q[i, j] := K;
      end;
    end;
  end;
  if 'r' in Commands then//Если хочет ввести данные рандомно
  begin
    randomize;
    N := random(10);
    M := random(10);
    for i := 1 to n do
    begin
      for j := 1 to m do
      begin
        Q[i, j] := random(100);
      end;
    end;
  end;
  if 'f' in Commands then //Если хочет ввести данные из файла
  begin
    writeln('Enter input NxM');
    z := 1;
    while (z <> 0) do
    begin
      readln(V);
      val(V, N, z);
      readln(V);
      val(V, M, z);
      if (z <> 0) or (N > 100) or (N <= 0) or (M > 100) or (M <= 0) then
        writeln('Not correct!');
    end;
    writeln(S);
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
  end;

  writeln('Matrix');
  for i := 1 to N do
  begin
    for j := 1 to M do
    begin
      Write(Q[i, j], ' ');
    end;
    writeln;
  end;

  k := 0;
  writeln('Found points:');
  for i := 1 to N do
  begin
    min := 9999999999;
    for j := 1 to M do
      if min > Q[i, j] then
        min := Q[i, j];
    for j := 1 to M do
    begin
      if Q[i, j] = min then
      begin
        Mode := 0;
        for l := 1 to N do
        begin
          if Q[l, j] > min then
          begin
            Mode := 1;
            break;
          end;
        end;
        if Mode = 0 then
        begin
          Inc(k);
          writeln(Q[i, j], '[', i, ',', j, ']');
        end;
      end;
    end;
  end;

  //Если точек таковых не найдено
  if k = 0 then
  begin
    writeln('EMPTY');
  end;
  readln;
end.
