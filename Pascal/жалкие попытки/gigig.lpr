uses
   Sysutils;
const
  UsingNums: set of char = ['0'..'9'];
type
  Matrix = array[1..100,1..100] of integer;
var
  Q: Matrix;
  f: text;
  s: char;
  st,BUFF: string;
  i,j,k,l: integer;
  n,m: integer;
begin

   assign(f, 'in.txt');
   {$I-}
       reset(f);
   {$I+}
   N:= 1;
   M:= 1;
   while not(EOF(f)) do begin
      readln(f,st);
      st:= st + ' ';
      inc(n);
      for i:= 1 to length(st) do begin
         //Гуляем по строке
         if st[i] in UsingNums then begin
            BUFF:= BUFF + st[i];
            //Идём далее
         end
         else if (st[i] = ' ') or (st[i] = #10) then begin
             writeln(BUFF);
             val(BUFF,Q[N,M]);
             inc(M);
             BUFF := '';
         end
         else begin
            writeln('IDIOT');
            readln;
            halt;
         end;
      end;
      st:='';
      inc(N);
   end;

   for i:= 1 to N do begin
      for j:= 1 to M do begin
         write(Q[i,j]);
         write(' ');

      end;
      //writeln;
   end;
   close(f);
   readln;
end.
