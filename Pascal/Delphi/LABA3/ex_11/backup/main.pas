unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type
  figure = record
    x1, y1, x2, y2, z1, z2: integer; //Координаты
    code: byte; //Код фигуры
    color, zal: TColor; //Цвет фигуры, возможно цвет заливки
  end;

  { Tform_main }

  Tform_main = class(TForm)
    reset: TButton;
    figure_ellipse: TButton;
    figure_pool: TButton;
    figure_pr: TButton;
    figure_sector: TButton;
    figure_treug: TButton;
    figure_otrez: TButton;
    group_figures: TGroupBox;
    label_coord_x: TLabel;
    label_coord_y: TLabel;
    label_x: TLabel;
    logs: TListBox;
    shape_main: TShape;
    procedure figure_ellipseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure resetClick(Sender: TObject);
    procedure shape_mainChangeBounds(Sender: TObject);
    procedure shape_mainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure shape_mainMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
  private

  public

  end;

var
  form_main: Tform_main;
  instrument: byte;
  color: Tcolor;
  x1, y1, x2, y2, z1, z2, clickCount: integer; //Глобальные координаты
  runned: boolean; //Флаг о текущем статусе
  //ГЛОБАЛЬНОЕ
  OBJECTS: array[1..1000] of figure; //Все обьекты формы
  HISTORY: array[1..10] of figure;
  //История. Будет хранить не более 10 изменений
  ONFORM: integer; //Количество обьектов на форме

implementation

{$R *.lfm}

{ Tform_main }

procedure Place(Shape: TShape);
var
  i, a, b, c, d, e, f, g: integer;
begin
  for i := 1 to ONFORM do
  begin
    a := OBJECTS[i].x1;
    b := OBJECTS[i].x2;
    c := OBJECTS[i].y1;
    d := OBJECTS[i].y2;
    e := OBJECTS[i].z1;
    f := OBJECTS[i].z2;

    case OBJECTS[i].code of
      1:
      begin
        Shape.Canvas.Ellipse(a, c, b, d);
      end;
      3:
      begin
        Shape.Canvas.Rectangle(a, c, b, d);
      end;
      5:
      begin
        Shape.Canvas.Polygon([Point(a, c), Point(b, d), Point(e, f)]);
      end;
    end;
  end;
end;

procedure DrawFigure(Shape: TShape);
begin
  case instrument of
    1:
    begin
      Shape.Canvas.Ellipse(x1, y1, x2, y2);
    end;
    3:
    begin
      Shape.Canvas.Rectangle(x1, y1, x2, y2);
    end;
  end;
end;

procedure ADD();
begin
  if (ONFORM >= 1000) then
    ShowMessage('Возникло переполнение')
  else
  begin
    Inc(ONFORM);
    OBJECTS[ONFORM].x1 := x1;
    OBJECTS[ONFORM].y1 := y1;
    OBJECTS[ONFORM].x2 := x2;
    OBJECTS[ONFORM].y2 := y2;
    OBJECTS[ONFORM].code := instrument;
  end;
end;

procedure Delete();
begin
  if (ONFORM <= 0) then
    ShowMessage('Возникло исключение. Никаких обьектов не содержится')
  else
  begin
    Dec(ONFORM);
  end;
end;

procedure Tform_main.figure_ellipseClick(Sender: TObject);
begin
  instrument := (Sender as TButton).TabOrder + 1;
  //Получаем таб кнопки. Делаем сооветствие
end;

procedure Tform_main.FormCreate(Sender: TObject);
begin
  ONFORM := 0;
  clickCount := 1;
end;

//При перерисовке
procedure Tform_main.FormPaint(Sender: TObject);
begin
  if (runned = True) then
  begin
    DrawFigure(Shape_Main);
  end;
end;

procedure Tform_main.resetClick(Sender: TObject);
begin
  Delete();
  logs.Items.Delete(Logs.Items.Count - 1);
  repaint;
  Place(Shape_Main);
end;

procedure Tform_main.shape_mainChangeBounds(Sender: TObject);
begin
  ShowMessage('Кек');
end;

//При клике мышкой
procedure Tform_main.shape_mainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  a: string;
begin
  a := '';
  if ((instrument = 3) and (clickCount <= 3)) then
  begin
    case clickcount of
      1:
      begin
        x1 := X;
        y1 := Y;
      end;
      2:
      begin
        x2 := X;
        y2 := Y;
      end;
      3:
      begin
        z1 := X;
        z2 := Y;
      end;
    end;
    Inc(clickCount);
    runned:= true;
  end
  else
  begin
    if (runned = False) then
    begin
      x1 := X;
      y1 := Y;
      runned := True;
    end
    else
    begin
      clickCount := 1;
      case instrument of
        1:
        begin
          Shape_Main.Canvas.Ellipse(x1, y1, X, Y);
          a := 'Эллипс';
        end;
        3:
        begin
          Shape_Main.Canvas.Rectangle(x1, y1, X, Y);
          a := 'Прямоугольник';
        end;
        5:
        begin
          Shape_Main.Canvas.Polygon([Point(x1, y1), Point(x2, y2), Point(z1, z2)]);
        end;
      end;
      ADD();
      runned := False;
      Logs.Items.Add(a + ' ' + IntToStr(ONFORM));
    end;
  end;
end;

procedure Tform_main.shape_mainMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if runned = True then
  begin
    repaint;
    //Перерисовать имеющиеся обьекты
    Place(Shape_Main);
  end;

  label_coord_x.Caption := IntToStr(X);
  label_coord_y.Caption := IntToStr(Y);
  x2 := X;
  y2 := Y;
end;

end.
