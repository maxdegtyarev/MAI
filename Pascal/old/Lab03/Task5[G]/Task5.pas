{
 Задача 5
}
program Task5;

uses
  crt;

type
  CS = set of char;
var
  Q: array[1..100] of integer;
  K, i, j, z, p: integer; //1 - e, 2- r, 3 - f
  N: integer;
  S, V: string;
  InputFile: Text;
  UseOutFile: boolean;
  Author, About, Group: string;
  Commands: CS;
begin
  UseOutFile := False;
  Author := 'Maxim Degtyarev';
  About := 'Task 5';
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
        writeln('##Durachina you prostofilya');
        halt(-1);
      end;
    end;
  end;

  //Теперь разбираемся с модами


  if 'e' in commands then  //Если хочет ввести данные вручную
  begin
    writeln('Enter length of array 1 <= N <= 100');
    z := 1;
    while (z <> 0) do
    begin
      readln(V);
      val(V, n, z);
      if (z <> 0) or (n > 100) or (n <= 0) then
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
  if 'r' in commands then //Если хочет ввести данные рандомно
  begin
    randomize;
    n := random(20);
    for i := 1 to n do
    begin
      Q[i] := random(10);
    end;
  end;
  if 'f' in commands then //Если хочет ввести данные из файла
  begin
    writeln('Enter length of array 1 <= N <= 100');
    z := 1;
    while (z <> 0) do
    begin
      readln(V);
      val(V, n, z);
      if (z <> 0) or (n > 100) or (n <= 0) then
        writeln('Not correct!');
    end;
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


  if UseOutFile then
  begin
    Assign(InputFile, 'out.txt');
  {$I-}
    rewrite(InputFile);
  {$I+}
    if IORESULT <> 0 then
      writeln('Errro');
  end;


  //Проходим по массиву и ищем необходимое
  Z := 0;
  //Выводим сам массив
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
  for i := 1 to N do
  begin
    p := Q[i]; //Текущий элемент
    k := 0;
    for j := i to N do
    begin //Если новый временный равен текущему, то добавляем ему ранг
      if p = Q[j] then
        Inc(k); //Здесь
    end;

    if k > Z then //Z- максималка
      Z := k;
  end;
  writeln;
  writeln('Maximus');
  for i := 1 to n do
  begin
    p := Q[i];
    //Теперь зная максимум ищем все элементы массива, которые удовлетворяют максимальному количеству и выводим их
    k := 0;
    for j := i to n do
    begin
      if p = Q[j] then
        Inc(k);
    end;
    if k = Z then
    begin
      if UseOutFile then
      begin
        writeln(InputFile, '');
        Writeln(InputFile, Q[i], ' ');
      end
      else
      begin
        writeln('');
        Writeln(Q[i], ' ');
      end;
    end;
  end;

  //Теперь сортируем массив
  if UseOutFile then
        begin
          writeln(InputFile, '');
        end
        else
        begin
          writeln;
        end;
  for i := 1 to n do
  begin
    for j := 1 to n - 1 do
    begin
      if Q[j] > Q[j + 1] then
      begin
        p := Q[j + 1];
        Q[j + 1] := Q[j];
        Q[j] := p;
      end;
    end;
  end;

  //Выводим сам массив
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
    Close(InputFile);
  readln;
end.
