unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus;

const
  usednums: set of char = ['A'..'Z', '0', '1'];
  //Буквы, которые мы юзаем
  usingnums: set of char = ['0', '1'];
  usingoperators: set of char = ['+', '*', '/', '^', '=', '!', ';'];

type

  { Tmain_form }
  //Структура стек
  Stack = ^Node;

  Node = record
    Data: boolean;
    Next: Stack;
  end;

  C_Stack = ^CNode;

  CNode = record
    Data: char;
    Next: C_Stack;
  end;

  Tmain_form = class(TForm)
    main_menu: TMainMenu;
    main_menu_file: TMenuItem;
    main_menu_file_exit: TMenuItem;
    main_menu_help: TMenuItem;
    main_popup_save: TMenuItem;
    input_open: TMenuItem;
    Main_Open: TOpenDialog;
    sknf_save: TMenuItem;
    sdnf_open: TMenuItem;
    menu_menu_help_author: TMenuItem;
    menu_menu_help_help: TMenuItem;
    menu_menu_help_source: TMenuItem;
    Matrix_popup: TPopupMenu;
    Main_Save: TSaveDialog;
    SDNF_DIALOG: TPopupMenu;
    SKNF_DIALOG: TPopupMenu;
    INPUT_DIALOG: TPopupMenu;
    sdnf_text: TEdit;
    sknf_text: TEdit;
    main_sdnf: TLabel;
    main_createtable: TButton;
    main_sdnf_lb: TLabel;
    main_sknf: TLabel;
    main_input: TEdit;
    main_sknf_lb: TLabel;
    main_table: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure input_openClick(Sender: TObject);
    procedure main_createtableClick(Sender: TObject);
    procedure main_menu_file_exitClick(Sender: TObject);
    procedure main_popup_saveClick(Sender: TObject);
    procedure menu_menu_help_authorClick(Sender: TObject);
    procedure menu_menu_help_helpClick(Sender: TObject);
    procedure menu_menu_help_sourceClick(Sender: TObject);
    procedure sdnf_openClick(Sender: TObject);
    procedure sknf_saveClick(Sender: TObject);
  private

  public

  end;

var
  main_form: Tmain_form;
  Reg: array[0..25] of boolean; //Хранит переменные
  Head: Stack;
  Head_C: C_Stack;

implementation

uses
  about, Source, help;

{$R *.lfm}

{ Tmain_form }

{СТЕКИ}
procedure AddToStack(var H: Stack; d: boolean);
var
  Temp: Stack;
begin
  new(Temp);
  Temp^.Data := d;
  Temp^.Next := H;
  H := Temp;

end;

function GetElementFromStack(var H: Stack): boolean;
var
  R: boolean;
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
    //ShowMessage('#2');
  end;
end;

procedure char_AddToStack(var H: c_stack; Data: char);
var
  Temp: C_Stack;
begin
  new(Temp);
  Temp^.Data := Data;
  Temp^.Next := H;
  H := Temp;
end;

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
    ShowMessage('Что-то пошло не так #1');
  end;
end;

{#Is empty stack}
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

{Конец стеков}


//Даём букву, возвращает индекс
function GetValueBySymbol(sym: char): integer;
begin
  Result := Ord(sym) - 65;
end;

function GetSymByNum(sym: integer): char;
begin
  Result := Chr(sym + 65);
end;

function ton(k: integer): integer;
var
  i: integer;
  r: integer;
begin
  R := 1;
  for i := 1 to k do
  begin
    R := R * 2;
  end;
  Result := R;
end;

procedure clearReg();
var
  i: integer;
begin
  for i := 0 to 25 do
  begin
    Reg[i] := False;
  end;
end;

function GetPriority(operators: char): integer;
begin
  case operators of
    '/': Result := 4;
    '*', '!': Result := 3;
    '+', '^', ';': Result := 2;
    '=': Result := 1;
    '(', ')': Result := 0;
  end;
end;

{#Infix to postfix}
function InfixToPostfix(input: string): string;
var
  C, Z: integer;
  K, T, P: char;
  postfix: string;
begin
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
    else if (k in usednums) then
    begin
      postfix := postfix + k;
      postfix := postfix + ' ';
    end
    else if (k in UsingOperators) then
    begin
      T := K; //Select current in T;
      P := char_GetElementFromStack(Head_C);
      Z := GetPriority(T);
      while (Z <= GetPriority(P)) do
      begin
        postfix := postfix + P + ' ';
        P := char_GetElementFromStack(Head_C);
      end;
      char_AddToStack(Head_C, P);
      char_AddToStack(Head_C, T);
      //End
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

//Функция конвертирования постфиксного булевского выражения в BOOL
function PostFixToBool(inval: string): boolean;
var
  x, y: boolean;
  C: integer;
  TMP, BUFFER: string;
  Sym: char;
begin
  TMP := inval + '9';
  C := 1;
  while (TMP[C] <> '9') do
  begin
    Sym := TMP[C];
    if (Sym in UsingNums) then
    begin
      while ((Sym <> ' ') and (not (Sym in UsingOperators))) do
      begin
        BUFFER := BUFFER + Sym;
        Inc(C);
        Sym := TMP[C];
      end;
      if (BUFFER = '1') then
        AddToStack(Head, True)
      else
        AddToStack(Head, False);
      BUFFER := '';
      C := C - 1;
    end
    else if (Sym in UsingOperators) then
    begin
      case Sym of
        '*':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          x := x and y;
          AddToStack(Head, x);
        end;
        '+':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          x := x or y;
          AddToStack(Head, x);
        end;
        '/':
        begin
          x := GetElementFromStack(Head);
          x := not (x);
          AddToStack(Head, x);
        end;
        '^':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          x := x xor y;
          AddToStack(Head, x);
        end;
        '=':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          y := not (x xor y);
          AddToStack(Head, y);
        end;
        ';':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          x := not (y or x);
          AddToStack(Head, x);
        end;
        '!':
        begin
          x := GetElementFromStack(Head);
          y := GetElementFromStack(Head);
          x := not (y and x);
          AddToStack(Head, x);
        end;
      end;
    end;

    Inc(C);
  end;
  Result := GetElementFromStack(Head);
end;

function DeleteStr(str: string; what: string): string;
var
  i: integer;
  sym: string;
  sys: string;
begin
  sys := str;
  sym := what;
  while pos(sym, sys) <> 0 do
  begin
    Delete(sys, pos(sym, sys), length(sym));
  end;
  Result := sys;
end;

function precheck(str: string): boolean;
var
  brackets, i: integer;
  symbols: set of char = ['(', ')', '+', '/', '^', '!', '*', ';', '='];
  opers: set of char = ['+', '^', '!', '*', ';', '='];
  brack: set of char = ['(', ')'];
  alphabet: set of char = ['A'..'Z'];
  metka: boolean;
  c: char;
  sys: string;
begin
  brackets := 0;
  if (str <> '') then
  begin
    sys := DeleteStr(str, ' ');
    sys := sys + '#';
    for i := 1 to sys.length do
    begin
      c := sys[i];
      //К какому классу относится символ?

      //Дополнительно
      if ((c in alphabet) and (i <> 1) and (sys[i-1] = ')')) then begin
         ShowMessage('Ошибка! Вы забыли оператор после закрывающей скобки');
         metka := True;
         break;
      end;
      if (c in symbols) then
      begin {Если оператор}
        if (sys[i + 1] <> '#') then
        begin
          if (c in brack) then
          begin //Если это открывающая или закрывающая скобки
            if (c = '(') then
            begin
              Inc(brackets);
            end
            else if ((c = ')') and (sys[i + 1] <> '(')) then
            begin //если такой штуки нет (A+B)(B+C)
              Dec(brackets);
            end
            else
            begin
              ShowMessage(c +
                ' Ошибка! Где оператор после закрывающей скобки!');
              metka := True;
              break;
            end;
          end
          else if (c = '/') then
          begin //Если символ отрицания,то там свои задачи
            if ((i <> 1)) then
            begin
              if ((sys[i - 1] = ')') or (sys[i + 1] in opers) or (sys[i + 1] = ')')) then
              begin // )/A, /+A, (A+/)
                ShowMessage(
                  'Пользователь...Не пиши отрицание после скобки или отрицание оператора');
                metka := True;
                break;
              end
              else if (sys[i + 1] = '/') then  // //..A
              begin
                ShowMessage(
                  'Неправильно...Для 2x и более отрицаний использовать скобки. Например, /(/A))');
                metka := True;
                break;
              end;

            end
            else
            begin
              if (sys[i + 1] = '/') then
              begin
                ShowMessage(
                  '(2) Неправильно...Для 2x и более отрицаний использовать скобки. Например, /(/A))');
                metka := True;
                break;
              end;
            end;
          end
          else
          begin //Если символ есть нормальный оператор
            if (i <> 1) then
            begin
              if ((sys[i + 1] in opers) or (sys[i + 1] = ')')) then //++A, A++, (A+)
              begin
                ShowMessage(
                  'Ошибка! Несколько бинарных операторов достаточно зазорно. Также проверьте, не стоит ли бинарный оператор сразу перед закрывающей скобкой');
                metka := True;
                break;
              end;

            end
            else
            begin
              ShowMessage(
                'Ошибка! Бинарный оператор просто сначала...Зазорно');
              metka := True;
              break;
            end;
          end;
        end
        else
        begin
          if (sys[i] <> ')') then  // +#
          begin
            ShowMessage('Где что-то после последнего оператора???!');
            metka := True;
            break;
          end
          else
          begin
            Dec(brackets);
            metka := False;
          end;
        end;
      end
      else if (c in alphabet) then
      begin {Если аргумент, то делаем проверки вида: A<operator>}
        if (sys[i + 1] <> '#') then
        begin
          if ((sys[i + 1] in opers) or ((sys[i + 1] = ')') and (brackets - 1 >= 0))) then
            //A+(B+C)
          begin  //Если следующее является оператором, то всё хорошо
            metka := False;
          end
          else if (sys[i + 1] in alphabet) then  //AA
          begin //Если вдруг ещё буква, то ввод некорректный
            metka := True;
            ShowMessage(
              'Ошибка! Параметр после параметра недопустимы');
            break;
          end
          else if (sys[i+1]='(') then begin // A(
            ShowMessage('Ошибка! Вы упустили оператор перед открывающей скобкой');
            metka := True;
            break;
          end
          else
          begin
            metka := True;
            ShowMessage(
              'Ошибка! Наблюдается ересь!');
            ShowMessage(c);
            break;
          end;

        end
        else
        begin
          metka := False;
          break;
        end;
      end
      else
      begin
        if (c <> '#') then
        begin
          ShowMessage(
            'В выражении используются некорректные символы!');
          metka := True;
          break;
        end;
      end;
    end;

    if ((metka = False) and (brackets = 0)) then
      Result := True
    else
      Result := False;

  end
  else
  begin
    Result := False;
    ShowMessage('Строка пустая!');
  end;
end;

function STOS(var s: string): string;
const
  small = ['a'..'z'];
var
  i: integer;
begin
  for i := 1 to length(s) do
    if s[i] in small then
      s[i] := chr(Ord(s[i]) - Ord('a') + Ord('A'));
  Result := s;
end;

procedure SDSKNF(table: TStringGrid; SDNF, SKNF: TLabel);
var
  i, j, k: integer;
  s: string;
begin
  k := table.ColCount - 1;
  for i := 1 to table.RowCount - 1 do
  begin
    if (table.Cells[k, i] = '1') then
    begin
      SDNF.Caption := SDNF.Caption + '( ';
      for j := 0 to k - 1 do
      begin
        if table.Cells[j, i] = '1' then
        begin
          SDNF.Caption := SDNF.Caption + table.Cells[j, 0];
          if (j < k - 1) then
            SDNF.Caption := SDNF.Caption + ' * ';
        end
        else
        begin
          SDNF.Caption := SDNF.Caption + ' /' + table.Cells[j, 0];
          if (j < k - 1) then
            SDNF.Caption := SDNF.Caption + ' * ';
        end;
      end;
      SDNF.Caption := SDNF.Caption + ' )+';
    end
    else
    begin
      SKNF.Caption := SKNF.Caption + '( ';
      for j := 0 to k - 1 do
      begin
        if table.Cells[j, i] = '1' then
        begin
          SKNF.Caption := SKNF.Caption + '/' + table.Cells[j, 0];
          if (j < k - 1) then
            SKNF.Caption := SKNF.Caption + ' + ';
        end
        else
        begin
          SKNF.Caption := SKNF.Caption + table.Cells[j, 0];
          if (j < k - 1) then
            SKNF.Caption := SKNF.Caption + ' + ';
        end;
      end;
      SKNF.Caption := SKNF.Caption + ' )*';
    end;
  end;

  //Удаляем мусор с конца
  s := SDNF.Caption;
  Delete(s, s.length, 1);
  SDNF.Caption := s;
  s := SKNF.Caption;
  Delete(s, s.length, 1);
  SKNF.Caption := s;
end;

procedure GetRez(table: TStringGrid; str: string);
var
  SYM, GYM, ST: string;
  C, G: char;
  i, j, K, R, E: integer;
begin
  ST := str;
  R := 0;
  if (table.ColCount <= 2) then
    K := table.ColCount - 2
  else
    K := table.ColCount - 2;

  //From 0 to K
  for j := 1 to table.RowCount - 1 do
  begin
    for i := 0 to K do
    begin
      SYM := table.Cells[i, 0];
      C := SYM[1];
      GYM := table.Cells[i, j];
      G := GYM[1];
      R := GetValueBySymbol(C);
      //Имеем буль и букву - делаем в исходной строке замену
      while (pos(GetSymByNum(R), ST) <> 0) do
      begin
        E := pos(GetSymByNum(R), ST);
        Delete(ST, E, 1);
        insert(G, ST, E);
      end;
    end;
    if (Postfixtobool((InfixToPostfix(ST))) = True) then
      G := '1'
    else
      G := '0';
    table.Cells[table.ColCount - 1, j] := G;
    ST := str;
  end;
end;

procedure WriteToFile(Table: TStringGrid; Dialog: TSaveDialog);
var
  Fl: textfile;
  i, j: integer;
begin
  if ((Dialog.Execute) and (Dialog.FileName <> '')) then
  begin
    AssignFile(Fl, Dialog.FileName);
      {$I-}
    rewrite(Fl);
      {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      exit;
    end;

    for i := 0 to Table.RowCount - 1 do
    begin
      for j := 0 to Table.ColCount - 1 do
      begin
        Write(Fl, Table.Cells[j, i]);
        Write(Fl, ' ');
      end;
      Writeln(Fl, '');
    end;
    closeFile(Fl);
  end;
end;

procedure WriteStrToFile(str: string; Dialog: TSaveDialog);
var
  Fl: textfile;
  i, j: integer;
begin
  if ((Dialog.Execute) and (Dialog.FileName <> '')) then
  begin
    AssignFile(Fl, Dialog.FileName);
        {$I-}
    rewrite(Fl);
        {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      exit;
    end;

    Writeln(Fl, str);
    closeFile(Fl);
  end;
end;

procedure Tmain_form.main_createtableClick(Sender: TObject);
var
  i, j, k, t, v, e, P: integer;
  buffer: string;
  flag: boolean;
begin
  buffer := main_input.Text;
  buffer:= DeleteStr(buffer,' ');
  main_input.Text:= buffer;
  clearReg();
  if precheck(buffer) <> True then
  begin
    ShowMessage('Некорректный ввод');
    exit;
  end
  else
  begin
    main_sdnf.Caption := '';
    main_sknf.Caption := '';
    main_table.RowCount := 1;
    main_table.ColCount := 1;
    K := 0;
    j := 0;
    //Первая часть задачи - посчитать количество букв, которы мы имеем
    for i := 1 to buffer.Length do
    begin
      if (buffer[i] in usednums) then
      begin
        if (Reg[GetValueBySymbol(buffer[i])] <> True) then
        begin
          Reg[GetValueBySymbol(buffer[i])] := True;
          Inc(k);
        end;
      end;
    end;
    k := ton(k);
    P := k;
    main_table.RowCount := main_table.RowCount + k;
    //Вторая часть задачи - строим таблицу истиности
    for i := 0 to 25 do
    begin
      if (Reg[i] = True) then
      begin
        main_table.ColCount := main_table.ColCount + 1;
        main_table.Cells[j, 0] := GetSymByNum(i);
        //Теперь переходим к заполнению столбца
        flag := True;
        e := 1;
        k := k div 2;
        v := 0;
        //Заполняем таблицу
        for t := 0 to P - 1 do
        begin
          if (v = k) then
          begin
            v := 0;
            flag := not (flag);
          end;
          if flag = True then
          begin
            main_table.Cells[j, e] := '1';
          end
          else
          begin
            main_table.Cells[j, e] := '0';
          end;
          Inc(e);
          Inc(v);
        end;
        Inc(j);
      end;
    end;
    //Третья часть задачи - подставляем заполненную таблицу в выражение
    //Переводим инфиксное выражение со значениями в постфиксное
    main_table.Cells[main_table.ColCount - 1, 0] := buffer;
    getrez(main_table, buffer);
    SDSKNF(main_table, main_sdnf, main_sknf);
    sdnf_text.Text := main_sdnf.Caption;
    sknf_text.Text := main_sknf.Caption;
  end;
end;

procedure Tmain_form.main_menu_file_exitClick(Sender: TObject);
begin
  main_form.Close;
end;

procedure Tmain_form.main_popup_saveClick(Sender: TObject);
begin
  WriteToFile(main_table, Main_Save);
end;

procedure Tmain_form.menu_menu_help_authorClick(Sender: TObject);
begin
  about.form_author.Show;
end;

procedure Tmain_form.menu_menu_help_helpClick(Sender: TObject);
begin
  help.form_help.Show;
end;

procedure Tmain_form.menu_menu_help_sourceClick(Sender: TObject);
begin
  Source.form_source.Show;
end;

procedure Tmain_form.sdnf_openClick(Sender: TObject);
begin
  WriteStrToFile(sdnf_text.Text, Main_Save);
end;

procedure Tmain_form.sknf_saveClick(Sender: TObject);
begin
  WriteStrToFile(sknf_text.Text, Main_Save);
end;

procedure Tmain_form.FormCreate(Sender: TObject);
begin
  Application.Title := 'Таблица истиности';
  PostfixToBool(InfixToPostfix('1'));
end;

procedure Tmain_form.input_openClick(Sender: TObject);
var
  Fl: textfile;
  s: string;
begin
  if ((Main_Open.Execute) and (Main_Open.FileName <> '')) then
  begin
    AssignFile(Fl, Main_Open.FileName);
        {$I-}
    reset(Fl);
        {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      exit;
    end;

    Readln(Fl, s);
    main_input.Text := s;
    closeFile(Fl);
  end;
end;

end.
