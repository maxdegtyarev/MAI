﻿program Task2;

var
  N, C: integer;
  rr, S: string;
  f: Text;
  //Процедура получения подможеств

  procedure g(i, j: integer; s, t: string);
  var
    ff: string;
  begin
    if t <> '' then
    begin
      writeln(f, '{' + s + '}' + ' ');
    end;
    if j <= i then
    begin
      str(j, ff);
      Inc(j);
      g(i, j, s, '');
      g(i, j, s + ff + ' ', '1');
    end;
  end;

  procedure FF(Z: integer);
  begin
  g(Z, 1, '', '1');
  end;

begin
  //Этот блок подлежит копированию в следующих заданиях, где должен быть целочисленный ввод
  C := 1;
  while (C <> 0) do
  begin
    writeln('Give me a value:');
    readln(S);
    val(S, N, C); //Если юзверь что-то натворил не то, поругаем его
    if c <> 0 then
      writeln('this Is not value or is very big value or is double value');
  end;
  //write(S);
  N := ABS(N);
  str(N, rr);
  Assign(f, '2-' + rr + '.txt');
  {$I-}
  reWrite(f);
  {$I+}
  if IORESULT <> 0 then
  begin
    writeln('ERROR: [FILE WRITING ERROR]');
    halt(1);
  end;
  if N = 0 then begin writeln(f,'{ }'); writeln(f,'{0}'); end
  else begin
  if N > 20 then
  begin
    N := 20;
    writeln('N is very big. Then we have made his to 20');
  end;
  //Вызываем рекурсию
  FF(N);
  end;

  //После обработки закрываем файл. Выводим информацию об успешной записи
  Close(f);
  writeln('WRITING: [OK]');
  readln();

end.
