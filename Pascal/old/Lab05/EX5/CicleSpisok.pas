program CicleSpisok;

type
  Uzel = ^Node;

  Node = record
    Number: integer;
    Next: Uzel;
  end;
var
  Head, OSN, UP, DOWN: Uzel;
  Uzels, N, R, F, QW, ASZ: integer;
  St1, St2: string;

  procedure AddToList(var H: Uzel; id: integer);
  var
    Temp: Uzel;
  begin
    new(Temp);
    Temp^.Number := H^.Number + 1;

    if Uzels = 1 then
    begin
      OSN^.Next := Temp;
    end;
    if UZELS = 0 then
    begin
      H := Temp;
      OSN := Temp;
      Inc(UZELS);
    end
    else
    begin
      H^.Next := Temp;
      Temp^.Next := OSN;
      H := Temp;
      Inc(UZELS);
    end;

  end;

  {Процедура вывода циклического списка N элементов, бесконечность кругов}
  procedure GCL(var H: Uzel; N: integer);
  var
    Clone: Uzel;
  begin
    Clone := H;
    while (N <> 0) do
    begin
      writeln(CLONE^.Number);
      CLone := Clone^.Next;
      Dec(N);
    end;
  end;

  procedure Rounder(var O: Uzel; m: integer);
  var
    K: integer;
    CURRENT, TEMP: Uzel;
  begin
    CURRENT := O;
    while (UZELS <> 1) do
    begin
      K := M;
      while K <> 1 do
      begin
        UP := UP^.Next;
        CURRENT := CURRENT^.Next;
        Down := DOWN^.Next;
        Dec(K);
      end;
      //Теперь переходим к процессу удалению
      Dec(UZELS);
      TEMP := CURRENT;
      CURRENT := CURRENT^.Next;
      Down^.Next := Current;
      UP := UP^.Next;
      write('DELETED: ');
      writeln(TEMP^.Number);
      Dispose(TEMP);

    end;
    write('OSTALSYA: ');
    writeln(CURRENT^.Number);
  end;


begin
  new(Head);
  new(OSN);
  Head^.Next := nil;
  Head^.Number := 0;
  QW:= 1;
  ASZ:= 1;
  while ((QW <> 0) and (ASZ <> 0)) do
  begin
    readln(St1); readln(St2);
    val(St1, N, QW);
    val(St2, F, ASZ);

    if (QW <> 0) or (ASZ <> 0) then
    begin
      writeln('Not correct!');
    end;
  end;
  if (N = 0) or (F = 0) or (N > 99999) or (F > 9000) then begin writeln('0!!!');  readln(); halt(-1); end;
  for R := 1 to abs(N) do
  begin
    AddToList(Head, Uzels);
  end;

  //Заполнили список узлами - перешли к следующему этапу

  UP := OSN^.Next; //Верхний шаг
  Down := Head;   //Нижний шаг
  Down^.Next := OSN;
  Rounder(OSN, abs(F));
  readln;

end.
