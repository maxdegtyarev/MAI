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

type
  Node = ^Stack;

  Stack = record
    Data: integer;
    NextElement: ^Node;
  end;

var
  FD: real;
  InputCommand: string;
  InputString: string;




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
    writeln('0, для выхода из программы');
    write('Ввод:');
    readln(InputCommand);
    case InputCommand of
      '1':
      begin
        clrscr;
        writeln('');
        write('Введите математическое выражение: ');
        read(InputString);
        writeln(toR(InputString));
        readln();
        readln();
        clrscr;
      end;
      '0':
        halt(0);
      else writeln('Некорректный ввод!');
    end;
  end;
end.
