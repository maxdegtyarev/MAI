{
 Задача 2
}
program Task2;

uses
  crt;

const
  n = 10;

var
  Q: array[1..n] of integer;
  K, i, j, z, l, p, Mode, Modes: integer; //1 - e, 2- r, 3 - f
  R: integer;
  S: string;
  InputFile: Text;
  GA, UseOutFile: boolean;
  Author, About, Group: string;
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
        '-h': writeln(About);
        '-i': writeln(Author);
        '-g': writeln(Group);
        '-c': clrscr;
        '-e':
        begin
          Mode := 1;
          Inc(Modes);
        end;
        '-r':
        begin
          Mode := 2;
          Inc(Modes);
        end;
        '-f':
        begin
          Mode := 3;
          Inc(Modes);
          S := ParamStr(ParamCount);
        end;
        '-o': UseOutFile := True;
      end;
      GA := True;
    end;
  end;

  if Modes > 1 then
  begin
    writeln('Too many modes!');
    readln;
    halt(-1);
  end
  else if Modes = 0 then
  begin
    writeln('You have not entered modes. Please enter -e or -r or -f');
    readln(S);
    case S of
      '-e':
      begin
        Mode := 1;
        Inc(Modes);
      end;
      '-r':
      begin
        Mode := 2;
        Inc(Modes);
      end;
      '-f':
      begin
        Mode := 3;
        writeln('Enter your file:');
        readln(S);
        Inc(Modes);
      end;
      else
      begin
        writeln('##Idiot!');
        halt(-1);
      end;
    end;
  end;

  //Теперь разбираемся с модами

  case Mode of
    1: //Если хочет ввести данные вручную
    begin
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
    2: //Если хочет ввести данные рандомно
    begin
      randomize;
      for i := 1 to n do
      begin
        Q[i] := random(10);
      end;
    end;
    3: //Если хочет ввести данные из файла
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

      for i := 1 to n do
      begin
        Read(InputFile, Q[i]);
      end;

      Close(InputFile);
    end;
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
    writeln(InputFile, Mode);
    Close(InputFile);
  end
  else
    writeln(Mode);
  writeln;

  readln;

end.
