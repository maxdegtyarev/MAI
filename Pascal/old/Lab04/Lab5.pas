program Lab5;
var
  N: integer;
  C: integer;
  p: integer;
  S: string;
procedure foo(ost, current: integer);
var
  z : integer;
begin
  if p = 1 then begin
    case N of
  0: begin
    writeln(0);
    exit;
    end;
  1: begin
    writeln(0);
    exit;
    end;
  2: begin
    writeln(0);
    exit;
    end;
  end;
  end;

  if ost = 0 then inc(c); //Если кубиков доступных нет, пихаем результат

  for z := 1 to current - 1 do begin
    foo(ost - z, z);
  end;
end;
begin
  c:= 0;
  p:= 1;
  //По умолчанию, первый уровнень уже считается
  randomize;
  while(p <> 0) do begin
    writeln('Give me a value:');
    readln(S);
    val(S,N,p); //Если юзверь что-то натворил не то, поругаем его
    if p <> 0 then writeln('this Is not number, idiot');
  end;
  if (N > 10) then begin writeln('Hmmm, i have changed N from your value to 20'); N:= 20; end;
 // N := 1+ random(9);
 // writeln(N);
  foo(N,N);

  writeln(c);
  readln();
end.
