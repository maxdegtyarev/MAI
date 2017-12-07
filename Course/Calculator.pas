{
        2017, Дегтярев Максим.
        Группа: М80-112Б-17
        Калькулятор обыкновенных дробей
        Версия: 1.0
}

program Calculator;

uses
  Math,
  crt,
  SysUtils;

{Основные константы}
const
  UsingOperators: set of char = ['+', '-', '*', '/', '^'];
  UsingNums: set of char = ['0'..'9'];
  PI = 3.14159;


  {Вводим структуру данных: Стек}
type
  Stack = ^Node;

  Node = record
    Data: real;
    Next: Stack;
  end;

var
  FD: real;
  InputCommand: string;
  InputString: string;
  Head: Stack;



  //Функции и процедуры


  {Обработчик ошибок}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('КРИТИЧЕСКАЯ ОШИБКА!!! -> ' + TypeOfError);
    readln();
    halt(1);
  end;

  {Функция конвертирования выражения вида x|y/z в обычное число типа Real}
  function toR(input: string): real;
  var
    C: integer;
    R, T, F: real;
    K: boolean;
    L, G, B: string;
  begin

    C := 1;
    K := False;
    while C <= length(input) do
    begin
      if input[C] = '|' then
      begin
        K := True;
        Inc(C);
      end;
      if input[C] = '/' then
      begin
        T := StrToFloat(L);
        F := StrToFloat(G);
        Inc(C);

        while C <= length(input) do
        begin
          B := B + input[C];
          Inc(C);
        end;

        R := StrToFloat(B);
        if R = 0 then
          ErrorHandler('#1 : попытка деления на ноль. Проверьте формат входного выражения');
        break;
      end;
      if not (K) then
      begin
        L := L + input[C];
      end
      else
      begin
        G := G + input[C];
      end;
      Inc(C);
    end;
    //Получаем результат
    F := F / R;
    T := T + F;
    Result := T;

  end;



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
      ErrorHandler('#2 Стек пустой!');
    end;
  end;

  {########Конец функционала стека#########}

  {++++++++Начало функционала конвертеров++++++++}

  {#Функция, которая получает из постфикса конечное число}
  function PostfixToReal(inval: string): real;
  var
    x, y: real;
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
      if (Sym in UsingNums) then
      begin
        while ((Sym <> ' ') and (not (Sym in UsingOperators))) do
        begin
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
              ErrorHandler('попытка деления на ноль');
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

        end;
      end;

      Inc(C);
    end;

  end;

  {+++++++++Конец функционала конвертеров++++++++++}

  procedure DialogMenu();
  begin
    writeln('Добро пожаловать в калькулятор дробей!');

    while True do
    begin
      writeln('');
      writeln('Укажите действие, которое вы хотите совершить:');
      writeln('Введите 1, если вы хотите ввести выражение в консоль');
      writeln('2, если вы хотите прочитать выражение или множество выражений из файла');
      writeln('3, для открытия помощи, где вы можете ознакомиться со всем функционалом ');
      writeln('4, если вы хотите ввести выражение с параметрами, затем задать параметр');
      writeln('5, если вы хотите посчитать выражение в постфиксной форме');
      writeln('0, для выхода из программы');
      Write('Ввод:');
      readln(InputCommand);
      case InputCommand of
        '1':
        begin
          clrscr;
          writeln('');
          Write('Введите математическое выражение: ');
          Read(InputString);
          writeln(toR(InputString));
          readln();
          readln();
          clrscr;
        end;
        '5':
        begin
          clrscr;
          writeln('');
          Write('Введите постфиксное выражение. Числа должны вводиться через пробел ');
          Read(InputString);
          writeln('Успешно получен ответ:');
          writeln('');
          writeln('В целой форме:');
          writeln(Round(PostfixToReal(InputString)));
          writeln('');
          writeln('В дробной форме:');
          writeln(PostfixToReal(InputString));
          readln();
          readln();
          clrscr;
        end;
        '0':
          halt(0);
        else
          writeln('Некорректный ввод!');
      end;
    end;
  end;

begin
  //Инициализация стеков
  new(Head);
  Head^.Next := nil;
  DialogMenu();
end.
