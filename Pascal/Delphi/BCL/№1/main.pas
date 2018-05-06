unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls, Buttons, Spin;

type
  figure = record
    x1, y1, x2, y2, x3, y3, x4, y4, x5, y5: integer;
    code: byte;
    R: extended;
    color_z, color_g: Tcolor;
    style_z: TBrushStyle;
    style_p: TPenStyle;
    kistS: integer;
  end;
  obs = array of figure;

  { Tform_main }

  Tform_main = class(TForm)
    btn_ellipse: TBitBtn;
    btn_otrez: TBitBtn;
    btn_sect: TBitBtn;
    btn_round: TBitBtn;
    btn_treug: TBitBtn;
    btn_pram: TBitBtn;
    button_otm: TButton;
    button_obr: TButton;
    combo_zal: TComboBox;
    label_zal_style: TLabel;
    label_br_col: TLabel;
    label_zal_sel: TLabel;
    label_br_col_c: TLabel;
    label_kist_size: TLabel;
    main_Color: TColorDialog;
    combo_brush: TComboBox;
    group_brushes: TGroupBox;
    label_brush: TLabel;
    label_zal: TLabel;
    main_Open: TOpenDialog;
    menu_main_img_s: TMenuItem;
    menu_main_img_o: TMenuItem;
    menu_main_oobjs: TMenuItem;
    menu_main_objs: TMenuItem;
    ox: TLabel;
    main_Save: TSaveDialog;
    kist_size: TSpinEdit;
    x: TLabel;
    oy: TLabel;
    menu_main: TMainMenu;
    menu_main_file: TMenuItem;
    Shape: TShape;
    procedure button_ellipseClick(Sender: TObject);
    procedure button_obrClick(Sender: TObject);
    procedure button_otmClick(Sender: TObject);
    procedure combo_brushChange(Sender: TObject);
    procedure combo_zalChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure group_brushesClick(Sender: TObject);
    procedure kist_sizeChange(Sender: TObject);
    procedure label_br_col_cClick(Sender: TObject);
    procedure label_br_col_cMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; A, B: integer);
    procedure label_zal_selClick(Sender: TObject);
    procedure label_zal_selMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; A, B: integer);
    procedure menu_main_img_oClick(Sender: TObject);
    procedure menu_main_img_sClick(Sender: TObject);
    procedure menu_main_objsClick(Sender: TObject);
    procedure menu_main_oobjsClick(Sender: TObject);
    procedure ShapeChangeBounds(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; A, B: integer);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; C, D: integer);
  private

  public

  end;

var
  form_main: Tform_main;
  instrument: byte; //Тип инструмента
  OBJECTS: array of figure; //Массив обьектов
  x1, y1, x2, y2, x3, y3, x4, y4: integer; //Координаты
  clicks: integer;
  ONFORM: integer; //Количество обьектов
  flag: boolean;
  R: integer;
  zgCol, brgCol: TColor;
  history: array of figure;
  inhis, gi: integer;
  style_z: TBrushStyle;
  style_p: TPenStyle;
  ks: integer;
  rct,bufrct: TRect;
  bmp_in, bmp_out, buffer: TBitmap;

implementation

{$R *.lfm}

{ Tform_main }
//Функция загрузки в буфер
procedure UpdBuffer(Shape: TShape);
begin
   buffer.Width:=Shape.Width;
   buffer.Height:=Shape.Height;
   bufrct := Rect(0, 0, buffer.Width, buffer.Height);
   buffer.Canvas.CopyRect(bufrct, Shape.Canvas, bufrct); //Копируем в буфер
   //Готово к выгрузке

end;

procedure GetBuf(Shape: TShape);
begin
    Shape.Canvas.CopyRect(bufrct, buffer.Canvas, bufrct);
end;

procedure GetAll(Shape: TShape);
var
  a, b, c, d, e, f, g, h, i, j, k: integer;
  u, v: TColor;
  code: byte;
  ZAL: TBrushStyle;
  PEN: TPenStyle;
  KIS: integer;
begin
  for i := 0 to ONFORM - 1 do
  begin
    a := OBJECTS[i].x1;
    b := OBJECTS[i].y1;
    c := OBJECTS[i].x2;
    d := OBJECTS[i].y2;
    e := OBJECTS[i].x3;
    f := OBJECTS[i].y3;
    g := OBJECTS[i].x4;
    h := OBJECTS[i].y4;
    code := OBJECTS[i].code;
    u := OBJECTS[i].color_g;
    v := OBJECTS[i].color_z;
    ZAL := OBJECTS[i].style_z;
    PEN := OBJECTS[i].style_p;
    KIS := OBJECTS[i].kistS;
    Shape.Canvas.Brush.Color := v;
    Shape.Canvas.Pen.Color := u;
    Shape.Canvas.Brush.Style := ZAL;
    Shape.Canvas.Pen.Style := PEN;
    Shape.Canvas.Pen.Width := KIS;
    case code of
      1:
      begin
        Shape.Canvas.Ellipse(a, b, c, d);
      end;
      2:
      begin
        R := abs(Round(sqrt(abs(((c - a) * (c - a)) + ((d - b) * (d - b))))));
        Shape.Canvas.Ellipse(a - R, b - R, a + R, b + R);
      end;
      3:
      begin
        Shape.Canvas.Polygon([Point(a, b), Point(c, d), Point(e, f)]);
      end;
      4:
      begin
        Shape.Canvas.Rectangle(a, b, c, d);
      end;
      5:
      begin
        Shape.Canvas.Brush.Style := bsSolid;
        Shape.Canvas.Line(a, b, c, d);
        e := (a + c) div 2;
        f := (b + d) div 2;
        R := abs(Round(sqrt(abs(((c - a) * (c - a)) + ((d - b) * (d - b))))));
        Shape.Canvas.TextOut(e - 20, f - 20, IntToStr(R));
      end;
      6:
      begin
        R := abs(Round(sqrt(abs(((c - a) * (c - a)) + ((d - b) * (d - b))))));
        Shape.Canvas.Pie(a - R, b - R, a + R, b + R, e, f, g, h);
      end;
    end;
  end;
end;

procedure WriteToFile(DIALOG: TSaveDialog);
var
  fl: file of figure;
  i: integer;
begin
  if ((DIALOG.Execute) and (DIALOG.FileName <> '')) then
  begin
    AssignFile(fl, DIALOG.FileName);
     {$I-}
    rewrite(fl);
     {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
    end;
    for i := 0 to ONFORM - 1 do
    begin
      Write(fl, OBJECTS[i]);
    end;
    CloseFile(fl);
  end;
end;

procedure WriteHistory(figr: figure);
var
  i: integer;
begin
  SetLength(history, gi + 1);
  history[gi] := figr;
  Inc(gi);
  if (inhis < 10) then
    Inc(inhis);
end;

procedure GetHistory();
var
  i: integer;
begin
  if inhis = 0 then
  begin
    ShowMessage('Вернуть ничего нельзя');
    exit;
  end
  else
  begin
    SetLength(OBJECTS, ONFORM + 1);
    OBJECTS[ONFORM] := history[gi - 1];
    Dec(gi);
    Dec(inhis);
    Inc(ONFORM);
    SetLength(history, gi);
  end;
end;

procedure ADD();
begin
  SetLength(OBJECTS, ONFORM + 1);
  OBJECTS[ONFORM].x1 := x1;
  OBJECTS[ONFORM].y1 := y1;
  OBJECTS[ONFORM].x2 := x2;
  OBJECTS[ONFORM].y2 := y2;
  OBJECTS[ONFORM].x3 := x3;
  OBJECTS[ONFORM].y3 := y3;
  OBJECTS[ONFORM].x4 := x4;
  OBJECTS[ONFORM].y4 := y4;
  OBJECTS[ONFORM].code := instrument;
  OBJECTS[ONFORM].color_z := zgCol;
  OBJECTS[ONFORM].color_g := brgCol;
  OBJECTS[ONFORM].style_z := style_z;
  OBJECTS[ONFORM].style_p := style_p;
  OBJECTS[ONFORM].kistS := ks;
  Inc(ONFORM);
end;

procedure Delete();
begin
  if (ONFORM <= 0) then
    ShowMessage('Возникло исключение. Никаких обьектов не содержится')
  else
  begin
    Dec(ONFORM);
    WriteHistory(OBJECTS[ONFORM]);
    SetLength(OBJECTS, ONFORM);
  end;
end;

procedure fig(Shape: TShape);
begin
  Shape.Canvas.Brush.Color := zgCol;
  Shape.Canvas.Pen.Color := brgCol;
  Shape.Canvas.Brush.Style := style_z;
  Shape.Canvas.Pen.Style := style_p;
  Shape.Canvas.Pen.Width := ks;
  case instrument of
    1:
    begin
      Shape.Canvas.Ellipse(x1, y1, x2, y2);
    end;
    2:
    begin
      R := abs(Round(sqrt(abs(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))))));
      Shape.Canvas.Ellipse(x1 - R, y1 - R, x1 + R, y1 + R);
    end;
    3:
    begin
      Shape.Canvas.Polygon([Point(x1, y1), Point(x2, y2), Point(x3, y3)]);
    end;
    4:
    begin
      Shape.Canvas.Rectangle(x1, y1, x2, y2);
    end;
    5:
    begin
      Shape.Canvas.Brush.Style := bsSolid;
      Shape.Canvas.Line(x1, y1, x2, y2);
      x3 := (x1 + x2) div 2;
      y3 := (y1 + y2) div 2;
      R := abs(Round(sqrt(abs(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))))));
      Shape.Canvas.TextOut(x3 - 20, y3 - 20, IntToStr(R));
    end;
    6:
    begin
      R := abs(Round(sqrt(abs(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))))));
      if clicks = 1 then
      begin
        Shape.Canvas.Ellipse(x1 - R, y1 - R, x1 + R, y1 + R);
      end
      else
      begin
        Shape.Canvas.Pie(x1 - R, y1 - R, x1 + R, y1 + R, x3, y3, x4, y4);
      end;
    end;
  end;
end;

//Процедура выбора инструмента
procedure Tform_main.button_ellipseClick(Sender: TObject);
begin
  instrument := (Sender as TBitBtn).TabOrder + 1;
end;

procedure Tform_main.button_obrClick(Sender: TObject);
begin
  GetHistory();
  repaint;
  GetAll(Shape);
end;

procedure Tform_main.button_otmClick(Sender: TObject);
begin
  Delete();
  repaint;
  GetAll(Shape);
end;

procedure Tform_main.combo_brushChange(Sender: TObject);
begin
  case combo_brush.ItemIndex of
    0: style_p := psSolid;
    1: style_p := psDash;
    2: style_p := psDot;
    3: style_p := psDashDot;
    4: style_p := psDashDotDot;
    5: style_p := psClear;
    6: style_p := psInsideFrame;
  end;
end;

procedure Tform_main.combo_zalChange(Sender: TObject);
begin
  case combo_zal.ItemIndex of
    0: style_z := bsSolid;
    1: style_z := bsClear;
    2: style_z := bsHorizontal;
    3: style_z := bsVertical;
    4: style_z := bsFDiagonal;
    5: style_z := bsBDiagonal;
    6: style_z := bsCross;
    7: style_z := bsDiagCross;
  end;
end;

procedure Tform_main.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  buffer.Free;
end;

procedure Tform_main.FormCreate(Sender: TObject);
begin
  clicks := 0;
  flag := False;
  inhis := 0;
  gi := 0;
  zgCol := label_zal_sel.Color;
  ks := 1;
  buffer := TBitmap.Create();
end;

procedure Tform_main.FormPaint(Sender: TObject);
begin
  if flag = True then
  begin
    fig(Shape);
  end;
  if inhis = 0 then
    button_obr.Enabled := False
  else
    button_obr.Enabled := True;
end;

procedure Tform_main.FormResize(Sender: TObject);
begin
  GetAll(Shape);
end;

procedure Tform_main.group_brushesClick(Sender: TObject);
begin

end;

procedure Tform_main.kist_sizeChange(Sender: TObject);
begin
  ks := kist_size.Value;
end;

procedure Tform_main.label_br_col_cClick(Sender: TObject);
begin
  if (main_Color.Execute) then
  begin
    Label_br_col_c.Color := main_Color.Color;
    brgCol := main_Color.Color;
  end;
end;

procedure Tform_main.label_br_col_cMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; A, B: integer);
begin

end;

procedure Tform_main.label_zal_selClick(Sender: TObject);
begin
  if (main_Color.Execute) then
  begin
    Label_zal_sel.Color := main_Color.Color;
    zgCol := main_Color.Color;
  end;
end;

procedure Tform_main.label_zal_selMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; A, B: integer);
begin

end;

procedure Tform_main.menu_main_img_oClick(Sender: TObject);
begin
  if ((main_Open.Execute) and (main_Open.FileName <> '')) then
  begin
    bmp_in := TBitmap.Create();
    bmp_in.LoadFromFile(main_open.FileName);
    rct := Rect(0, 0, bmp_in.Width, bmp_in.Height);
    Shape.Canvas.CopyRect(rct, bmp_in.Canvas, rct);
    bmp_in.Free;
  end;
end;

procedure Tform_main.menu_main_img_sClick(Sender: TObject);
begin
  if ((main_Save.Execute) and (main_Save.FileName <> '')) then
  begin
    bmp_out := TBitmap.Create();
    bmp_out.Width := Shape.Width;
    bmp_out.Height := Shape.Height;
    rct := Rect(0, 0, bmp_out.Width, bmp_out.Height);
    bmp_out.Canvas.CopyRect(rct, Shape.Canvas, rct);
    bmp_out.SavetoFile(main_Save.Filename);
    bmp_out.Free;
  end;
end;

procedure Tform_main.menu_main_objsClick(Sender: TObject);
begin
  WriteToFile(main_Save);
end;

procedure Tform_main.menu_main_oobjsClick(Sender: TObject);
var
  i: integer;
  fl: file of figure;
begin
  i := 0;
  OBJECTS := nil;
  SetLength(OBJECTS, 0);
  if ((main_Open.Execute) and (main_Open.FileName <> '')) then
  begin
    AssignFile(fl, main_Open.Filename);
     {$I-}
    reset(fl);
     {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      Exit;
    end;
    while (not EOF(fl)) do
    begin
      SetLength(OBJECTS, i + 1);
      Read(fl, objects[i]);
      Inc(i);
    end;
    ONFORM := i;
    CloseFile(fl);
    repaint;
    GetAll(Shape);
  end;
end;

procedure Tform_main.ShapeChangeBounds(Sender: TObject);
begin
  GetAll(Shape);

end;

procedure ClearCoords();
begin
  //Очищаем координаты
  x1 := 0;
  x2 := 0;
  x3 := 0;
  x4 := 0;
  y1 := 0;
  y2 := 0;
  y3 := 0;
  y4 := 0;
end;

procedure Tform_main.ShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; A, B: integer);
begin
  if (button = mbLeft) and (instrument <> 0) then
  begin
    Inc(clicks);
    //Переходим к определению фигуры
    case instrument of
      1, 2, 4, 5:
      begin  //Эллипс
        if clicks = 1 then
        begin
          x1 := A;
          y1 := B;
          flag := True;
        end
        else if clicks = 2 then
        begin
          x2 := A;
          y2 := B;
          fig(Shape);
          clicks := 0;
          flag := False;
          ADD();
          ClearCoords();
        end;
      end;
      3:
      begin  //Треугольник
        if clicks = 1 then
        begin
          x1 := A;
          y1 := B;
        end
        else if clicks = 2 then
        begin
          x2 := A;
          y2 := B;
          flag := True;
        end
        else if clicks = 3 then
        begin
          x3 := A;
          y3 := B;
          fig(Shape);
          clicks := 0;
          flag := False;
          ADD();
          ClearCoords();
        end;
      end;
      6:
      begin
        if clicks = 1 then
        begin
          x1 := A;
          y1 := B;
          flag := True;
        end
        else if clicks = 2 then
        begin
          x2 := A;
          y2 := B;
          x3 := A;
          y3 := B;
          x4 := A;
          y4 := B;
        end
        else if clicks = 3 then
        begin
          x3 := A;
          y3 := B;
        end
        else if clicks = 4 then
        begin
          x4 := A;
          y4 := B;
          fig(Shape);
          flag := False;
          clicks := 0;
          ADD();
          ClearCoords();
        end;
      end;
    end;
  end
  else if button = mbRight then
  begin
    clicks := 0;
    ClearCoords();
    flag := False;
    repaint;
    GetAll(Shape);
  end;
end;

procedure Tform_main.ShapeMouseMove(Sender: TObject; Shift: TShiftState; C, D: integer);
begin
  ox.Caption := IntToStr(C);
  oy.Caption := IntToStr(D);
  if flag = True then
  begin
    repaint;
    case instrument of
      1, 2, 4, 5:
      begin
        x2 := C;
        y2 := D;
      end;
      3:
      begin
        x3 := C;
        y3 := D;
      end;
      6:
      begin
        if clicks = 1 then
        begin
          x2 := C;
          y2 := D;
        end
        else if clicks = 2 then
        begin
          x3 := C;
          y3 := D;
        end
        else if clicks = 3 then
        begin
          x4 := C;
          y4 := D;
        end;
      end;
    end;
    GetAll(Shape);
  end;
end;

end.
