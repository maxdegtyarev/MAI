program Task3;

uses
  crt;

var
  rf: Text;
  REZ: string;

  procedure G(n: integer; RS: string; R: integer);
  var
    TS: string;//Временная строка
    i, temp: integer;  //Временные переменные
  begin
    if R = 0 then
    begin  //Если раскладывать нечего, выходим
      str(n, Rez);
      Rez := RS + Rez;
      writeln(RS, n);
      writeln(rf, Rez);
      R := n - 1;
    end;
    for i := R downto 1 do
    begin
      str(i, TS);
      temp := 0;
      if i < n - i then
        temp := i;

      G(n - i, RS + TS + '+', temp);
    end;
  end;


var
  n, Q: integer;
  S: string;
begin
  clrscr;
  Q := 1;
 while (Q <> 0) do
  begin
    writeln('Hello, dear user! Give me a chislo from 1 to mnogo');
    readln(S);
    val(S, N, Q);
    if Q <> 0 then
      writeln('Not correct input');
  end;
  if (N <= 0) or (N > 20) then begin
    writeln('Badly');
    readln;
    exit;
  end;
  Assign(rf, 'out-3.txt');
  {$I-}
  rewrite(rf);
  {$I+}
  G(N, '', 0);
  close(rf);
  readkey;
end.
