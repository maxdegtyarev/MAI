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
  UsingOperators: set of char =
    ['+', '-', '*', '/', '^', '!', 's', 'c', 't', 'g', 'l', 'q'];

  UsingNums: set of char = ['0'..'9', '.', ','];
  Nums: set of char = ['0'..'9', '.', '(', ',', ')', '+', '-', '*',
    '/', '^', '!', 's', 'c', 't', 'g', 'l', 'q', ' '];
  FUNCTIONS = 9;


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


var
  InputCommand, InputString: string;
  Head: Stack;
  Head_C: C_Stack;
  InputFile, OutFile: Text;
  Functions_IN: array[1..FUNCTIONS] of string;
  Functions_OUT: array[1..FUNCTIONS] of string;
  MemoryR, Cache: real;
  MemoryI: integer;
  Smem, Smemi, MemC: string;
  MemO: char;

  {#######Элементарные функции#############}

  {Обработчик ошибок}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('КРИТИЧЕСКАЯ ОШИБКА!!! -> ' + TypeOfError);
    readln;
    readln;
    halt(1);
  end;

  procedure ErrorDialog(TypeOfError: string);
  var
    tf: string;
    k: integer;
  begin
    tf := '                                                ';
    k := 1;
    while k <= length(TypeOfError) do
    begin
      tf[k] := TypeOfError[k];
      Inc(k);
    end;
    clrscr;
    writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                     Ошибка! ' + tf + '│');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    writeln('└─────────────────────────────────────────────────────────────────────────────┘');
    writeln;
    writeln('НАЖМИТЕ ENTER ДЛЯ ПРОДОЛЖЕНИЯ');
    readln;
  end;

  function Factorial(input: real): real;
  var
    R, Rez: integer;
    T: integer;
  begin
    R := 1;
    Rez := 1;
    T := Round(input);
    if T = 0 then
      Result := 0;
    while (R <= T) do
    begin
      Rez := Rez * R;
      Inc(R);
    end;
    Result := Rez;
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
    if H <> nil then
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
    if H <> nil then
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
  function PostFixToReal(inval: string): real;
  var
    x, y: real;
    C: integer;
    TMP, BUFFER: string;
    Sym: char;
  begin
    TMP := inval + '─';

    C := 1;
    while (TMP[C] <> '─') do
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

        //Если выражение прошло проверку на корректность, то делаем все необходимые действия
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
            if (x = 0) then
            begin
              ErrorDialog('#4 попытка деления на ноль');
            end
            else
            begin
              x := y / x;
              AddToStack(Head, x);
            end;
          end;
          '^':
          begin
            x := GetElementFromStack(Head);
            y := GetElementFromStack(Head);
            x := Power(y, x);
            AddToStack(Head, x);
          end;
          '!':
          begin
            x := GetElementFromStack(Head);
            x := Factorial(x);
            AddToStack(Head, x);
          end;
          's':
          begin
            x := GetElementFromStack(Head);
            x := sin(x);
            AddToStack(Head, x);
          end;
          'c':
          begin
            x := GetElementFromStack(Head);
            x := cos(x);
            AddToStack(Head, x);
          end;
          't':
          begin
            x := GetElementFromStack(Head);
            x := tan(x);
            AddToStack(Head, x);
          end;
          'g':
          begin
            x := GetElementFromStack(Head);
            if round(sin(x)) = 0 then
              ErrorHandler('#5 Попытка деления на ноль');

            x := (cos(x) / sin(x));
            AddToStack(Head, x);
          end;
          'l':
          begin
            x := GetElementFromStack(Head);
            x := ln(x);
            AddToStack(Head, x);
          end;
          'q':
          begin
            x := GetElementFromStack(Head);
            x := sqrt(x);
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

  procedure CheckIn(input: string);
  var
    Pc, Cr, Cc, Punk: integer;

  begin

    Cr := 1;
    Punk := 0;
    Cc := 0;
    while (Cr <= Length(input)) do
    begin
      if input[Cr] = '(' then
        Inc(Cc);
      if input[Cr] = ')' then
        Dec(Cc);
      if not (input[Cr] in Nums) then
        ErrorHandler('#8 Некорректное выражение!!!');
      if input[Cr] in UsingNums then
      begin
        Inc(Cr);
        while (input[Cr] <> ' ') and not (input[Cr] in UsingOperators) and
          (Cr <= Length(input)) and (input[cr] <> ')') do
        begin
          if (input[Cr] = '.') or (input[Cr] = ',') then
            Inc(Punk);
          Inc(Cr);

        end;
        if Punk > 1 then
          ErrorHandler('#6 Некорректное выражение!!!');
        Punk := 0;
        Cr := Cr - 1;
      end;
      Inc(Cr);
    end;
    if Punk + Cc <> 0 then
      ErrorHandler('#7 Некорректное выражение!!!');
  end;

  function Preprocessor(input: string): string;
  var
    s: string;
    i, k: integer;

  begin
    k := 1;
    s := input;
    while k <= FUNCTIONS do
    begin
      while (pos(Functions_IN[k], s) <> 0) do
      begin
        i := pos(Functions_IN[k], s);
        Delete(s, i, length(Functions_IN[k]));
        insert(Functions_OUT[k], s, i);
      end;
      Inc(k);
    end;
    Result := s;

  end;

  procedure Help;
  begin
    clrscr;
    writeln;
    writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
    writeln('│                                                                             │');
    writeln('│    Добро пожаловать в программу помощи пользователям!                       │');
    writeln('│                                                                             │');
    writeln('│    Введите run для получения инструкции                                    │');
    writeln('│                                                                             │');
    writeln('│    Введите 0 для выхода из программы помощи пользователям!                  │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    Write('│->Ввод:     ');
    Readln(InputString);
    writeln('└─────────────────────────────────────────────────────────────────────────────┘');
    case InputString of
      '0': exit;
      'run':
      begin
        writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
        writeln('│                                                                             │');
        writeln('│    В рассчётах можно использовать следующие числа, операции, функции:       │');
        writeln('│    + Целые числа, т.е -1000, 54, 979 и т.д                                  │');
        writeln('│    + Рациональные числа, т.е 259.7, 25.8                                    │');
        writeln('│    + Обыкновенные дроби, т.е в программе вводится как 6|8/10 или 21/77      │');
        writeln('│    + Скобки, т.е открывающие и закрывающие скобки ( )                       │');
        writeln('│    + Константы, т.е число Пи вводится как p, а число е вводится как e       │');
        writeln('│    + Операторы, т.е                                                         │');
        writeln('│    + Оператор сложения: +                                                   │');
        writeln('│    + Оператор вычитания: -                                                  │');
        writeln('│    + Оператор умножения: *                                                  │');
        writeln('│    + Оператор деления: /                                                    │');
        writeln('│    + Оператор возведения в степень: ^                                       │');
        writeln('│    + Оператор получения факториала числа: !                                 │');
        writeln('│    + Тригонометрические функции, при этом все аргументы должны быть в rad   │');
        writeln('│    + Синус: sin()                                                           │');
        writeln('│    + Косинус: cos()                                                         │');
        writeln('│    + Тангенс: tg()                                                          │');
        writeln('│    + Котангенс: ctg()                                                       │');
        writeln('│    + Функция вытаскивания числа из под знака корня, т.е sqrt()              │');
        writeln('│                                                                             │');
        writeln('└─────────────────────────────────────────────────────────────────────────────┘');
        readln;
      end;
      else
        ErrorDialog('Ошибка! Введено неверное значение!');
    end;
  end;

  procedure WorkWithFile;
  begin
    clrscr;
    writeln;
    writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
    writeln('│                                                                             │');
    writeln('│    Укажите путь к файлу, который содержит записанные выражения              │');
    writeln('│                                                                             │');
    writeln('│    Например: file.txt                                                       │');
    writeln('│                                                                             │');
    writeln('│    Формат файла должен быть следующий:  Некое выражение_1                   │');
    writeln('│                                         Некое выражение_2                   │');
    writeln('│                                         ...                                 │');
    writeln('│                                         Некое выражение_n                   │');
    writeln('│                                                                             │');
    writeln('│                                                                             │');
    Write('│->Ввод:     ');
    Readln(InputString);
    writeln('└─────────────────────────────────────────────────────────────────────────────┘');

    //Associate
    Assign(InputFile, InputString);
    Assign(OutFile, InputString + '_RESULT.txt');
    {$I-}
    reset(InputFile);
    rewrite(OutFile);
    {$I+}

    if IOresult <> 0 then
    begin
      ErrorDialog('Произошла ошибка при работе с файлами');
      readln();
      exit;
    end;

    writeln;
    writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
    writeln('│                         Результаты ввода из файла                           │');
    writeln('│                                                                             │');

    while (not (EOF(InputFile))) do
    begin
      readln(InputFile, InputString);
      CheckIn(Preprocessor(InputString));
      MemoryR := Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring)));
      MemoryI := Round(Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring))));
      Write('│-> Целая форма: ');
      Write(MemoryI);
      Write('  Вещественная форма:');
      Write(MemoryR);
      str(MemoryR, smem);
      str(MemoryI, smemi);
      writeln(OutFile, InputString + ' = ' + smem + ' = ' + smemi);
      smem := '';
      smemi := '';
      writeln;
    end;
    writeln('│                                                                             │');
    writeln('│                         Результаты записаны в файл _RESULT.txt              │');
    writeln('└─────────────────────────────────────────────────────────────────────────────┘');

    Close(InputFile);
    Close(OutFile);
    readln();
  end;

  procedure DialogMenu;

  begin
    Postfixtoreal(Infixtopostfix('1'));
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
      writeln('│ ~ 3, если вам нужна помощь                                                  │');
      writeln('│                                                                             │');
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
          writeln;
          writeln('┌─────────────────────────────────────────────────────────────────────────────┐');
          writeln('│                                                                             │');
          writeln('│    Введите математическое выражение. Числа должны вводиться через пробел    │');
          writeln('│                                                                             │');
          writeln('│    Например: (5+2)/2-4*3                                                    │');
          writeln('│                                                                             │');
          writeln('│    Для удобства почитайте полную инструкцию к эксплуатации программы        │');
          writeln('│                                                                             │');
          Write('│->Ввод:     ');
          Read(InputString);
          CheckIn(Preprocessor(InputString));
          ReadLN(MemC);
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
          MemoryR := Postfixtoreal(Infixtopostfix(Preprocessor(Inputstring)));


          //Если
          case memO of
            '+': MemoryR := MemoryR + cache;
            '-': MemoryR := cache - MemoryR;
            '*': MemoryR := MemoryR * cache;
            '/': MemoryR := cache / MemoryR;
          end;

          //Округляем
          MemoryI := Round(MemoryR);

          writeln(MemoryI);
          writeln('│                                                                             │');
          writeln('│В вещественной форме:                                                        │');
          writeln(
            '│                                                                             │');
          Write('│>>>  ');
          writeln(MemoryR: 0: 2);


          readln();
          clrscr;
        end;
        '2': WorkWithFile;
        '3': Help;
        '0':
          halt(-1);
        else
          ErrorDialog('Введено некорректное значение!');
      end;
    end;
  end;



begin
  //Инициализация стеков
  Head_C := nil;
  Head := nil;

  //Прекомпилирующие функции
  Functions_IN[1] := 'sin';
  Functions_IN[2] := 'cos';
  Functions_IN[3] := 'tg';
  Functions_IN[4] := 'ctg';
  Functions_IN[5] := 'ln';
  Functions_IN[6] := 'p';
  Functions_IN[7] := 'e';
  Functions_IN[8] := '|';
  Functions_IN[9] := 'sqrt';
  Functions_OUT[1] := 's';
  Functions_OUT[2] := 'c';
  Functions_OUT[3] := 't';
  Functions_OUT[4] := 'g';
  Functions_OUT[5] := 'l';
  Functions_OUT[6] := '314159265358/100000000000';
  Functions_OUT[7] := '271828182845/100000000000';
  Functions_OUT[8] := '+';
  Functions_OUT[9] := 'q';
  //Вызываем диалоговое меню
  DialogMenu();
end.
