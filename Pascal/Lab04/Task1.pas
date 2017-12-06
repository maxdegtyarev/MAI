program Task1;

const
  os: set of char = ['[', '(', '{', '<'];
  cs: set of char = [']', '}', ')', '>'];
var
  stroka, ss: string;
  c: char;
  ty, tod: Text;
  a, b, d, L: integer;
  pp: byte;

  procedure foo();
  begin
    if ((length(ss) mod 2) = 1) then
    begin
      writeln('Not closed');
      pp := 0;
      exit;
    end; //Если нечётная длина, то пишов вон

    for b := 1 to length(ss) do
    begin
      if ((Ord(ss[b + 1]) - Ord(ss[b])) < 3) and (ss[b] in os) and (ss[b + 1] in cs) then
      begin
        Delete(ss, b, 2);
        foo();
        break;
      end;

    end;
  end;

begin
  Assign(ty, 'in1.txt');
  Assign(tod, '1.txt');
  {$I-}
  reset(ty);
  rewrite(tod);
  {$I+}
  if IORESULT <> 0 then
  begin
    writeln('FILE NOT FOUND');
    readln();
    halt(1);
  end;

  readln(ty, stroka);
  if stroka = '' then begin writeln('Exitting'); exit; end;
  a := 1;
  b := length(stroka);
  while (a <> b) do
  begin
    if ((not (stroka[a] in os)) and (not (stroka[a] in cs))) then
    begin
      Delete(stroka, a, 1);
      b := length(stroka);
      a := 1;
    end;
    Inc(a);
  end;
  if (not (stroka[length(stroka)] in os) and not (stroka[length(stroka)] in cs)) then
    Delete(stroka, length(stroka), 1);
  pp := 0;
  ss := stroka;

  foo();

  if (length(ss) = 0) then
    writeln(tod, 'GOOD! Yeah! All was closed.');
  if (length(ss) > 0) then
    writeln(tod, 'Hmmmm, not Good. All were not closed');

  writeln('[OK]');
  Close(ty);
  Close(tod);
  readln();
end.
0
