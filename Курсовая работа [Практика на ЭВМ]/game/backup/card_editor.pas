unit card_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls;

const
  BLOCK_SIZE = 24;        //Размер блока в игре
  BLOCK_COUNT = 25;
//Количество блоков на поле. Оно есть квадрат

type

  mapobj = record
    x, y: integer; //Координаты
    code: integer; //Тип обьекта
    vector: integer;
    //Куда будет направлена голова змейки (если это голова)
    cel: integer; //-368
    plan: integer; //Что нужно будет сделать игроку?
    mapcode: integer;
  end;

  { Tredact }

  Tredact = class(TForm)
    gmain: TMainMenu;
    map_open: TOpenDialog;
    map_save: TSaveDialog;
    instrum: TMenuItem;
    i_objects: TMenuItem;
    i_gmode: TMenuItem;
    myfile: TMenuItem;
    Open: TMenuItem;
    save: TMenuItem;
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure i_gmodeClick(Sender: TObject);
    procedure i_objectsClick(Sender: TObject);
    procedure openClick(Sender: TObject);
    procedure saveClick(Sender: TObject);
    procedure stoneClick(Sender: TObject);
    procedure DrawO();
    procedure GetAll;
    function CheckOnN(): boolean;

  private

  public

  end;

var
  redact: Tredact;
  brushe, CX, CY: integer;
  act: boolean;
  PMobKiller1_left, PMobKiller1_right, PMobKiller1_up, PMobKiller1_down,PMob4_left, PMob4_right, PMob4_up, PMob4_down,PMob3_left, PMob3_right, PMob3_up, PMob3_down,PMob2_left, PMob2_right, PMob2_up, PMob2_down,PPortal, PMob_left, PMob_right, PMob_up, PMob_down, PApple, PMelon,
  PPumpkin, PStone, PHeadUp, PHeadDown, PHeadLeft, PHeadRigth, PTerrain,
  PWall, PTree, PGreenStone, PSand, PBrick, PRedBrick: TBitmap;
  curx, cury: integer;
  objects: array of mapobj;
  onform: integer;
  clicks: integer;
  headuse: boolean;
  vect, vectmob: integer;

  codemap: integer;
  codeplan: integer;
  {
     Для кисти карты

     ----Строительные блоки-----
     1 - стена
     2 - голова змеи
     3 - земля
     4 - камень
     5 - дерево
     7 - зелёный камень
     8 - песок
     9 - кирпич
     10 - красный кирпич
     18 - портал
     -----Съедобные блоки---
     11 - яблоко
     12 - арбуз
     13 - тыква

     ----Мобы----
     14,15,16,17 - жуки (съедобные)
     19 - враждебный моб

     ----Служебное---
     120 - служебный тип. Регулирует тип игры, план
  }
  {
   Переменная Vector хранит направление, куда мы будем двигаться
   Коды направлений:

        1 - влево
        2 - вправо
        3 - вверх
        4 - вниз
  }
implementation

uses
  form_panel_obs, form_panel_gmode;

{$R *.lfm}

{ Tredact }

procedure Tredact.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True; //Буферизация
  act := True;
  {Параметры окна}
  Width := BLOCK_SIZE * (BLOCK_COUNT + 1);
  Height := Width + 20;

  //Загружаем текстуры
  PStone := TBitmap.Create();
  PHeadUp := TBitmap.Create();
  PHeadDown := TBitmap.Create();
  PHeadLeft := TBitmap.Create();
  PHeadRigth := TBitmap.Create();
  PTerrain := TBitmap.Create();
  PWall := TBitmap.Create();
  PTree := TBitmap.Create();
  PGreenStone := TBitmap.Create();
  PSand := TBitmap.Create();
  PBrick := TBitmap.Create();
  PRedBrick := TBitmap.Create();
  PApple := TBitmap.Create();
  PMelon := TBitmap.Create();
  PPumpkin := TBitmap.Create();
  PMob_right := TBitmap.Create();
  PMob_left := TBitmap.Create();
  PMob_up := TBitmap.Create();
  PMob_down := TBitmap.Create();
  PMob2_right := TBitmap.Create();
  PMob2_left := TBitmap.Create();
  PMob2_up := TBitmap.Create();
  PMob2_down := TBitmap.Create();
  PMob3_right := TBitmap.Create();
  PMob3_left := TBitmap.Create();
  PMob3_up := TBitmap.Create();
  PMob3_down := TBitmap.Create();
  PMob4_right := TBitmap.Create();
  PMob4_left := TBitmap.Create();
  PMob4_up := TBitmap.Create();
  PMob4_down := TBitmap.Create();
  PMobKiller1_down := TBitmap.Create();
  PMobKiller1_left := TBitmap.Create();
  PMobKiller1_right := TBitmap.Create();
  PMobKiller1_up:= TBitmap.Create();

  PPortal := TBitmap.Create();

  PStone.LoadFromFile('data/sprites/stone.bmp');
  PHeadUp.LoadFromFile('data/sprites/head_up.bmp');
  PHeadDown.LoadFromFile('data/sprites/head_down.bmp');
  PHeadLeft.LoadFromFile('data/sprites/head_left.bmp');
  PHeadRigth.LoadFromFile('data/sprites/head_rigth.bmp');
  PTerrain.LoadFromFile('data/sprites/terrain.bmp');
  PWall.LoadFromFile('data/sprites/wall.bmp');
  PTree.LoadFromFile('data/sprites/tree.bmp');
  PGreenStone.LoadFromFile('data/sprites/stone_green.bmp');
  PSand.LoadFromFile('data/sprites/sand.bmp');
  PBrick.LoadFromFile('data/sprites/brick.bmp');
  PRedBrick.LoadFromFile('data/sprites/brick_red.bmp');
  PApple.LoadFromFile('data/sprites/apple.bmp');
  PMelon.LoadFromFile('data/sprites/watermelon.bmp');
  PPumpkin.LoadFromFile('data/sprites/pumpkin.bmp');
  PPortal.LoadFromFile('data/sprites/portal_before.bmp');

  {Из последней фичи - загружаем мобов}
  PMob_down.LoadFromFile('data/sprites/mob1_down.bmp');
  PMob_up.LoadFromFile('data/sprites/mob1_up.bmp');
  PMob_left.LoadFromFile('data/sprites/mob1_left.bmp');
  PMob_right.LoadFromFile('data/sprites/mob1_right.bmp');

  PMob2_down.LoadFromFile('data/sprites/mob2_down.bmp');
  PMob2_up.LoadFromFile('data/sprites/mob2_up.bmp');
  PMob2_left.LoadFromFile('data/sprites/mob2_left.bmp');
  PMob2_right.LoadFromFile('data/sprites/mob2_right.bmp');

  PMob3_down.LoadFromFile('data/sprites/mob3_down.bmp');
  PMob3_up.LoadFromFile('data/sprites/mob3_up.bmp');
  PMob3_left.LoadFromFile('data/sprites/mob3_left.bmp');
  PMob3_right.LoadFromFile('data/sprites/mob3_right.bmp');

  PMob4_down.LoadFromFile('data/sprites/mob4_down.bmp');
  PMob4_up.LoadFromFile('data/sprites/mob4_up.bmp');
  PMob4_left.LoadFromFile('data/sprites/mob4_left.bmp');
  PMob4_right.LoadFromFile('data/sprites/mob4_right.bmp');

  {Мобы-убийцы}

  PMobKiller1_down.LoadFromFile('data/sprites/spider_down.bmp');
  PMobKiller1_left.LoadFromFile('data/sprites/spider_left.bmp');
  PMobKiller1_right.LoadFromFile('data/sprites/spider_right.bmp');
  PMobKiller1_up.LoadFromFile('data/sprites/spider_up.bmp');


  //Обьектов на форме нет
  onform := 0;
  vect := 1;
  vectmob := 1;
  codemap := 1;
  codeplan := 1;
end;

procedure ClearCoords;
begin
  curx := 0;
  cury := 0;
end;

procedure ADD();
begin
  Inc(onform);
  SetLength(objects, ONFORM);

  with objects[onform - 1] do
  begin
    x := curx;
    y := cury;
    code := brushe;
    cel := -368;
    if ((brushe >= 14) and (brushe <= 17)) or (brushe = 19) then
       vector := vectmob
    else
        vector:= vect;

    mapcode := 0;
    plan := 0;
  end;
end;

function Tredact.CheckOnN(): boolean;
var
  i, X, Y: integer;
begin
  Result := True;
  for i := 0 to onform - 1 do
  begin
    x := objects[i].x;
    y := objects[i].y;

    if ((CX = x) and (CY = y) and (objects[i].code <> -4)) then
    begin
      Result := False;
      break;
    end;
  end;
end;

procedure Tredact.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
begin
  if button = mbLeft then
  begin
    if act = True then
    begin
      ADD();
    end
    else if brushe = 6 then
    begin
      //Удаляем с карты
      for i := 0 to onform - 1 do
      begin
        if (objects[i].x = X - (X mod BLOCK_SIZE)) and
          (objects[i].y = Y - (Y mod BLOCK_SIZE)) then
        begin
          objects[i].code := -4;
        end;
      end;
      repaint;
      GetAll;
    end;
  end
  else if Button = mbRight then
  begin
    act := False;
  end;
end;

procedure Tredact.FormClick(Sender: TObject);
begin

end;

procedure Tredact.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  objects := nil;
  onform := 0;
  act := False;
  brushe := 0;
end;

procedure Tredact.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  a, b: integer;
begin
  if act = True then
  begin
    a := X mod BLOCK_SIZE;
    b := Y mod BLOCK_SIZE;

    CX := X - a;
    CY := Y - b;
    if CheckOnN = True then
    begin
      curx := CX;
      cury := CY;
      Refresh;
      GetAll;
    end;
  end;
end;

procedure Tredact.DrawO();
begin
  case brushe of
    1:
    begin
      Canvas.Draw(curx, cury, PStone);
    end;
    2:
    begin
      case vect of
        1:
          Canvas.Draw(curx, cury, PHeadLeft);
        2:
          Canvas.Draw(curx, cury, PHeadRigth);
        3:
          Canvas.Draw(curx, cury, PHeadUp);
        4:
          Canvas.Draw(curx, cury, PHeadDown);
      end;
    end;
    3:
    begin
      Canvas.Draw(curx, cury, PTerrain);
    end;
    4:
    begin
      Canvas.Draw(curx, cury, PWall);
    end;
    5:
    begin
      Canvas.Draw(curx, cury, PTree);
    end;
    7:
    begin
      Canvas.Draw(curx, cury, PGreenStone);
    end;
    8:
    begin
      Canvas.Draw(curx, cury, PSand);
    end;
    9:
    begin
      Canvas.Draw(curx, cury, PBrick);
    end;
    10:
    begin
      Canvas.Draw(curx, cury, PRedBrick);
    end;
    11:
    begin
      Canvas.Draw(curx, cury, PApple);
    end;
    12:
    begin
      Canvas.Draw(curx, cury, PMelon);
    end;
    13:
    begin
      Canvas.Draw(curx, cury, PPumpkin);
    end;
    14,15,16,17:
    begin
      case vectmob of
        1:
          Canvas.Draw(curx, cury, PMob_left);
        2:
          Canvas.Draw(curx, cury, PMob_right);
        3:
          Canvas.Draw(curx, cury, PMob_up);
        4:
          Canvas.Draw(curx, cury, PMob_down);
      end;
    end;
    18: begin
        Canvas.Draw(curx,cury, PPortal);
    end;
    19: begin
      case vectmob of
        1:
          Canvas.Draw(curx, cury, PMobKiller1_left);
        2:
          Canvas.Draw(curx, cury, PMobKiller1_right);
        3:
          Canvas.Draw(curx, cury, PMobKiller1_up);
        4:
          Canvas.Draw(curx, cury, PMobKiller1_down);
      end;
    end;
  end;
end;

procedure Tredact.GetAll;
var
  a, b, c, d, e, f, i: integer;
begin
  for i := 0 to onform - 1 do
  begin
    with objects[i] do
    begin
      a := x;
      b := y;
      c := code;
      d := vector;
    end;
    case c of
      1:
      begin
        Canvas.Draw(a, b, PStone);
      end;
      2:
      begin
        case d of
          1:
            Canvas.Draw(a, b, PHeadLeft);
          2:
            Canvas.Draw(a, b, PHeadRigth);
          3:
            Canvas.Draw(a, b, PHeadUp);
          4:
            Canvas.Draw(a, b, PHeadDown);
        end;
      end;
      3:
      begin
        Canvas.Draw(a, b, PTerrain);
      end;
      4:
      begin
        Canvas.Draw(a, b, PWall);
      end;
      5:
      begin
        Canvas.Draw(a, b, PTree);
      end;
      7:
      begin
        Canvas.Draw(a, b, PGreenStone);
      end;
      8:
      begin
        Canvas.Draw(a, b, PSand);
      end;
      9:
      begin
        Canvas.Draw(a, b, PBrick);
      end;
      10:
      begin
        Canvas.Draw(a, b, PRedBrick);
      end;
      11:
      begin
        Canvas.Draw(a, b, PApple);
      end;
      12:
      begin
        Canvas.Draw(a, b, PMelon);
      end;
      13:
      begin
        Canvas.Draw(a, b, PPumpkin);
      end;
      14,15,16,17:
      begin
        case d of
          1:
            Canvas.Draw(a, b, PMob_left);
          2:
            Canvas.Draw(a, b, PMob_right);
          3:
            Canvas.Draw(a, b, PMob_up);
          4:
            Canvas.Draw(a, b, PMob_down);
        end;
      end;
      18: begin
          Canvas.Draw(a,b, PPortal);
      end;
      19: begin
        case d of
          1:
            Canvas.Draw(a, b, PMobKiller1_left);
          2:
            Canvas.Draw(a, b, PMobKiller1_right);
          3:
            Canvas.Draw(a, b, PMobKiller1_up);
          4:
            Canvas.Draw(a, b, PMobKiller1_down);
        end;
      end;
    end;
  end;
end;

procedure Tredact.FormPaint(Sender: TObject);
begin
  if act = True then
  begin
    DrawO();
  end;
end;

procedure Tredact.i_gmodeClick(Sender: TObject);
begin
  form_panel_gmode.form_panel_mode.Show;
end;

procedure Tredact.i_objectsClick(Sender: TObject);
begin
  form_panel_obj.Show;
end;

procedure Tredact.openClick(Sender: TObject);
var
  i: integer;
  fout: file of mapobj;
begin
  if (map_open.Execute) and (map_open.FileName <> '') and
    (FileExists(map_open.FileName)) then
  begin
    AssignFile(fout, map_open.FileName);
  {$I-}
    reset(fout);
  {$I+}
    onform := 0;
    SetLength(objects, 0);
    while not EOF(fout) do
    begin
      Inc(onform);
      SetLength(objects, onform);
      Read(fout, objects[onform - 1]);
      if objects[onform - 1].cel <> -368 then
      begin
        ShowMessage(
          'Ошибка! Файл карт повреждён или им не является');
        onform := 0;
        SetLength(objects, 0);
        exit;
      end
      else if objects[onform - 1].code = 120 then
      begin
        //Открываем сие параметры
        codeplan := objects[onform - 1].plan;
        codemap := objects[onform - 1].mapcode;
        form_panel_mode.cm_1.ItemIndex := codemap - 1;
        form_panel_mode.sp1.Value := codeplan;
      end;
    end;
    brushe := 0;
    repaint;
    act := False;
    getAll;
    CloseFile(fout);
  end;
end;


procedure Tredact.saveClick(Sender: TObject);
var
  fout: file of mapobj;
  i: integer;
  temp: mapobj;
begin
  if (map_save.Execute) and (map_save.FileName <> '') then
  begin
    AssignFile(fout, map_save.FileName);
  {$I-}
    Rewrite(fout);
  {$I+}

    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка при открытии!');
    end;

    for i := 0 to onform - 1 do
    begin
      if (objects[i].code <> -4) then
        Write(fout, objects[i]);
    end;
    temp.code := 120;
    temp.mapcode := codemap;
    temp.plan := codeplan;
    temp.cel := -368;
    Write(fout, temp);
    brushe := 0;
    CloseFile(fout);
  end;
end;

procedure Tredact.stoneClick(Sender: TObject);
begin

end;

end.
