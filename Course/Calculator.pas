{
        2017, Дегтярев Максим.
        Группа: М80-112Б-17
        Калькулятор обыкновенных дробей
        Версия: 1.1
}

program Calculator;

uses
  Math,
  crt,
  SysUtils;

{Основные константы}
const
  UsingOperators: set of char = ['+', '-', '*', '/', '^'];
  UsingNums: set of char = ['0'..'9', '.', ','];
  PI = 3.14159;


  {Вводим структуру данных: Стек}
type
  Stack = ^Node;

  Node = record
    Data: real;
    Next: Stack;
  end;
  C_Stack = ^Nodec;

  Nodec = record
    Data: char;
    Next: C_stack;
  end;

  History = record
    inputstring: string;
    outputstring: string;
  end;

var
  FD: real;
  InputCommand: string;
  InputString: string;
  Head: Stack;
  Head_C: C_Stack;
  HistoryFile: History;



  {#######Элементарные функции#############}

  {Обработчик ошибок}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('КРИТИЧЕСКАЯ ОШИБКА!!! -> ' + TypeOfError);
    readln();
    halt(1);
  end;

  procedure ErrorDialog();
  begin
    clrscr;
    writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
    writeln('│                                                                             │');
    writeln('│                     Ошибка! Введите корректное значение                     │');
    writeln('│                                                                             │');
    writeln('└─────────────────────────────────────────────────────────────────────────────┘');
    writeln;
    writeln('НАЖМИТЕ ENTER ДЛЯ ПРОДОЛЖЕНИЯ');
    readln;
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

  {Функция выдачи приоритетов}
  function GetPriority(operators: char): integer;
  begin
    case operators of
      '+', '-': Result := 1;
      '*', '/': Result := 2;
      '^': Result := 3;
      '(', ')': Result := 0; //Скобки и иной мусор не даст нам двигаться дальше
    end;
  end;

  {#######Конец элементарных функций##########}



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

  {#Процедура добавления в стек (ДЛЯ СИМВОЛОВ)}
  procedure char_AddToStack(var H: c_stack; Data: char);
  var
    Temp: C_Stack;
  begin
    new(Temp);
    Temp^.Data := Data;
    Temp^.Next := H;
    H := Temp;
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

  {#Функция, которая выдаём нам элемент чаровского стека}
  function char_GetElementFromStack(var H: c_stack): char;
  var
    Temp: C_stack;
    c: char;
  begin
    if H^.Next <> nil then
    begin
      Temp := H;
      H := H^.Next;
      c := Temp^.Data;
      dispose(Temp);
      Result := c;
    end
    else
    begin
      ErrorHandler('#3 Стек символов пустой');
    end;
  end;

  {#Функция, которая проверяет пустоту символьного стека}
  function char_Stack_IsEmpty(var H: c_stack): boolean;
  begin
    if H^.Next = nil then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
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
          if (Sym = '.') then
            Sym := ',';
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
            //if (x > y) then
            //begin
            x := y - x;
            //end
            //else
            //  x := y - x;
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
          '^':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := Power(y, x);
            AddToStack(Head, x);
          end;

        end;
      end;

      Inc(C);
    end;

  end;

  {#Функция конвертирования инфикса в постфикс}
  function InfixToPostfix(input: string): string;
  var
    C, Z: integer;
    K, T, P: char;
    postfix: string;
    usedpoint: boolean;
  begin
    usedpoint := False;
    input := input + ')';
    C := 1;
    char_AddToStack(Head_C, '(');
    while not (char_stack_IsEmpty(Head_C)) do
    begin
      k := input[C];
      if (k = '(') then
      begin
        char_AddToStack(Head_C, '(');
      end
      else if (k in UsingNums) then
      begin
        while (k in UsingNums) do
        begin
          if (((k = ',') or (k = '.')) and (usedpoint <> True)) then
          begin
            if (postfix[c - 1] in UsingNums) and (input[c + 1] in UsingNums) then
            begin
              postfix := postfix + k;
              usedpoint := True;
            end;
          end
          else
          begin
            postfix := postfix + k;
          end;
          Inc(c);
          k := input[c];
        end;
        postfix := postfix + ' ';
        c := c - 1;
        usedpoint := False;
      end
      else if (k in UsingOperators) then
      begin
        T := K; //Берём текущий символ в T;
        P := char_GetElementFromStack(Head_C);
        Z := GetPriority(T);
        while (Z <= GetPriority(P)) do
        begin
          postfix := postfix + P + ' ';
          P := char_GetElementFromStack(Head_C);
        end;
        char_AddToStack(Head_C, P);
        char_AddToStack(Head_C, T);
        //Пожалуй, тут закончили
      end
      else if (k = ')') then
      begin
        T := char_GetElementFromStack(Head_C);
        while (T <> '(') do
        begin
          postfix := postfix + T + ' ';
          T := char_GetElementFromStack(Head_C);
        end;
        if (char_Stack_IsEmpty(Head_C)) then
          break;
      end;

      Inc(c);
    end;

    Result := postfix;
  end;

  {+++++++++Конец функционала конвертеров++++++++++}

  procedure DialogMenu();
  begin
    writeln('────────────────────────────────────────────────────────────────────────────────');
    writeln('│Добро пожаловать в калькулятор дробей!');

    while True do
    begin
      clrscr;
      writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
      writeln('│                                                                             │');
      writeln('│Укажите действие, которое вы хотите совершить:                               │');
      writeln('│                                                                             │');
      writeln('│  Введите:                                                                   │');
      writeln('│                                                                             │');
      writeln('│ ~ 1, если вы хотите ввести выражение в консоль                              │');
      writeln('│                                                                             │');
      writeln('│ ~ 2, если вы хотите прочитать выражение или множество выражений из файла    │');
      writeln('│                                                                             │');
      writeln('│ ~ 3, для открытия помощи, где вы можете ознакомиться со всем функционалом   │');
      writeln('│                                                                             │');
      writeln('│ ~ 4, если вы хотите ввести выражение с параметрами, затем задать параметр   │');
      writeln('│                                                                             │');
      writeln('│ ~ 5, если вы хотите посчитать выражение в постфиксной форме                 │');
      writeln('│                                                                             │');
      writeln('│ ~ 0, для выхода из программы                                                │');
      writeln('│                                                                             │');
      writeln('│                                                                             │');
      writeln('│                                                                             │');
      writeln('│                                                                             │');
      writeln('│                                                   (c) 2017, Дегтярев Максим │');
      writeln('└─────────────────────────────────────────────────────────────────────────────┘');
      Write('│-> Ввод:  ');
      readln(InputCommand);
      case InputCommand of
        '1':
        begin
          clrscr;
          writeln('');
          writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
          writeln('│                                                                             │');
          writeln('│    Введите математическое выражение. Числа должны вводиться через пробел    │');
          writeln('│                                                                             │');
          writeln('│    *Например: (5+2)/2-4*3                                                   │');
          writeln('│                                                                             │');
          writeln('│    Для удобства почитайте полную инструкцию к эксплуатации программы        │');
          writeln('│                                                                             │');
          Write('│->Ввод:     ');
          Read(InputString);
          writeln('└─────────────────────────────────────────────────────────────────────────────┘');
          writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
          writeln(
            '│                            Успешно получен ответ:                           │');
          writeln(
            '│                                                                             │');
          writeln(
            '│                                                                             │');
          writeln(
            '│В целой форме (c округлением до целых):                                      │');
          Write('│>>>  ');
          writeln(Round(Postfixtoreal(Infixtopostfix(Inputstring))));
          writeln(
            '│                                                                             │');
          writeln(
            '│В дробной форме:                                                             │');
          writeln(
            '│                                                                             │');
          Write('│>>>  ');
          writeln(Postfixtoreal(Infixtopostfix(Inputstring)));
          writeln(
            '└─────────────────────────────────────────────────────────────────────────────┘');
          readln();
          readln();
          clrscr;
        end;
        '5':
        begin
          clrscr;
          writeln('');
          writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
          writeln('│                                                                             │');
          writeln('│    Введите постфиксное выражение. Числа должны вводиться через пробел       │');
          writeln('│                                                                             │');
          Write('│->Ввод:     ');
          Read(InputString);
          writeln('└─────────────────────────────────────────────────────────────────────────────┘');
          writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
          writeln('│                            Успешно получен ответ:                           │');
          writeln('│                                                                             │');
          writeln('│                                                                             │');
          writeln('│В целой форме:                                                               │');
          Write('│>>>  ');
          writeln(Round(PostfixToReal(InputString)));
          writeln('│                                                                             │');
          writeln('│В дробной форме:                                                             │');
          writeln('│                                                                             │');
          Write('│>>>  ');
          writeln(PostfixToReal(InputString));
          writeln('└─────────────────────────────────────────────────────────────────────────────┘');
          readln();
          readln();
          readln();
          clrscr;
        end;
        '0':
          halt(0);
        else
           ErrorDialog();
      end;
    end;
  end;


begin
  //Инициализация стеков
  new(Head);
  new(Head_C);
  Head_C^.Next := nil;
  Head^.Next := nil;


  //Вызываем диалоговое меню
  DialogMenu();
end.
