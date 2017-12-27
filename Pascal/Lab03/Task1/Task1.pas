const
  n=11;
var
a: array[1..n] of integer;
I,J,K,L,Max,tec,b: integer;

begin
// 8 5 1 9 7 5 3 0 7 8
randomize;
for i:= 1 to n do begin
    a[i] := random(10);
    write(a[i], ' ');
end;

i:=2;
max:=0;
tec:=0;
b:=n;
if (n mod 2 = 0) then b:=b-1;


while i<b do begin
if (a[i]>a[i-1]) and (a[i]>a[i+1]) then tec:=tec+1
else begin
if max<tec then max:=tec;
tec:=0;
end;
i:=i+2;
end;
if max<tec then max:=tec;
writeln('Max Length ',max);
writeln;

writeln(Max);
readln;
end.
