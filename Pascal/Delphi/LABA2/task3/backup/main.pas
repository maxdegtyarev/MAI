unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Spin,
  StdCtrls;

const
  n = 1000;

type
  matr = array[1..n, 1..n] of real;
  { Tmain_form }

  Tmain_form = class(TForm)
    main_button: TButton;
    matrix_spinedit: TSpinEdit;
    matrix: TStringGrid;
    procedure main_buttonClick(Sender: TObject);
    procedure matrix_spineditChange(Sender: TObject);
  private

  public

  end;

var
  main_form: Tmain_form;

implementation

{$R *.lfm}
{Основные функции}

//Чёркает из матрицы, записывает в матрицу tos
procedure GetMatr(a:matr; var b:matr; m,i,j:integer);
{ Вычеркивание из матрицы строки и столбца }
var ki,kj,di,dj:integer;
  begin
  di:=0;
  for ki:=1 to m-1 do
    begin
    if (ki=i) then di:=1;
    dj:=0;
    for kj:=1 to m-1 do
      begin
      if (kj=j) then dj:=1;
      b[ki,kj]:=a[ki+di,kj+dj];
      end;
    end;
  end;
Function Determinant(a:matr;size:integer):real;
{ Вычисление определителя матрицы }
var d,k:real;
    b:matr;
    i: integer;
  begin
  d:=0; k:=1;
  if (size<1) then
    begin
    ShowMessage('Херня');
    exit;
    end;
  if (size=1)
    then d:=a[1,1]
  else if (size=2)
    then d:=a[1,1]*a[2,2]-a[2,1]*a[1,2]
  else { n>2 }
    for i:=1 to size do
      begin
      GetMatr(a,b,size,i,1);
      d:=d+k*a[i,1]*Determinant(b,size-1);
      k:=-k;
      end;
    ShowMessage(FloatTostr(d));
  Determinant:=d;
  end;

{Счёт обратной матрицы}

{Счёт ранга матрицы}
{ Tmain_form }

procedure Tmain_form.main_buttonClick(Sender: TObject);
var
  i, j: integer;
  me: matr;
begin
  if matrix.ColCount <> matrix.RowCount then
  begin
    ShowMessage('Матрица некорректная по размерам');
    exit;
  end;

  for i := 1 to matrix_spinedit.Value do
  begin
    for j := 1 to matrix_spinedit.Value do
    begin
      me[i, j] := StrToInt(matrix.Cells[j-1, i-1]);
    end;
  end;

  Determinant(me, matrix_spinedit.Value);
end;

procedure Tmain_form.matrix_spineditChange(Sender: TObject);
begin
  matrix.ColCount := matrix_spinedit.Value;
  matrix.RowCount := matrix_spinedit.Value;
end;

end.
