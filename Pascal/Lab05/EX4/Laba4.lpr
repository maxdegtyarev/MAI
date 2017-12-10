{Задача 4}
program Laba4;

uses
  SysUtils,
  Math;

{Основные константы}
const
  UsingOperators: set of char = ['+', '-', '*', '/', '^'];
  UsingNums: set of char = ['0'..'9'];

  {Основные типы}
type

  {Стек чисел дробного вида}
  Stack = ^Node;

  Node = record
    Data: real;
    Next: Stack;
  end;

  {Глобальные переменные}
var
  Head: Stack;
  Pipi: real;
  ins: string;

  {######Реализация функционала стека######}

  {#Процедура добавления в стек (ДЛЯ РАЦИОНАЛЬНЫХ ЧИСЕЛ)}
  procedure AddToStack(var H: Stack; d: real);
  var
    Temp: Stack;
  begin
    new(Temp);
    Temp^.Data := d;
    Temp^.Next := H;
    H := Temp;

  end;


  {#Процедура печати всех элементов стека}
  procedure PrintStack(var H: Stack);
  var
    HeadClone: Stack;
  begin
    HeadClone := H;
    while (HeadClone^.Next <> nil) do
    begin
      writeln(HeadClone^.Data);
      HeadClone := HeadClone^.Next;
    end;
  end;

  {#Функция, которая выдаёт нам элемент стека}
  function GetElementFromStack(var H: Stack): real;
  var
    R: real;
    Temp: Stack;
  begin
    if H^.Next <> nil then
    begin
      R := H^.Data;
      Temp := H;
      H := H^.Next;
      Dispose(Temp);
      Result := R;
    end
    else
    begin
      writeln('Error! Stack is empty');
      readln();
      halt(-1);
    end;
  end;

  {########Конец функционала стека#########}

  {########Начало функционала конвертеров#########}

  {#Функция, которая получает из постфикса конечное число}
  function PostfixToReal(inval: string): real;
  var
    x, y: real;
    check: integer;
    C: integer;
    TMP, BUFFER: string;
    Sym: char;
  begin
    TMP := inval + '$';
    C := 1;
    while (TMP[C] <> '$') do
    begin
      //Начинаем обход строки
      Sym := TMP[C];
      if (((Sym = '-') and (TMP[C + 1] in UsingNums)) or (Sym in UsingNums)) then
      begin
        if Sym = '-' then
        begin
          BUFFER := BUFFER + '-';
          Inc(C);
          Sym := TMP[C];
        end;
        while ((Sym <> ' ') and (not (Sym in UsingOperators))) do
        begin
          if Sym = '.' then Sym := ',';
          BUFFER := BUFFER + Sym;
          Inc(C);
          Sym := TMP[C];
        end;
        AddToStack(Head, StrToFloat(BUFFER));
        BUFFER := '';
        C := C - 1;
      end
      else if (Sym in UsingOperators) then
      begin
        case Sym of
          '+':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := x + y;
            AddToStack(Head, x);
          end;
          '-':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            if (x > y) then
            begin
              x := x - y;
            end
            else
              x := y - x;
            AddToStack(Head, x);
          end;
          '*':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := x * y;
            AddToStack(Head, x);
          end;
          '/':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            if (y = 0) then
            begin
              writeln('Error! Ziro!');
              readln();
              halt(-1);
            end;
            if (x > y) then
            begin
              x := x / y;
            end
            else
            begin
              x := y / x;
            end;
            AddToStack(Head, x);
          end;
          '^':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := power(y, x);
            AddToStack(Head, x);
          end;
        end;
      end;

      Inc(C);
    end;

  end;

  //Процедура проверки на достаточность операции
  procedure CheckForD(inst: string);
  var
    D, REZ: integer;
    CurrentSymbol: char;
  begin
    D := 1;
    inst := inst + '$';
    {
           Суть решения: пройти по строке, если цифра, инкрементнуть чек, если знак операции - деинкрементнуть на нужное количество чисел для операции
    }
    while (inst[D] <> '$') do
    begin
      CurrentSymbol := inst[D];
      if (((CurrentSymbol = '-') and (inst[D + 1] in UsingNums)) or
        (CurrentSymbol in UsingNums)) then
      begin
        if CurrentSymbol = '-' then
        begin
          Inc(D);
          CurrentSymbol := inst[D];
        end;
        while ((CurrentSymbol <> ' ') and (not (CurrentSymbol in UsingOperators))) do
        begin
          Inc(D);
          if D < length(inst) then
          begin
            CurrentSymbol := inst[D];
          end
          else
            break;
        end;
        D := D - 1;
        Inc(REZ);
      end
      else if (CurrentSymbol in UsingOperators) then
      begin
        if CurrentSymbol = '^' then
        begin
          REZ := REZ - 1;
        end
        else
        begin
          if (REZ mod 2 = 1) then
          begin
            REZ := REZ - 1;
          end
          else
          begin
            REZ := REZ - 2;
          end;
        end;
      end;
      Inc(D);
    end;
    if (REZ <> 0) then
    begin
      writeln('Not corrent string');
      readln;
      halt(-1);
    end;
  end;

begin
  new(Head);
  Head^.Next := nil;
  readln(ins);
  //Сразу осуществим следующу проверку:
 // CheckForD(ins);
  writeln(Postfixtoreal(ins));



  readln();
end.
