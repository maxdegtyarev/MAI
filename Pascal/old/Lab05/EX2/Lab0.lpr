program Lab0;

type
  Queque = ^Node;

  Node = record
    Data: integer;
    Next: Queque;
  end;

var
  Head, Foot: Queque;
  K, V, A: integer;
  C: string;
  GC: integer;

  procedure Enqueue(var H, F: Queque; Data: integer);
  var
    Temp: Queque;
  begin
    new(Temp);
    Temp^.Data := Data;
    //Если нет первого элемента в очереди, или элемент один
    if (H^.Data = 0) then
    begin
      Temp^.Next := nil;
      H := Temp;
      F := Temp;
    end
    else
    begin //Если же уже есть один товарищ в очереди и более, то
      Temp^.Next := nil;
      F^.Next := Temp;
      F := Temp;
    end;
    Inc(GC);
  end;

  function Dequeque(var H, F: Queque): integer;
  var
    TEMP: QUEQUE;
    ForR: integer;
  begin
    if (GC = 0) then
    begin
      Result := 0;
    end
    else
    begin
      GC := GC - 1;
      Temp := H;
      H := H^.Next;


      ForR := Temp^.Data;
      Dispose(Temp);
      Result := ForR;

    end;
  end;


begin
  new(Head);
  new(Foot);
  Head^.Next := nil;
  Head^.Data := 0;
  Foot^.Next := nil;
  A := 1;
  while (True) do
  begin
    while (A <> 0) do
    begin
      readln(C);
      val(C, K, A);
      if A <> 0 then
        writeln('NOT CORRECT');
    end;

    if (K = 0) then
      break;
    if (K <> 0) then
    begin
      EnQueue(Head, Foot, K);
    end;
    A := 1;
  end;
  writeln('----------------------------------');
  K := Dequeque(Head, Foot);
  while (K <> 0) do
  begin
    if (K mod 2 = 0) then
      writeln(K);
    K := Dequeque(Head, Foot);
  end;
  readln();
end.
