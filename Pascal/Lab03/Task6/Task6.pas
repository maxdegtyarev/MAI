{
 Задача 6
}
program Task6;

uses
  crt;

const
  n = 3;
  m = 3;


type
  Matrix = array[1..n, 1..m] of integer;
  CS = set of char;
var
  Q: Matrix;
  K, i, j, z, Mode, Modes: integer; //1 - e, 2- r, 3 - f
  R: real;
  S: string;
  InputFile: Text;
  GA, UseOutFile: boolean;
  Author, About, Group: string;
  Commands: CS;
begin
  GA := False;
  UseOutFile := False;
  Author := 'Maxim Degtyarev';
  About := 'Task 6';
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

  if (('e' in commands) and ('f' in commands)) or
    (('e' in commands) and ('r' in commands)) or (('f' in commands) and
    ('r' in commands)) then
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


    if 'g' in Commands then //Если хочет ввести данные вручную
    begin
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
    if 'r' in Commands then //Если хочет ввести данные рандомно
    begin
      randomize;
      z := 1;
      writeln('Need K');
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

      for i := 1 to n do
      begin
        for j := 1 to m do
        begin
          Q[i, j] := 1 + random(2 * K - 2);
        end;
      end;
    end;
    if 'f' in Commands then //Если хочет ввести данные из файла
    begin
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



  if not('r' in Commands) then
  begin
    writeln('Need K');
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
  end;


  for i := 1 to n do
  begin
    for j := 1 to m do
    begin
      Write(Q[i, j]);
      Write(' ');
    end;
    writeln;
  end;

  //Ищем процент повторов
  for i := 1 to n do
  begin
    for j := 1 to m do
    begin
      if (Q[i, j] = k) then
        R := R + 1;
    end;
  end;

  if UseOutFile then
  begin
    Assign(InputFile, 'out.txt');
    {$I-}
    REWRITE(InputFile);
    {$I+}
    if IORESULT <> 0 then
      halt;
    str(((100 * R) / (M * N)): 0: 1, S);
    S := S + ' %';
    writeln(InputFile, S);
    Close(InputFile);
  end
  else
  begin
    Write(((100 * R) / (M * N)): 0: 1);
    Write('%');
    readln;
  end;
end.
