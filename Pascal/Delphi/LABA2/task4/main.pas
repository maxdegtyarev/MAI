unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Spin,
  StdCtrls, Menus;

const
  n = 1000; //Допустимый размер матрицы

type
  matrix = array[0..n, 0..n] of real;
  matrixs = array[0..n] of real;
  { Tmain_form }

  Tmain_form = class(TForm)
    getr: TButton;
    input_cols: TSpinEdit;
    input: TStringGrid;
    Main_open: TOpenDialog;
    MatrixMenu: TPopupMenu;
    menu_load: TMenuItem;
    menu_save: TMenuItem;
    Main_Save: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure getrClick(Sender: TObject);
    procedure input_colsChange(Sender: TObject);
    procedure menu_loadClick(Sender: TObject);
    procedure menu_saveClick(Sender: TObject);
  private

  public

  end;

var
  main_form: Tmain_form;
  coefs: matrix;
  svchlen: matrixs;
  resh: matrixs;
  per: real;
  u: integer;

implementation

{$R *.lfm}

{ Tmain_form }

procedure ReadFromFile(Table: TStringGrid; Dialog: TOpenDialog);
var
  onums: set of char = ['0'..'9', ',', 'e', '-'];
  Fl: textfile;
  str, BUFFER: string;
  i, j, k: integer;
  metka: boolean;
begin
  if ((Dialog.Execute) and (Dialog.FileName <> '')) then
  begin
    AssignFile(Fl, Dialog.FileName);
      {$I-}
    reset(Fl);
      {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      exit;
    end;
    k := 0;
    j := 0;
    metka := False;
    TABLE.ColCount := 0;
    Table.RowCount := 0;
    BUFFER := '';
    while (not EOF(Fl)) do
    begin
      buffer := '';
      readln(Fl, str);
      // ShowMessage(str);
      table.RowCount := Table.RowCount + 1;
      for i := 1 to str.length do
      begin
        if ((str[i] = ' ')) then
        begin
          if (metka = False) then
          begin
            Table.ColCount := Table.ColCount + 1;
          end;
          Table.Cells[j, k] := BUFFER;
          Inc(j);
          if (j >= table.ColCount) then
            j := 0; //На случай исключений
          buffer := '';
        end
        else if (str[i] in onums) then
        begin
          buffer := buffer + str[i];
        end
        else
          break;
      end;
      Table.Cells[j, k] := BUFFER; //ShowMessage(BUFFER);
      Inc(k);
      j := 0;
      metka := True;
    end;
    closefile(Fl);
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
      Writeln(Fl,'');
    end;
  end;
end;

//Функция проверки вводимого числа. Вернёт False при возникновении ошибки
function PreCheck(ins: string): boolean;
const
  elength = 35; //Максимальная степень ешки
var
  nums: set of char = ['0'..'9', '-', 'e', ',', '#'];
  onums: set of char = ['0'..'9'];
  NCFLAG: boolean;
  BUFFER: string;
  //То, что по своей природе может иметь запись числа
  minuses, eses, punks, i, j: integer; //Количество минусов
begin
  if (ins <> '') then
  begin
    BUFFER := '';
    NCFLAG := False;
    minuses := 0;
    eses := 0;
    punks := 0;
    ins := ins + '#';
    for i := 1 to ins.Length do
    begin
      if not (ins[i] in nums) then
      begin
        NCFLAG := True;
      end
      else
      begin
        //Если минус, то проверяем, чтоб слева ничего не было, а справа было число
        if (ins[i] = '-') then
        begin
          if ((i = 1) and (ins[i + 1] <> '#')) then
            Inc(minuses)
          else
            NCFLAG := True;
        end
        else if (ins[i] = '#') then
          break
        else if (ins[i] = ',') then
        begin
          if (i > 1) then
          begin
            if ((ins[i - 1] in onums) and (ins[i + 1] in onums)) then
              Inc(punks)
            else
              NCFLAG := True;
          end
          else
            NCFLAG := True;
        end
        else if (ins[i] = 'e') then
        begin
          //Тут свой подход. После ешки не должно быть числа больше ограничения + не должно быть запятых
          if ((i > 1) and (ins[i] <> '#')) then
          begin
            if ((ins[i - 1] in onums) and (ins[i + 1] in onums)) then
            begin
              Inc(eses);
              for j := i + 1 to ins.Length do
              begin
                if ((ins[j] in onums)) then
                begin
                  BUFFER := BUFFER + ins[j];
                end
                else if (ins[j] = '#') then
                  break
                else
                begin
                  NCFLAG := True;
                  break;
                end;
              end;
              if (StrToInt(BUFFER) > elength) then
              begin
                NCFLAG := True;
                break;
              end;
            end
            else
              NCFLAG := True;
          end
          else
            NCFLAG := True;
        end;
      end;
    end;
    //ShowMessage(IntToStr(eses) + ' ' + IntToStr(minuses) + ' ' + IntToStr(punks));
    if ((eses <= 1) and (minuses <= 1) and (punks <= 1) and (NCFLAG <> True)) then
      Result := True
    else
      Result := False;
  end
  else
    Result := False;
end;

function Dete(matr: matrix): real;
var
  current, tmp, res: real;
  determ, i, j, k, l, m, n: integer;
begin
  res := 1;
  for i := 1 to u - 1 do
  begin
    if matr[i][i] = 0 then
      res := res * (-1);
    determ := i;
    while (matr[determ][i] = 0) and (determ <= u - 1) do
      Inc(determ);
    if determ > u - 1 then
    begin
      res := 0;
      break;
    end;
    for j := 1 to u - 1 do
    begin
      tmp := matr[i][j];
      matr[i][j] := matr[determ][j];
      matr[determ][j] := tmp;
    end;
    for k := i + 1 to u - 1 do
    begin
      current := matr[k][i] / matr[i][i];
      for j := i to u - 1 do
      begin
        matr[k][j] := matr[k][j] - matr[i][j] * current;
      end;
    end;
    res := res * matr[i][i];
  end;
  res := res * matr[u - 1][u - 1];
  ShowMessage(FloatToStr(res));
end;

procedure GaossPrecheck(a: matrix; b: matrixs);
begin

end;

procedure Gaoss(a: matrix; b: matrixs; x: matrixs);
var
  max, temp, pogr: real;
  i, k, j, index: integer;
begin
  pogr := 0.0000001;
  //Точность, которую мы будем сверять для выхода из цикла в дальшейшем
  k := 0;
  //Шаг один - выделяем строку с максимальным a[i][k]
  while (k < u) do
  begin
    max := a[k][k];
    index := k;
    for i := k + 1 to u - 1 do
    begin
      if (a[i][k] > max) then
      begin
        max := abs(a[i][k]);
        index := i;
      end;
    end;
    //Подготовка к перестановке строк матрицы
    if (max < pogr) then
    begin
      //ShowMessage(floattostr(index));
      //exit;
    end;
    for j := 0 to u - 1 do
    begin
      temp := a[k][j];
      a[k][j] := a[index][j];
      a[index][j] := temp;
    end;
    temp := b[k];
    b[k] := b[index];
    b[index] := temp;
    for i := k to u - 1 do
    begin
      temp := a[i][k];
      if (abs(temp) < pogr) then
        continue;
      for j := 0 to u - 1 do
      begin
        a[i][j] := a[i][j] / temp;
      end;
      b[i] := b[i] / temp;
      if (i = k) then
        continue;
      //Чтоб уравнение не вычло само себя самостоятельно
      for j := 0 to u - 1 do
      begin
        a[i][j] := a[i][j] - a[k][j];
      end;
      b[i] := b[i] - b[k];
    end;
    Inc(k);
  end;

  //Преобразования сделали - выполним подстановки из полученного
  k := u - 1;
  while (k >= 0) do
  begin
    x[k] := b[k];
    for i := 0 to k - 1 do
    begin
      b[i] := b[i] - a[i][k] * x[k];
    end;
    Dec(k);
  end;

  for i := 0 to u - 1 do
  begin
    ShowMessage(FloatToStr(x[i]));
  end;

end;

procedure Tmain_form.FormCreate(Sender: TObject);
begin
  input.ColCount := input_cols.Value;
  input.RowCount := input_cols.Value;
  u := 1;

end;

procedure Tmain_form.getrClick(Sender: TObject);
var
  i, j: integer;
  kek: boolean;
begin
  kek := False;
  //Заполняем матрицы
  for i := 0 to u - 1 do
  begin
    for j := 0 to u - 1 do
    begin
      if (Precheck(input.Cells[j, i]) <> False) then
      begin
        coefs[i, j] := StrToFloat(input.Cells[j, i]);
      end
      else
      begin
        kek := True;
        break;
      end;
    end;
    if (Precheck(input.Cells[Input.ColCount - 1, i]) <> False) then
    begin
      // svchlen[i] := StrToFloat(input_s.Cells[0, i]);
      svchlen[i] := StrToFloat(input.Cells[Input.ColCount - 1, i]);
    end
    else
    begin
      kek := True;
      break;
    end;
  end;

  if (kek <> True) then
  begin
    Gaoss(coefs, svchlen, resh);
    Dete(coefs);
  end
  else
    ShowMessage('Ошибка ввода');
end;

procedure Tmain_form.input_colsChange(Sender: TObject);
begin
  input.ColCount := input_cols.Value + 1;
  input.RowCount := input_cols.Value;
  u := input.ColCount - 1;
end;

procedure Tmain_form.menu_loadClick(Sender: TObject);
begin
  input.ColCount := 0;
  input.RowCount := 0;
  u := 0;
  ReadFromFile(input, Main_open);
  Input_Cols.Value := input.RowCount;
  u := input.RowCount;
  input.ColCount := u + 1;
  input.RowCount := u;
end;

procedure Tmain_form.menu_saveClick(Sender: TObject);
begin
  WriteToFile(input, Main_Save);
end;

end.
