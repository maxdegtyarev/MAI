unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Spin,
  StdCtrls, Menus;

const
  MATR_MAX_SIZE = 99;

type
  Matrix = array[0..MATR_MAX_SIZE, 0..MATR_MAX_SIZE] of real;
  { Tform_Main }

  Tform_Main = class(TForm)
    button_umn: TButton;
    button_min: TButton;
    button_sum: TButton;
    checkbox_priv: TCheckBox;
    main_menu: TMainMenu;
    main_menu_file: TMenuItem;
    main_menu_file_exit: TMenuItem;
    main_menu_help: TMenuItem;
    matrix1_u: TSpinEdit;
    matrix1_v: TSpinEdit;
    matrix2: TStringGrid;
    matrix2_v: TSpinEdit;
    matrix2_v1: TSpinEdit;
    matrix3: TStringGrid;
    matrix1: TStringGrid;
    matr_opendialog: TOpenDialog;
    matr_savedialog: TSaveDialog;
    menu_menu_help_author: TMenuItem;
    menu_menu_help_help: TMenuItem;
    menu_menu_help_source: TMenuItem;
    popup_matrix1_open: TMenuItem;
    popup_matrix2_open2: TMenuItem;
    popup_matrix1_save: TMenuItem;
    popup_matrix1: TPopupMenu;
    popup_matrix3_open3: TMenuItem;
    popup_matrix2_save2: TMenuItem;
    popup_matrix2: TPopupMenu;
    popup_matrix3: TPopupMenu;
    procedure button_minClick(Sender: TObject);
    procedure button_sumClick(Sender: TObject);
    procedure button_umnClick(Sender: TObject);
    procedure checkbox_privChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure main_menu_file_exitClick(Sender: TObject);
    procedure matrix1_uChange(Sender: TObject);
    procedure matrix1_vChange(Sender: TObject);
    procedure matrix2_v1Change(Sender: TObject);
    procedure matrix2_vChange(Sender: TObject);
    procedure menu_menu_help_authorClick(Sender: TObject);
    procedure menu_menu_help_helpClick(Sender: TObject);
    procedure menu_menu_help_sourceClick(Sender: TObject);
    procedure popup_matrix1_openClick(Sender: TObject);
    procedure popup_matrix1_saveClick(Sender: TObject);
    procedure popup_matrix2_open2Click(Sender: TObject);
    procedure popup_matrix2_save2Click(Sender: TObject);
    procedure popup_matrix3_open3Click(Sender: TObject);
    //function precheck():integer;
  private

  public

  end;

var
  form_Main: Tform_Main;
  matr1, matr2, res: matrix;
  n, m, k, v: integer;
  fv, fv2: boolean;

implementation

uses
  about, Source, help;

{$R *.lfm}
function Repl(ins: string; ch1, ch2: string): string;
var
  s:string;
  i:integer;

begin
  s:= ins;
  while (pos(ch1,s)<>0) do
  begin
    i:=pos(ch1,s);
    delete(s,i,ch1.length);
    insert(ch2,s,i);
  end;
  result:= s;
end;

{ Tform_Main }
//Функция проверки вводимого числа. Вернёт False при возникновении ошибки
function PreCheck(ins: string): boolean;
const
  elength = 150; //Максимальная степень ешки
var
  nums: set of char = ['0'..'9', '-', 'e', 'E', ',', '#'];
  onums: set of char = ['0'..'9'];
  NCFLAG: boolean;
  BUFFER: string;
  //То, что по своей природе может иметь запись числа
  minuses, minuses_e, k, eses, punks, i, j: integer; //Количество минусов
begin
  //Предварительное удаление точек, замена их на запятые
  ins:= Repl(ins,'.',',');

  if (ins <> '') then
  begin
    BUFFER := '';
    NCFLAG := False;
    minuses := 0;
    eses := 0;
    punks := 0;
    minuses_e := 0;
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
          else if ((i <> 1) and (ins[i + 1] <> '#') and (eses = 1) and
            ((ins[i - 1] = 'e') or (ins[i - 1] = 'E'))) then
            Inc(Minuses_e)
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
        else if ((ins[i] = 'e') or (ins[i] = 'E')) then
        begin
          //Тут свой подход. После ешки не должно быть числа больше ограничения + не должно быть запятых
          if ((i > 1) and (ins[i] <> '#')) then
          begin
            if ((ins[i - 1] in onums) and ((ins[i + 1] in onums) or
              (ins[i + 1] = '-'))) then
            begin
              Inc(eses);
              for j := i + 1 to ins.Length do
              begin
                if (((ins[j] in onums) or (ins[j] = '-'))) then
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
              if (precheck(BUFFER) = False) then
              begin
                NCFLAG := True;
                BUFFER := '1';
              end;
              if (StrToFloat(BUFFER) > elength) then
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
    if ((eses <= 1) and (minuses <= 1) and (minuses_e <= 1) and
      (punks <= 1) and (NCFLAG <> True)) then
      Result := True
    else
      Result := False;
  end
  else
    Result := False;
end;

//функция перегона данных из матрицы в двумерный массив. Передаём пример
procedure getMatrFromMatrix(var from: TStringGrid; var ato: Matrix);
var
  dm, col, row, i, j: integer;
  metka: boolean;//Строк и столбцов матрицы
begin
  metka := False;
  //Препроверка матрицы
  col := from.ColCount;
  row := from.RowCount;
  for i := 0 to col - 1 do
  begin
    for j := 0 to row - 1 do
    begin
      if ((precheck(from.Cells[i, j]) <> True)) then
      begin
        ShowMessage('Некорректный ввод. Произведена замена нулями');
        metka := True;
        exit;
      end;
      val(Repl(from.Cells[i, j],',','.'), ato[j, i], dm);
      if (dm <> 0) then
      begin
        ShowMessage(
          'Обработана критическая ошибка с числом. Замена на нуль при счёте');
        metka := True;
        exit;
      end;
    end;
    if metka = True then
      exit;
  end;
end;


procedure ReadFromFile(var Table: TStringGrid; Dialog: TOpenDialog);
var
  onums: set of char = ['0'..'9', ',', 'e', 'E', '-'];
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
    TABLE.ColCount := 1;
    Table.RowCount := 1;

    BUFFER := '';
    while (not EOF(Fl)) do
    begin
      buffer := '';
      readln(Fl, str);
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
  memes: string;
begin
  memes := '';
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
        memes := memes + Table.Cells[j, i] + ' ';
      end;
      Delete(memes, memes.length, 1);
      Writeln(Fl, memes);
      memes := '';
    end;
    closeFile(Fl);
  end;
end;



procedure setMatrixFromMatr(from: Matrix; var ato: TStringGrid);
var
  i, j, col, row: integer;
begin
  col := ato.ColCount;
  row := ato.RowCount;
  for i := 0 to col - 1 do
  begin
    for j := 0 to row - 1 do
    begin
      ato.Cells[i, j] := FloatToStr(from[j, i]);
    end;
  end;
end;

procedure clearAll();
var
  i, j: integer;
begin
  for i := 0 to MATR_MAX_SIZE do
  begin
    for j := 0 to MATR_MAX_SIZE do
    begin
      matr1[i, j] := 0;
      matr2[i, j] := 0;
      res[i, j] := 0;
    end;
  end;
end;

procedure Tform_Main.matrix1_uChange(Sender: TObject);
begin
  matrix1.RowCount := matrix1_u.Value;
end;

procedure Tform_Main.button_sumClick(Sender: TObject);
var
  i, j: integer;
begin
  clearAll();
  //Получаем данные в матрицы
  getMatrFromMatrix(matrix1, matr1);
  getMatrFromMatrix(matrix2, matr2);
  //Делаем основные проверки - размеры матриц должны быть одинаковые
  if ((matrix1.RowCount <> matrix2.RowCount) or (matrix1.ColCount <>
    matrix2.ColCount)) then
  begin
    ShowMessage('Размерность матриц неодинаковая! Подсчёт невозможен!');
  end
  else
  begin
    for i := 0 to matrix1.ColCount - 1 do
    begin
      for j := 0 to matrix1.RowCount - 1 do
      begin
        res[j, i] := matr1[j, i] + matr2[j, i];
      end;
    end;
  end;
  //Записываем результат в результирующую матрицу
  matrix3.ColCount := matrix1.ColCount;
  matrix3.RowCount := matrix2.RowCount;
  setMatrixFromMatr(res, matrix3);
end;

procedure Tform_Main.button_umnClick(Sender: TObject);
var
  i, j, p: integer;
begin
  clearAll();
  if (matrix1.ColCount <> matrix2.RowCount) then
  begin
    ShowMessage('Проверьте размеры матриц');
    exit;
  end;
  getMatrFromMatrix(matrix1, matr1);
  getMatrFromMatrix(matrix2, matr2);

  for i := 0 to matrix1.ColCount do
    for j := 0 to matrix2.RowCount do
    begin
      res[i, j] := 0;
      for p := 0 to matrix1.ColCount do
        res[i, j] := res[i, j] + matr1[i, p] * matr2[p, j];
    end;
  matrix3.RowCount := matrix1.RowCount;
  matrix3.ColCount := matrix2.ColCount;
  setMatrixFromMatr(res, matrix3);
end;

procedure Tform_Main.checkbox_privChange(Sender: TObject);
begin
  matrix2_v1.Enabled := not (matrix2_v1.Enabled);
end;

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  matrix1.RowCount := 1;
  matrix2.RowCount := 1;
  matrix1.ColCount := 1;
  matrix2.ColCount := 1;
end;

procedure Tform_Main.main_menu_file_exitClick(Sender: TObject);
begin
  form_main.Close;
end;

procedure Tform_Main.button_minClick(Sender: TObject);
var
  i, j: integer;
begin
  clearAll();
  //Получаем данные в матрицы
  getMatrFromMatrix(matrix1, matr1);
  getMatrFromMatrix(matrix2, matr2);
  //Делаем основные проверки - размеры матриц должны быть одинаковые
  if ((matrix1.RowCount <> matrix2.RowCount) or (matrix1.ColCount <>
    matrix2.ColCount)) then
  begin
    ShowMessage('Размерность матриц неодинаковая! Подсчёт невозможен!');
  end
  else
  begin
    for i := 0 to matrix1.ColCount - 1 do
    begin
      for j := 0 to matrix1.RowCount - 1 do
      begin
        res[j, i] := matr1[j, i] - matr2[j, i];
      end;
    end;
  end;
  //Записываем результат в результирующую матрицу
  matrix3.ColCount := matrix1.ColCount;
  matrix3.RowCount := matrix1.RowCount;
  setMatrixFromMatr(res, matrix3);
end;

procedure Tform_Main.matrix1_vChange(Sender: TObject);
begin
  matrix1.ColCount := matrix1_v.Value;
  if (checkbox_priv.Checked = True) then
    matrix2.RowCount := matrix1_v.Value;
end;

procedure Tform_Main.matrix2_v1Change(Sender: TObject);
begin
  matrix2.RowCount := matrix2_v1.Value;
end;


procedure Tform_Main.matrix2_vChange(Sender: TObject);

begin
  matrix2.ColCount := matrix2_v.Value;
end;

procedure Tform_Main.menu_menu_help_authorClick(Sender: TObject);
begin
  help.form_help.Show;
end;

procedure Tform_Main.menu_menu_help_helpClick(Sender: TObject);
begin
  about.form_about.Show;
end;

procedure Tform_Main.menu_menu_help_sourceClick(Sender: TObject);
begin
  Source.form_source.Show;
end;

procedure Tform_Main.popup_matrix1_openClick(Sender: TObject);
begin
  WriteToFile(matrix1, matr_savedialog);
end;


procedure Tform_Main.popup_matrix1_saveClick(Sender: TObject);
begin
  matrix1.RowCount := 1;
  matrix1.ColCount := 1;
  matrix1_u.Value := matrix1.RowCount;
  ReadFromFile(matrix1, matr_opendialog);
  matrix1_u.Value := matrix1.RowCount - 1;
  matrix1_v.Value := matrix1.ColCount;
  if (checkbox_priv.Checked = True) then
    matrix2.RowCount := matrix1_v.Value;
  if ((matrix1.RowCount = 2) and (matrix1.Cells[0,1] = '')) then matrix1.RowCount:= matrix1.RowCount - 1;
  //if fv = true then matrix1.ColCount:=matrix1.ColCount - matrix1.ColCount - 1;
end;

procedure Tform_Main.popup_matrix2_open2Click(Sender: TObject);
begin
  WriteToFile(matrix2, matr_savedialog);
end;

procedure Tform_Main.popup_matrix2_save2Click(Sender: TObject);
begin
  matrix2.RowCount := 1;
  matrix2.ColCount := 1;
  matrix2_v.Value := matrix2.ColCount;
  ReadFromFile(matrix2, matr_opendialog);
  matrix2.RowCount := Matrix2.RowCount - 1;
  matrix2_v.Value := matrix2.ColCount;
  if (checkbox_priv.Checked = False) then
    matrix2_v1.Value := matrix2.RowCount;
  // matrix2_v1.Value;
end;

procedure Tform_Main.popup_matrix3_open3Click(Sender: TObject);
begin
  WriteToFile(matrix3, matr_savedialog);
end;


end.
