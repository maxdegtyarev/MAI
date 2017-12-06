program Task4;
//Задача №4 про перестановки
uses crt;
const MAXLENGTH = 10;
var
  instr: string;
  t: char;
  j,c,a,b,e: integer;
  lgc: integer;
  r,o: text;
procedure g(ip, iz: string);
var
  i : integer;
  tmp: string;
begin
  if length(ip) = 0 then
    writeln(r,iz);
  for i := 1 to length(ip) do begin
    tmp := ip;
    delete(tmp, i, 1);
    g(tmp, iz + ip[i]);
  end;
end;
var
  i : integer;
begin
  assign(r, '4.txt');
  assign(o,'in4.txt');
  {$I-}
       rewrite(r);
  {$I+}
  {$I-}
       reset(o);
  {$I+}

  if ioresult <> 0 then begin
      writeln('error of opening');
      halt(1);
  end;


  //Пусть строка есть
  readln(o,instr);

  //Наша задача сначала всё отсортировать в авфавитном порядке
  for i:= 1 to Length(instr) do begin
    for j:= 1 to (Length(instr) - 1) do begin
      if ord(instr[j]) > ord(instr[j+1]) then begin
          t := instr[j];
          instr[j] := instr[j+1];
          instr[j+1] := t;
      end;
    end;
  end;

  if (length(instr) > MAXLENGTH) then begin writeln('String bigger then limit (default-> 10)');  readln(); exit; end;
  //Чудесно! Наша строка была отсортирована!
  //Теперь можно переходить к весёлой рекурсии
  c:= 2;
  for a:= 1 to length(instr) - 1 do begin
      for b:= c to length(instr) do begin
          if instr[a] = instr[b] then begin
            e:= 1;
          end;
      end;
      inc(c);
  end;

  if e <> 1 then begin g(instr,''); end else begin writeln('Error! Have double symbols!'); end;
  close(r);
  close(o);
  writeln('EXIT!');
  readln();
end.
