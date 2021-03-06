{
 Задача 2
}
program Task2;

uses
  crt;

type
  CS = set of char;

var
  Q: array[1..100000] of integer;
  K, i, j, z, l, n, p, Mode, Modes: integer; //1 - e, 2- r, 3 - f
  R: integer;
  S: string;
  InputFile: Text;
  GA, UseOutFile: boolean;
  Author, About, Group: string;
  Commands: CS;
begin
  GA := False;
  UseOutFile := False;
  Author := 'Maxim Degtyarev';
  About := 'Task 2';
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
  else if not ('e' in commands) and not ('f' in commands) and not
    ('r' in commands) then
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

  if 'e' in Commands then//Если хочет ввести данные вручную
  begin
    writeln('Give me N');
    z := 1;
    while (z <> 0) do
    begin
      readln(S);
      val(S, N, z);
      if z <> 0 then
        writeln('Not correct!');
    end;

    writeln('Enter input data for array');
    for i := 1 to n do
    begin
      z := 1;
      while (z <> 0) do
      begin
        readln(S);
        val(S, K, z);
        if z <> 0 then
          writeln('Not correct!');
      end;
      Q[i] := K;
    end;
  end;
  if 'r' in Commands then//Если хочет ввести данные рандомно
  begin
    randomize;
    N := random(10000);
    for i := 1 to n do
    begin
      Q[i] := random(10);
    end;
  end;
  if 'f' in Commands then//Если хочет ввести данные из файла
  begin
    writeln('Opening file ' + S);
    Assign(InputFile, S);
      {$I-}
    reset(InputFile);
      {$I+}
    if IORESULT <> 0 then
    begin
      writeln('File not Found!');
      halt;
    end;
    writeln('Enter N');
    z := 1;
    while (z <> 0) do
    begin
      readln(S);
      val(S, N, z);
      if z <> 0 then
        writeln('Not correct!');
    end;
    for i := 1 to n do
    begin
      Read(InputFile, Q[i]);
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


  for i := 1 to n do
  begin
    if UseOutFile then
    begin
      Write(InputFile, Q[i]);
      Write(InputFile, ' ');
    end
    else
    begin
      Write(Q[i]);
      Write(' ');

    end;
  end;
  if UseOutFile then
  begin
    Writeln(InputFile, '');
  end;
  //Само решение задачи
  Mode := 0;
  l := 0;
  i := 1;
  while i <= n do
  begin
    if Q[i] = 0 then
    begin
      while (Q[i] = 0) and (i <= n) do
      begin
        Inc(l);
        Inc(i);
      end;
      if l > mode then
        mode := l;
      i := i - 1;
      l := 0;
    end;
    Inc(i);
  end;
  writeln;

  i := 1;
  l := 1;
  while i <= n do
  begin
    if Q[i] = 0 then
    begin
      l := i;
      while (Q[i] = 0) and (i < n) do
      begin
        Inc(i);
      end;
      Q[l] := Q[i];
      Q[i] := 0;
      if i = n then
        break;
      i := l - 1;
    end;
    Inc(i);
  end;



  for i := 1 to n do
  begin
    if UseOutFile then
    begin
      Write(InputFile, Q[i]);
      Write(InputFile, ' ');
    end
    else
    begin
      Write(Q[i]);
      Write(' ');
    end;
  end;

  writeln;
  if UseOutFile then
  begin
    writeln(InputFile, '');
    writeln(InputFile, Mode);
    Close(InputFile);
  end
  else
    writeln(Mode);
  writeln;

  readln;

end.
