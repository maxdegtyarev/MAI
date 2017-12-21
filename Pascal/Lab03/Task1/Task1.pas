program Task1;

uses
  crt;

const
  n = 10;

type
  Tcommands = set of char;
  Tmas = array[1..n] of integer;


var
  mas: Tmas;
  len, k, max, i, j, lengthMas: integer;
  commands: Tcommands;
  FileInput: string;
  fOut: Text;
begin
  for i := 1 to n do
  begin
    mas[i] := random(n);
  end;

  for i := 1 to length(Mas) do
  begin
    Write(mas[i], ' ');
  end;
  writeln;

  max := 1;
  len := 1;
  k := 1;
  for i := 1 to n - 1 do
  begin
    if k = 1 then
    begin
      if mas[i] < mas[i + 1] then
      begin
        Inc(len);
        k := 2;
      end
      else
      begin
        if len > max then
          max := len;
        len := 1;
        k := 1;
      end;
    end
    else if k = 2 then
    begin
      if mas[i] > mas[i + 1] then
      begin
        Inc(len);
        k := 1;
      end
      else
      begin
        if len > max then
          max := len;
        len := 1;
        k := 1;
      end;
    end;
  end;
  k := 1;
  for i := 2 to n - 1 do
  begin
    if k = 1 then
    begin
      if mas[i] < mas[i + 1] then
      begin
        Inc(len);
        k := 2;
      end
      else
      begin
        if len > max then
          max := len;
        len := 1;
        k := 1;
      end;
    end
    else if k = 2 then
    begin
      if mas[i] > mas[i + 1] then
      begin
        Inc(len);
        k := 1;
      end
      else
      begin
        if len > max then
          max := len;
        len := 1;
        k := 1;
      end;
    end;
  end;
  if len > max then
    max := len;
  if max > 3 then
  begin
    writeln('Result : ', max);
  end
  else
    writeln('No posl');
end.
