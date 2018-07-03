unit form_game_mode_2;

{
     Основной движок
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, mechanics, mmsystem;

{Основные игровые константы}
const
  BLOCK_SIZE = 24; //Размер блока в игре
  BLOCK_COUNT = 25;
  //Количество блоков на поле. Оно есть квадрат
  SNAKE_MAX_LENGHT = 1500; //Максимальная длина змейки
  SNAKE_MIN_LENGHT = 2; //Минимальная длина змейки
  SNAKE_MAX_SPEED = 300;
  //Максимальная скорость змейки. Регулирует период таймера
  SNAKE_MIN_SPEED = 50;   //Мин.скорость

type
  mapobj = record
    x, y: integer; //Координаты
    code: integer; //Тип обьекта
    vector: integer;
    //Куда будет направлена голова змейки (если это голова)
    cel: integer; //-368
    plan: integer;
    mapcode: integer;
  end;
  { Tgame_mode_2_form }

  Tgame_mode_2_form = class(TForm)
    cell: TImage;
    gameoverp: TPanel;
    gamepause: TPanel;
    gamewin: TPanel;
    gmpn: TPanel;
    lb_o4ki1: TLabel;
    lb_ost: TLabel;
    lb_ost_n: TLabel;
    N1: TLabel;
    N3: TLabel;
    N4: TLabel;
    panel_info: TPanel;
    panel_info_fm: TPanel;
    panel_win_ine2: TPanel;
    panel_win_ine4: TPanel;
    panel_win_ine5: TPanel;
    resimg: TImage;
    resimg1: TImage;
    resimg11: TImage;
    resimg12: TImage;
    resimg13: TImage;
    resimg14: TImage;
    resimg15: TImage;
    resimg16: TImage;
    resimg17: TImage;
    resimg18: TImage;
    resimg2: TImage;
    resimg3: TImage;
    resimg4: TImage;
    resimg5: TImage;
    resimg6: TImage;
    _header5: TPanel;
    _header7: TPanel;
    _header8: TPanel;
    _inform: TLabel;
    panel_win_ine: TPanel;
    lb_restart2: TLabel;
    lb_restart3: TLabel;
    timer_keyboard: TTimer;
    timer_real: TTimer;
    timer_main: TTimer;
    _header: TPanel;
    _header1: TPanel;
    _header2: TPanel;
    _header3: TPanel;
    _header4: TPanel;
    _inform1: TLabel;
    N: TLabel;
    _inform12: TLabel;
    _inform13: TLabel;
    _inform14: TLabel;
    _inform15: TLabel;
    _inform16: TLabel;
    _inform17: TLabel;
    _inform18: TLabel;
    _inform19: TLabel;
    _inform2: TLabel;
    _inform3: TLabel;
    _inform4: TLabel;
    _inform5: TLabel;
    _inform6: TLabel;
    _inform7: TLabel;
    _startgame1: TLabel;
    _lv1: TLabel;
    _lv2: TLabel;
    _lv5: TLabel;
    _lv6: TLabel;
    _lv7: TLabel;
    _lv_exit1: TLabel;
    _startgame2: TLabel;
    _startgame4: TLabel;
    _startgame5: TLabel;
    _title: TLabel;
    _title12: TLabel;
    _title13: TLabel;
    _title14: TLabel;
    _title15: TLabel;
    _title16: TLabel;
    _title17: TLabel;
    _title18: TLabel;
    _title19: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure lb_restartClick(Sender: TObject);
    procedure timer_keyboardTimer(Sender: TObject);
    procedure timer_mainTimer(Sender: TObject);
    procedure timer_realTimer(Sender: TObject);
    procedure _lv1Click(Sender: TObject);
    procedure OpenCard(crd: string);
    procedure LoadMap;
    procedure StartGame;
    procedure GameOver;
    procedure Move;
    procedure MobsMove;
    procedure AddTail;
    procedure OnMove;
    procedure SuccessFull;
    procedure NextLevel;
    procedure KillerMove;
    procedure KillerSetVector(id: integer);

    procedure _lv_exitClick(Sender: TObject);
    procedure _startgame1Click(Sender: TObject);
    procedure _startgame2Click(Sender: TObject);
    procedure _startgame3Click(Sender: TObject);
    procedure _startgame5Click(Sender: TObject);
    procedure _title2Click(Sender: TObject);
    procedure _title3Click(Sender: TObject);
    procedure _title4Click(Sender: TObject);
    procedure _title5Click(Sender: TObject);
    procedure _title7Click(Sender: TObject);
    procedure _title8Click(Sender: TObject);
    procedure mobSetVect(id: integer);

    procedure PlaceFood;
    procedure PlaceMobs(which: integer);
    procedure SetGameSeason(season: integer);
    procedure ClearGame;
    procedure GenCell;

  private

  public

  end;

var
  game_mode_2_form: Tgame_mode_2_form;

  BLOCKS_ON_FORM: integer;
  Objects: array of mapobj; //Массив обьектов
  BL_ON_FORM: integer;
  FOOD_ON_FORM: integer;
  MOBS_ON_FORM: integer;
  KILLERS_ON_FORM: integer;

  Lenght: integer; //Хранит длину змейки

  UsedHead: boolean;
  UsedPortal: boolean;
  //Маячок - открыт ли ресурс "голова" и считаны ли координаты?

  {Что нужно съесть из жуков змейке}
  Snake_Cell: integer; //Просто номер
  {Спрайты}
  Snake_Tail: array[1..SNAKE_MAX_LENGHT] of TTail; //Массив есть хвост
  Snake_Food: array[1..SNAKE_MAX_LENGHT] of TFood;  //Массив еды
  Snake_Blocks: array[1..SNAKE_MAX_LENGHT] of TBlock; //Массив блоков
  Snake_Mobs: array[1..SNAKE_MAX_LENGHT] of TMob; //Массив мобов
  Snake_Killers: array[1..SNAKE_MAX_LENGHT] of TMob;
  //Массив вражеских мобов
  Snake_Head: THead;
  SpFood: TFood;
  SpPortal: TBlock; //Блок портала
  Coords: array[1..SNAKE_MAX_LENGHT] of mapobj;
  Coords_k: array[1..SNAKE_MAX_LENGHT] of mapobj;

  {Текстуры}
  PMobKiller1_left, PMobKiller1_right, PMobKiller1_up, PMobKiller1_down,
  PMob4_left, PMob4_right, PMob4_up, PMob4_down, PMob3_left, PMob3_right,
  PMob3_up, PMob3_down, PMob2_left, PMob2_right, PMob2_up, PMob2_down,
  PMob_left, PMob_right, PMob_up, PMob_down, PBackground, PPortalBefore,
  PPortalAfter, PApple, PMelon, PPumpkin, PStone, PHeadUp, PTail,
  PFood, PHeadDown, PHeadLeft, PHeadRigth, PTerrain, PWall, PTree,
  PNowHead, PGreenStone, PSand, PBrick, PRedBrick: TBitmap;

  //Вектор
  vect: integer;

  //Начата ли игра?
  StartedGame: boolean;
  PausedGame: boolean;



  {Что получаем при выгрузке головы из файла}
  GV, onstart_x, onstart_y: integer;

  {Служебные переменные}
  GameMode: integer; //Режим игры
  GamePlan: integer; //Цель игры

  {Служебные переменные об номере уровня, сезона}
  GameLevel: integer; //Текущий уровень
  GameSeason: integer; //Текущий сезон

  {Решение проблемы с клавиатурой - залипание}
  GameKeyZalip: boolean; //Залипание клавиши

  KILL: boolean;

implementation

uses
  form_main;

{$R *.lfm}
{Отдельный блок для звуков}
procedure winSound;
begin
  sndPlaySound('data/sounds/level_complete.wav', SND_ASYNC or SND_NODEFAULT);
end;

procedure failSound;
begin
  sndPlaySound('data/sounds/level_failed.wav', SND_ASYNC or SND_NODEFAULT);
end;

procedure stopGameMusic;
begin
  sndPlaySound(nil, 0);
end;

{ Tgame_mode_2_form }

procedure Tgame_mode_2_form.GenCell;
begin
  Snake_Cell := 14 + random(4);
  panel_info_fm.Visible := True;
  case Snake_Cell of
    14: cell.Picture.LoadFromFile('data/sprites/mob1_up.bmp');
    15: cell.Picture.LoadFromFile('data/sprites/mob2_up.bmp');
    16: cell.Picture.LoadFromFile('data/sprites/mob3_up.bmp');
    17: cell.Picture.LoadFromFile('data/sprites/mob4_up.bmp');
  end;
end;

//Получает моба и вектор, переписывает ему текстуру
procedure setBitmapByMob(var mob: TMob; whovector: integer);
begin

  //Получаем код картинки
  case mob.getCodeMob of
    14:
    begin
      case whovector of
        1:
          mob.setBitmap(PMob_left);
        2:
          mob.setBitmap(PMob_right);
        3:
          mob.setBitmap(PMob_up);
        4:
          mob.setBitmap(PMob_down);
      end;
    end;
    15:
    begin
      case whovector of
        1:
          mob.setBitmap(PMob2_left);
        2:
          mob.setBitmap(PMob2_right);
        3:
          mob.setBitmap(PMob2_up);
        4:
          mob.setBitmap(PMob2_down);
      end;
    end;
    16:
    begin
      case whovector of
        1:
          mob.setBitmap(PMob3_left);
        2:
          mob.setBitmap(PMob3_right);
        3:
          mob.setBitmap(PMob3_up);
        4:
          mob.setBitmap(PMob3_down);
      end;
    end;
    17:
    begin
      case whovector of
        1:
          mob.setBitmap(PMob4_left);
        2:
          mob.setBitmap(PMob4_right);
        3:
          mob.setBitmap(PMob4_up);
        4:
          mob.setBitmap(PMob4_down);
      end;
    end;
    19:
    begin
      case whovector of
        1:
          mob.setBitmap(PMobKiller1_left);
        2:
          mob.setBitmap(PMobKiller1_right);
        3:
          mob.setBitmap(PMobKiller1_up);
        4:
          mob.setBitmap(PMobKiller1_down);
      end;
    end;
  end;
end;

{Записать обьекты в массив обьектов. Времени мало, не самое эффективное}
procedure InsertObjects;
var
  i: integer;
begin
  Objects := nil;
  BLOCKS_ON_FORM := 0;

  for i := 1 to BL_ON_FORM do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Blocks[i].getX;
      y := Snake_Blocks[i].getY;
    end;
  end;

  for i := 1 to FOOD_ON_FORM do
  begin
    if Snake_Food[i].getVisComp = 1 then begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Food[i].getX;
      y := Snake_Food[i].getY;
    end;
    end;
  end;

  for i := 1 to MOBS_ON_FORM do
  begin
    if Snake_Mobs[i].getVisComp = 1 then begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Mobs[i].getX;
      y := Snake_Mobs[i].getY;
    end;
    end;
  end;

  //Вражеские мобы
  for i := 1 to KILLERS_ON_FORM do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Killers[i].getX;
      y := Snake_Killers[i].getY;
    end;
  end;
  //Теперь сам хвост
  for i := 1 to Lenght - 1 do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Tail[i].getX;
      y := Snake_Tail[i].getY;
    end;
  end;

  Inc(BLOCKS_ON_FORM);
  SetLength(Objects, BLOCKS_ON_FORM);
  with Objects[BLOCKS_ON_FORM - 1] do
  begin
    x := Snake_Head.getX;
    y := Snake_Head.getY;
  end;
end;

//Проверяет, свободны ли от блока координаты?
function IsFreeCoords(A, B: integer): boolean;
var
  i: integer;
begin
  InsertObjects;
  Result := True;

  for i := 0 to BLOCKS_ON_FORM - 1 do
  begin
    if (Objects[i].x = A) and (Objects[i].y = B) then
    begin
      Result := False;
      break;
    end;
  end;
end;

//Проверяет, свободные ли от блока координаты (без учёта змейки)
function IsFreeCoordsNoSnake(A, B: integer): boolean;
var
  i: integer;
begin
  Objects := nil;
  BLOCKS_ON_FORM := 0;

  for i := 1 to BL_ON_FORM do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Blocks[i].getX;
      y := Snake_Blocks[i].getY;
    end;
  end;

  for i := 1 to FOOD_ON_FORM do
  begin
    if Snake_Food[i].getVisComp = 1 then begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Food[i].getX;
      y := Snake_Food[i].getY;
    end;
    end;
  end;

  for i := 1 to MOBS_ON_FORM do
  begin
    if Snake_Mobs[i].getVisComp = 1 then begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Mobs[i].getX;
      y := Snake_Mobs[i].getY;
    end;
    end;
  end;

  //Вражеские мобы
  for i := 1 to KILLERS_ON_FORM do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Killers[i].getX;
      y := Snake_Killers[i].getY;
    end;
  end;
  Result := True;

  for i := 0 to BLOCKS_ON_FORM - 1 do
  begin
    if (Objects[i].x = A) and (Objects[i].y = B) then
    begin
      Result := False;
      break;
    end;
  end;
end;

function IsFreeCoordsKeyB(A, B: integer): boolean;
var
  i: integer;
begin
  Objects := nil;
  BLOCKS_ON_FORM := 0;

  for i := 1 to BL_ON_FORM do
  begin
    Inc(BLOCKS_ON_FORM);
    SetLength(Objects, BLOCKS_ON_FORM);
    with Objects[BLOCKS_ON_FORM - 1] do
    begin
      x := Snake_Blocks[i].getX;
      y := Snake_Blocks[i].getY;
    end;
  end;

  Result := True;

  for i := 0 to BLOCKS_ON_FORM - 1 do
  begin
    if (Objects[i].x = A) and (Objects[i].y = B) then
    begin
      Result := False;
      break;
    end;
  end;
end;
procedure Tgame_mode_2_form.KillerSetVector(id: integer);
var
  chose: set of 10..11;
  temp,i,k: integer;
begin
  Randomize;
  k:= 4;
  temp:= Snake_Killers[id].getVect;

  if (IsFreeCoordsNoSnake(Snake_Killers[id].getX - BLOCK_SIZE,
    Snake_Killers[id].getY)) and (Snake_Killers[id].getVect <> 1) and
    (Snake_Killers[id].getX <> 0) then
  begin
    chose:= chose + [1];
  end;
  if (IsFreeCoordsNoSnake(Snake_Killers[id].getX + BLOCK_SIZE,
    Snake_Killers[id].getY)) and (Snake_Killers[id].getVect <> 2) and
    (Snake_Killers[id].getX <> Width) then
  begin
    chose:= chose + [2];
  end;
  if (IsFreeCoordsNoSnake(Snake_Killers[id].getX, Snake_Killers[id].getY -
    BLOCK_SIZE)) and (Snake_Killers[id].getVect <> 3) and
    (Snake_Killers[id].getY <> 0) then
  begin
    chose:= chose + [3];
  end;
  if (IsFreeCoordsNoSnake(Snake_Killers[id].getX, Snake_Killers[id].getY +
    BLOCK_SIZE)) and (Snake_Killers[id].getVect <> 4) and
    (Snake_Killers[id].getY <> Height) then
  begin
    chose:= chose + [4];
  end;


  for i:= 1 to 50 do begin
    temp:= 1 + Random(k);
    if temp in chose then begin
        Snake_Killers[id].setVect(temp);
        break;
    end
    else
    Snake_Killers[id].setVect(0);
  end;

  case Snake_Killers[id].getVect of
    1:
      Snake_Killers[id].setX(Snake_Killers[id].getX - BLOCK_SIZE);
    2:
      Snake_Killers[id].setX(Snake_Killers[id].getX + BLOCK_SIZE);
    3:
      Snake_Killers[id].setY(Snake_Killers[id].getY - BLOCK_SIZE);
    4:
      Snake_Killers[id].setY(Snake_Killers[id].getY + BLOCK_SIZE);
  end;

  //Устанавливаем новый битмап
  setBitmapByMob(Snake_Killers[id], Snake_Killers[id].getVect);
end;

//Устанавливает новый вектор, производит смещение
procedure Tgame_mode_2_form.mobSetVect(id: integer);
var
  chose: set of 10..11;
  temp,i,k: integer;
begin

  k:= 4;
  temp:= Snake_Mobs[id].getVect;

  if (IsFreeCoords(Snake_Mobs[id].getX - BLOCK_SIZE, Snake_Mobs[id].getY)) and
    (Snake_Mobs[id].getVect <> 1) and (Snake_Mobs[id].getX <> 0) then
  begin
    chose:= chose + [1];
  end;
  if (IsFreeCoords(Snake_Mobs[id].getX + BLOCK_SIZE, Snake_Mobs[id].getY)) and
    (Snake_Mobs[id].getVect <> 2) and (Snake_Mobs[id].getX <> Width) then
  begin
    chose:= chose + [2];
  end;
  if (IsFreeCoords(Snake_Mobs[id].getX, Snake_Mobs[id].getY - BLOCK_SIZE)) and
    (Snake_Mobs[id].getVect <> 3) and (Snake_Mobs[id].getY <> 0) then
  begin
    chose:= chose + [3];
  end;
  if (IsFreeCoords(Snake_Mobs[id].getX, Snake_Mobs[id].getY + BLOCK_SIZE)) and
    (Snake_Mobs[id].getVect <> 4) and (Snake_Mobs[id].getY <> Height) then
  begin
    chose:= chose + [4];
  end;

    for i:= 1 to 50 do begin
    temp:= 1 + Random(k);
    if temp in chose then begin
        Snake_Mobs[id].setVect(temp);
        break;
    end
    else
    Snake_Mobs[id].setVect(0);
  end;

  case Snake_Mobs[id].getVect of
    1:
      Snake_Mobs[id].setX(Snake_Mobs[id].getX - BLOCK_SIZE);
    2:
      Snake_Mobs[id].setX(Snake_Mobs[id].getX + BLOCK_SIZE);
    3:
      Snake_Mobs[id].setY(Snake_Mobs[id].getY - BLOCK_SIZE);
    4:
      Snake_Mobs[id].setY(Snake_Mobs[id].getY + BLOCK_SIZE);
  end;

  //Устанавливаем новый битмап
  setBitmapByMob(Snake_Mobs[id], Snake_Mobs[id].getVect);
end;

procedure Tgame_mode_2_form.KillerMove;
var
  i: integer;
begin
  //Обрабатываем движение каждого моба
  Randomize;

  for i := 1 to KILLERS_ON_FORM do
  begin
    if Random(100) > 90 then
    begin
      Snake_Killers[i].setVect(1 + Random(4));
      setBitmapByMob(Snake_Killers[i], Snake_Killers[i].getVect);
    end;
    case Snake_Killers[i].getVect of
      1:
      begin //Если координаты свободны влево, то тогда двигаем влево
        if IsFreeCoordsNoSnake(Snake_Killers[i].getX - BLOCK_SIZE,
          Snake_Killers[i].getY) and (Snake_Killers[i].getX <> 0) then
        begin
          Snake_Killers[i].setX(Snake_Killers[i].getX - BLOCK_SIZE);
        end
        else
          KillerSetVector(i);
      end;
      2:
      begin
        if IsFreeCoordsNoSnake(Snake_Killers[i].getX + BLOCK_SIZE,
          Snake_Killers[i].getY) and (Snake_Killers[i].getX <> Width) then
        begin
          Snake_Killers[i].setX(Snake_Killers[i].getX + BLOCK_SIZE);
        end
        else
          KillerSetVector(i);
      end;
      3:
      begin
        if IsFreeCoordsNoSnake(Snake_Killers[i].getX, Snake_Killers[i].getY -
          BLOCK_SIZE) and (Snake_Killers[i].getY <> 0) then
        begin
          Snake_Killers[i].setY(Snake_Killers[i].getY - BLOCK_SIZE);
        end
        else
          KillerSetVector(i);
      end;
      4:
      begin
        if IsFreeCoordsNoSnake(Snake_Killers[i].getX, Snake_Killers[i].getY +
          BLOCK_SIZE) and (Snake_Killers[i].getY <> Height) then
        begin
          Snake_Killers[i].setY(Snake_Killers[i].getY + BLOCK_SIZE);
        end
        else
          KillerSetVector(i);
      end;
    end;
  end;
end;

procedure Tgame_mode_2_form.MobsMove;
var
  i: integer;
begin
  //Обрабатываем движение каждого моба
  Randomize;
  for i := 1 to MOBS_ON_FORM do
  begin
    if Random(100) > 80 then
    begin
      Snake_Mobs[i].setVect(1 + Random(4));
      setBitmapByMob(Snake_Mobs[i], Snake_Mobs[i].getVect);
    end;
    case Snake_Mobs[i].getVect of
      1:
      begin //Если координаты свободны влево, то тогда двигаем влево
        if IsFreeCoords(Snake_Mobs[i].getX - BLOCK_SIZE, Snake_Mobs[i].getY) and
          (Snake_Mobs[i].getX <> 0) then
        begin
          Snake_Mobs[i].setX(Snake_Mobs[i].getX - BLOCK_SIZE);
        end
        else
          mobSetVect(i);
      end;
      2:
      begin
        if IsFreeCoords(Snake_Mobs[i].getX + BLOCK_SIZE, Snake_Mobs[i].getY) and
          (Snake_Mobs[i].getX <> Width) then
        begin
          Snake_Mobs[i].setX(Snake_Mobs[i].getX + BLOCK_SIZE);
        end
        else
          mobSetVect(i);
      end;
      3:
      begin
        if IsFreeCoords(Snake_Mobs[i].getX, Snake_Mobs[i].getY - BLOCK_SIZE) and
          (Snake_Mobs[i].getY <> 0) then
        begin
          Snake_Mobs[i].setY(Snake_Mobs[i].getY - BLOCK_SIZE);
        end
        else
          mobSetVect(i);
      end;
      4:
      begin
        if IsFreeCoords(Snake_Mobs[i].getX, Snake_Mobs[i].getY + BLOCK_SIZE) and
          (Snake_Mobs[i].getY <> Height) then
        begin
          Snake_Mobs[i].setY(Snake_Mobs[i].getY + BLOCK_SIZE);
        end
        else
          mobSetVect(i);
      end;
    end;
  end;
end;

procedure Tgame_mode_2_form.OpenCard(crd: string);
var
  inpfl: file of mapobj;
  temp: mapobj;
begin
  crd := 'data/cards/0' + IntToStr(GameSeason) + '/' + crd;
  kill:= false;
  if not FileExists(crd) then
  begin
    ShowMessage('Ошибка! Файл карт не найден!');
    KILL:= true;
    gmpn.Visible := True;
    exit;
  end;

  AssignFile(inpfl, crd);
   {$I-}
  reset(inpfl);
   {$I+}
  if IORESULT <> 0 then
  begin
    ShowMessage('Ошибка! Некорректное открытие файла!');
    KILL:= true;
    gmpn.Visible := True;
    exit;
  end;

  BLOCKS_ON_FORM := 0;
  BL_ON_FORM := 0;
  FOOD_ON_FORM := 0;
  MOBS_ON_FORM := 0;
  KILLERS_ON_FORM := 0;
  UsedHead:=false;
  UsedPortal:= false;
  while not EOF(inpfl) do
  begin

    //Читаем во временную структуру
    Read(inpfl, temp);

    {Осуществляем проверку на подмену данных}
    with temp do
    begin
      //Если служебный тип - обслужим его в первый момент
      if (code = 120) then
      begin
        if (mapcode < 1) or (mapcode > 4) or (GamePlan < 0) then
        begin
          ShowMessage('Найдено некорректное описание карты');
          KILL:= true;
          gmpn.Visible := True;
          exit;
        end
        else
        begin
          GameMode := mapcode;
          GamePlan := plan;
        end;
      end
      else if (code = 18) then
      begin
      UsedPortal:=true;
        SpPortal := TBlock.Init(x, y, 0, PPortalBefore);
      end
      //Первичная проверка
      else if (code < 1) or (code > 19) or (vector < 1) or (vector > 4) or
        (cel <> -368) then
      begin
        ShowMessage(
          'Файл, содержащий карту является некорректным или повреждённым. Открытие невозможно');
        KILL:= true;
        gmpn.Visible := True;
        exit;
      end;

      //Если голова, то сразу зададим координаты
      if (code = 2) then
      begin
      UsedHead:=True;
        case vector of
          1:
          begin
            Snake_Head := THead.Init(x, y, 1, PHeadLeft);
            PNowHead := PHeadLeft;
          end;
          2:
          begin
            Snake_Head := THead.Init(x, y, 1, PHeadRigth);
            PNowHead := PHeadRigth;
          end;
          3:
          begin
            Snake_Head := THead.Init(x, y, 1, PHeadUp);
            PNowHead := PHeadUp;
          end;
          4:
          begin
            Snake_Head := THead.Init(x, y, 1, PHeadDown);
            PNowHead := PHeadDown;
          end;
        end;

        GV := vector;
        onstart_x := x;
        onstart_y := y;
      end
      //Если блок
      else if (code > 0) and (code < 11) and (code <> 2) then
      begin
        Inc(BL_ON_FORM);
        //Добавляем в массив блоков
        case code of
          1: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PStone);
          3: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PTerrain);
          4: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PWall);
          5: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PTree);
          7: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PGreenStone);
          8: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PSand);
          9: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PBrick);
          10: Snake_Blocks[BL_ON_FORM] := TBlock.Init(x, y, 1, PRedBrick);
        end;
      end
      else if (code > 10) and (code <= 13) then  {Еда}
      begin
        Inc(FOOD_ON_FORM);
        case code of
          11: Snake_Food[FOOD_ON_FORM] := TFood.Init(x, y, 1, PApple);
          12: Snake_Food[FOOD_ON_FORM] := TFood.Init(x, y, 1, PMelon);
          13: Snake_Food[FOOD_ON_FORM] := TFood.Init(x, y, 1, PPumpkin);
        end;
      end
      //Если моб
      else if (code >= 14) and (code <= 17) then
      begin
        Inc(MOBS_ON_FORM);
        Coords[MOBS_ON_FORM].x := x;
        Coords[MOBS_ON_FORM].y := y;

        {Оставшиеся параметры}
        Snake_Mobs[MOBS_ON_FORM] := TMob.Init(x, y, 1, PMob2_up);
        setBitmapByMob(Snake_Mobs[MOBS_ON_FORM], vector);
        Snake_Mobs[MOBS_ON_FORM].setCodeMob(code);
        Snake_Mobs[MOBS_ON_FORM].setVect(vector);
      end
      else if (code = 19) then
      begin
        Inc(KILLERS_ON_FORM);
        Coords_k[KILLERS_ON_FORM].x := x;
        Coords_k[KILLERS_ON_FORM].y := y;

        {Оставшиеся параметры}
        Snake_Killers[KILLERS_ON_FORM] := TMob.Init(x, y, 1, PMobKiller1_up);
        setBitmapByMob(Snake_Killers[KILLERS_ON_FORM], vector);
        Snake_Killers[KILLERS_ON_FORM].setCodeMob(code);
        Snake_Killers[KILLERS_ON_FORM].setVect(vector);
      end;
    end;
  end;

  CloseFile(inpfl);

  if UsedHead = False then begin
     ShowMessage('Ошибка! На карте не задана точка головы змейки.');
     KILL:= true;
     gmpn.Visible := True;
     exit;
  end;

  if (GameMode = 3) and (UsedPortal = False) then begin
     ShowMessage('Ошибка! На карте не найден портал, хотя для данного типа уровней он необходим!');
     KILL:= true;
     gmpn.Visible := True;
     exit;
  end;
end;

{В случае удачного прохождения}
procedure Tgame_mode_2_form.SuccessFull;
begin
  timer_main.Enabled := False;
  {Игра закончена}
  StartedGame := False;
  {Звук}
  winSound;
  {Диалог победы}
  gamewin.Visible := True;
end;

procedure Tgame_mode_2_form.PlaceFood;
var
  i: integer;
  posx, posy: integer;
begin
  //Пишем обьекты
  InsertObjects;

  //Рандомизация, поиск свободного места
  Randomize;
  posx := Random(BLOCK_COUNT) * BLOCK_SIZE;
  posy := Random(BLOCK_COUNT) * BLOCK_SIZE;
  i := 0;
  while i <> BLOCKS_ON_FORM - 1 do
  begin
    if (posx = Objects[i].x) and (posy = Objects[i].y) then
    begin
      posx := Random(BLOCK_COUNT) * BLOCK_SIZE;
      posy := Random(BLOCK_COUNT) * BLOCK_SIZE;
      i := 0;
    end
    else
      Inc(i);
  end;

  //Генерируем еду случайным образом
  case (1 + Random(3)) of
    1: SpFood := TFood.Init(posx, posy, 1, PApple);
    2: SpFood := TFood.Init(posx, posy, 1, PMelon);
    3: SpFood := TFood.Init(posx, posy, 1, PPumpkin);
  end;

  //Конец
end;

{Добавить рандомного моба}
procedure Tgame_mode_2_form.PlaceMobs(which: integer);
var
  i: integer;
  posx, posy: integer;
begin
  //Пишем обьекты
  InsertObjects;

  //Рандомизация, поиск свободного места
  Randomize;
  posx := Random(BLOCK_COUNT) * BLOCK_SIZE;
  posy := Random(BLOCK_COUNT) * BLOCK_SIZE;
  i := 0;
  while i <> BLOCKS_ON_FORM - 1 do
  begin
    if (posx = Objects[i].x) and (posy = Objects[i].y) then
    begin
      posx := Random(BLOCK_COUNT) * BLOCK_SIZE;
      posy := Random(BLOCK_COUNT) * BLOCK_SIZE;
      i := 0;
    end
    else
      Inc(i);
  end;

  Inc(MOBS_ON_FORM);


  //Генерируем моба случайным образом
  Snake_Mobs[MOBS_ON_FORM] := TMob.Init(posx, posy, 1, PMob_up);
  if which = 0 then
    Snake_Mobs[MOBS_ON_FORM].setCodeMob(14 + Random(4))
  else
    Snake_Mobs[MOBS_ON_FORM].setCodeMob(which);

  Snake_Mobs[MOBS_ON_FORM].setVect(1 + Random(4));
  Snake_Mobs[MOBS_ON_FORM].setVisComp(1);
  setBitmapByMob(Snake_Mobs[MOBS_ON_FORM], Snake_Mobs[MOBS_ON_FORM].getVect);

end;

procedure Tgame_mode_2_form._title3Click(Sender: TObject);
begin
  gamepause.Visible := not (gamepause.Visible);
  PausedGame := not (PausedGame);
  timer_main.Enabled := not (timer_main.Enabled);
end;

procedure Tgame_mode_2_form._title4Click(Sender: TObject);
begin
  gamepause.Visible := not (gamepause.Visible);
  PausedGame := not (PausedGame);
  timer_main.Enabled := not (timer_main.Enabled);
  StartGame;
end;

procedure Tgame_mode_2_form._title5Click(Sender: TObject);
begin
  ClearGame;
end;

procedure Tgame_mode_2_form._title7Click(Sender: TObject);
begin
  //Повышаем уровень игры
  gamewin.Visible := False;
  panel_info_fm.Visible := False;
  NextLevel;
end;

procedure Tgame_mode_2_form._title8Click(Sender: TObject);
begin
  StartGame;
  gamewin.Visible := False;
end;

procedure Tgame_mode_2_form.GameOver;
begin
  {Звук}
  failSound;
  panel_info.Visible := False;
  {Останавливаем таймер, панель выводим на экран}
  gameoverp.Visible := True;

  if gamemode = 1 then
  begin
    MOBS_ON_FORM := 0;
    Snake_Cell := 0;
  end;

  timer_main.Enabled := False;
  timer_keyboard.Enabled := False;
  StartedGame := False;
end;

{Функция движени}
procedure Tgame_mode_2_form.Move;
var
  i: integer;
begin

  {Переписывание кординат для будущей отрисовки}
  for i := Lenght downto SNAKE_MIN_LENGHT do
  begin
    Snake_Tail[i].setX(Snake_Tail[i - 1].getX);
    Snake_Tail[i].setY(Snake_Tail[i - 1].getY);
  end;

  {Обновление окологоловного элемента}
  with Snake_Tail[1] do
  begin
    setX(Snake_Head.getX);
    setY(Snake_Head.getY);
  end;

  {Контроль прибавления пикселей}
  case Vect of
    1: Snake_Head.setX(Snake_Head.getX - BLOCK_SIZE);
    2: Snake_Head.setX(Snake_Head.getX + BLOCK_SIZE);
    3: Snake_Head.setY(Snake_Head.getY - BLOCK_SIZE);
    4: Snake_Head.setY(Snake_Head.getY + BLOCK_SIZE);
  end;

end;

procedure Tgame_mode_2_form.AddTail;
begin
  if (Lenght < SNAKE_MAX_LENGHT) then
  begin
    Inc(Lenght);
    Snake_Tail[Lenght] := TTail.Init(Snake_Tail[Lenght - 1].getX,
      Snake_Tail[Lenght - 1].getY, 1, PTail);
  end;

  lb_ost_n.Caption := IntToStr(GamePlan - (Lenght - 2));
end;

procedure Tgame_mode_2_form.OnMove;
var
  i, j: integer;
begin

  {Обработка выхода за границы карты}
  if (Snake_Head.getX = Width) then
  begin
    Snake_Head.setX(abs(Snake_Head.getX - Width));
  end
  else if (Snake_Head.getX < 0) then
  begin
    Snake_Head.setX(Width);
  end
  else if (Snake_Head.getY = Height) then
  begin
    Snake_Head.setY(abs(Snake_Head.getY - Height));
  end
  else if (Snake_Head.getY < 0) then
  begin
    Snake_Head.SetY(Height);
  end;

  {Обработка столковения со своим же телом}
  for i := Lenght downto SNAKE_MIN_LENGHT - 1 do
  begin
    if ((Snake_Head.getX = Snake_Tail[i].getX) and
      (Snake_Head.getY = Snake_Tail[i].getY)) then
    begin
      GameOver;
      exit;
    end;
  end;

  {Обработка столкновения с мобом}
  for i := 1 to MOBS_ON_FORM do
  begin
    if GameMode <> 1 then
    begin
      if (Snake_Head.getX = Snake_Mobs[i].getX) and
        (Snake_Head.getY = Snake_Mobs[i].getY) and (Snake_Mobs[i].getVisComp = 1) then
      begin
        Snake_Mobs[i].setVisComp(0);
        AddTail;
        if Lenght - 2 = GamePlan then
        begin
          SuccessFull;
          exit;
        end;
      end;
    end
    else if GameMode = 1 then
    begin
      if (Snake_Head.getX = Snake_Mobs[i].getX) and
        (Snake_Head.getY = Snake_Mobs[i].getY) and (Snake_Mobs[i].getVisComp = 1) and
        (Snake_Mobs[i].getCodeMob = Snake_Cell) then
      begin
        Snake_Mobs[i].setVisComp(0);
        AddTail;
        GenCell;
        PlaceMobs(Snake_Cell);
        if Lenght - 2 = GamePlan then
        begin
          SuccessFull;
          exit;
        end;
      end
      else if (Snake_Head.getX = Snake_Mobs[i].getX) and
        (Snake_Head.getY = Snake_Mobs[i].getY) and (Snake_Mobs[i].getVisComp = 1) and
        (Snake_Mobs[i].getCodeMob <> Snake_Cell) then
        GameOver;
    end;
  end;

  {Обработка столкновения с элементами на карте. Блоками, являющимися твёрдыми}
  for i := 1 to BL_ON_FORM do
  begin
    if (Snake_Head.getX = Snake_Blocks[i].getX) and
      (Snake_Head.getY = Snake_Blocks[i].getY) then
    begin
      GameOver;
      exit;
    end;
  end;


  {Обработка столкновений со статическими элементами еды на карте. Делаются невидимыми}
  for i := 1 to FOOD_ON_FORM do
  begin
    if (Snake_Head.getX = Snake_Food[i].getX) and
      (Snake_Head.getY = Snake_Food[i].getY) and (Snake_Food[i].getVisComp = 1) then
    begin
      AddTail;
      Snake_Food[i].setVisComp(0);
      {Если игровой режим есть 1,4, то проверяем количество сожранного| Если пользователь победил - вызываем функцию победы}
      if (GameMode <> 2) and (GameMode <> 3) and (Lenght - 2 = GamePlan) then
      begin
        SuccessFull;
        exit;
      end;
    end;
  end;

  {Обработка столкновения киллеров со змейкой}
  for i := 1 to KILLERS_ON_FORM do
  begin
    for j := Lenght downto SNAKE_MIN_LENGHT - 1 do
    begin
      if ((Snake_Tail[j].getX = Snake_Killers[i].getX) and
        (Snake_Tail[j].getY = Snake_Killers[i].getY)) or
        ((Snake_Head.getX = Snake_Killers[i].getX) and (Snake_Head.getY =
        Snake_Killers[i].getY)) then
      begin
        GameOver;
        exit;
      end;
    end;
  end;


  {Если игровой режим есть 2, то тогда на карте генерируются отдельные блоки}
  if GameMode = 2 then
  begin
    if (Snake_Head.getX = SpFood.getX) and (Snake_Head.getY = SpFood.getY) then
    begin
      AddTail;
      PlaceFood;
      timer_main.Interval := (SNAKE_MAX_SPEED div ((Lenght - 2) + 1));
      //Если заполнил комнату, то победа
      if (Lenght - 2 = GamePlan) then
      begin
        SuccessFull;   //Пользователь победил
        exit;
      end;
    end;
  end;

  {Если игровой режим есть 3, то тогда на карте обрабатывается столкновение с порталом}
  if GameMode = 3 then
  begin

    //Если портал уже открыт, то пытаемся столкнуться именно с ним
    if (Snake_Head.getX = SpPortal.getX) and (Snake_Head.getY = SpPortal.getY) and
      (SpPortal.getVisComp = 1) then
    begin
      SuccessFull;
      exit;
    end
    //Иначе, если портал ещё не открыт, смотрим на длину змейки и план
    else
    begin
      if (Lenght - 2 = GamePlan) then
      begin
        SpPortal.setVisComp(1);
      end;
    end;
  end;

end;

//Загружает карту и отрисовывает на окне
procedure Tgame_mode_2_form.LoadMap;
var
  i: integer;
begin

  {Отрисовка блоков}
  for i := 1 to BL_ON_FORM do
  begin
    canvas.Draw(Snake_Blocks[i].getX, Snake_Blocks[i].getY, Snake_Blocks[i].getBitmap);
  end;

  {Отрисовка еды}
  for i := 1 to FOOD_ON_FORM do
  begin
    if (Snake_Food[i].getVisComp = 1) then
      Canvas.Draw(Snake_Food[i].getX, Snake_Food[i].getY, Snake_Food[i].getBitmap);
  end;

  {Если игровой режим 2 - генерируем яблоки}
  if GameMode = 2 then
  begin
    Canvas.Draw(SpFood.getX, SpFood.getY, SpFood.getBitmap);
  end;

  {Если игровой режим 3 - отрисовываем портал при его открытии}
  if GameMode = 3 then
  begin
    if SpPortal.getVisComp = 1 then
    begin
      Canvas.Draw(SpPortal.getX, SpPortal.getY, SpPortal.getBitmap);
    end;
  end;
end;

procedure Tgame_mode_2_form.StartGame;
var
  i: integer;
begin
  KILL:= FALSE;
  //Начальная длина змейки
  Lenght := SNAKE_MIN_LENGHT;


  //Делаем еду снова видимой
  for i := 1 to FOOD_ON_FORM do
  begin
    Snake_Food[i].setVisComp(1);
  end;

  {Восстанавливаем съедобных мобов}
  for i := 1 to MOBS_ON_FORM do
  begin
    Snake_Mobs[i].setX(Coords[i].x);
    Snake_Mobs[i].setY(Coords[i].y);
    Snake_Mobs[i].setVisComp(1);
  end;

  {Восстанавливаем киллеров}
  for i:= 1 to KILLERS_ON_FORM do begin
     Snake_Killers[i].setX(Coords_k[i].x);
     Snake_Killers[i].setY(Coords_k[i].y);
  end;
  {Основные поля}
  Randomize;

  //Голова змейки
  Snake_Head := THead.Init(onstart_x, onstart_y, 1, PNowHead);

  //Куда будет двигаться змейка и её хвост
  Vect := GV;
  case GV of
    1:
    begin
      PNowHead := PHeadLeft;
      Snake_Tail[1] := TTail.Init(Snake_Head.getX + BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX + 2 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
    end;
    2:
    begin
      PNowHead := PHeadRigth;
      Snake_Tail[1] := TTail.Init(Snake_Head.getX - BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX - 2 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
    end;
    3:
    begin
      PNowHead := PHeadUp;
      Snake_Tail[1] := TTail.Init(Snake_Head.getX, Snake_Head.getY +
        BLOCK_SIZE, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX, Snake_Head.getY +
        2 * BLOCK_SIZE, 1, PTail);
    end;
    4:
    begin
      PNowHead := PHeadDown;
      Snake_Tail[1] := TTail.Init(Snake_Head.getX, Snake_Head.getY -
        BLOCK_SIZE, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX, Snake_Head.getY -
        2 * BLOCK_SIZE, 1, PTail);
    end;
  end;

  {В зависимости от игрового режима задаём парамеры}
  if GameMode = 1 then
  begin
    for i := 1 to 5 do
    begin
      PlaceMobs(0);
      //Генерируем цель
      GenCell;
    end;
    PlaceMobs(Snake_Cell);
  end
  else if GameMode = 2 then
  begin
    PlaceFood;
  end
  else if GameMode = 3 then
  begin
    SpPortal.setVisComp(0);
  end;


  {Параметры таймера}
  timer_main.Enabled := True;
  timer_main.Interval := SNAKE_MAX_SPEED;
  timer_keyboard.Interval := SNAKE_MAX_SPEED;
  timer_keyboard.Enabled := True;
  {Параметры клавиатуры}
  GameKeyZalip := False;
  {Подгружаем карту}
  LoadMap;

  {Панель}
  lb_ost_n.Caption := IntToStr(GamePlan);
  {Игра началась}
  StartedGame := True;
  PausedGame := False;
end;

//Инициализация формы
procedure Tgame_mode_2_form.FormCreate(Sender: TObject);
begin

  {Основные задачи}
  DoubleBuffered := True; //Буферизация

  {Обнуление}
  BLOCKS_ON_FORM := 0;
  FOOD_ON_FORM := 0;
  BL_ON_FORM := 0;
  MOBS_ON_FORM := 0;
  {Загрузка ресурсов}
  PStone := TBitmap.Create();
  PHeadUp := TBitmap.Create();
  PHeadDown := TBitmap.Create();
  PHeadLeft := TBitmap.Create();
  PHeadRigth := TBitmap.Create();
  PTerrain := TBitmap.Create();
  PWall := TBitmap.Create();
  PTree := TBitmap.Create();
  PTail := TBitmap.Create();
  PFood := TBitmap.Create();
  PGreenStone := TBitmap.Create();
  PSand := TBitmap.Create();
  PBrick := TBitmap.Create();
  PRedBrick := TBitmap.Create();
  PApple := TBitmap.Create();
  PMelon := TBitmap.Create();
  PPumpkin := TBitmap.Create();
  PPortalBefore := TBitmap.Create();
  PPortalAfter := TBitmap.Create();
  PBackground := TBitmap.Create();

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
  PMobKiller1_up := TBitmap.Create();
  {Сами текстуры}
  PStone.LoadFromFile('data/sprites/stone.bmp');
  PHeadUp.LoadFromFile('data/sprites/head_up.bmp');
  PHeadDown.LoadFromFile('data/sprites/head_down.bmp');
  PHeadLeft.LoadFromFile('data/sprites/head_left.bmp');
  PHeadRigth.LoadFromFile('data/sprites/head_rigth.bmp');
  PTerrain.LoadFromFile('data/sprites/terrain.bmp');
  PWall.LoadFromFile('data/sprites/wall.bmp');
  PTree.LoadFromFile('data/sprites/tree.bmp');
  PTail.LoadFromFile('data/sprites/body.bmp');
  PFood.LoadFromFile('data/sprites/apple.bmp');
  PGreenStone.LoadFromFile('data/sprites/stone_green.bmp');
  PSand.LoadFromFile('data/sprites/sand.bmp');
  PBrick.LoadFromFile('data/sprites/brick.bmp');
  PRedBrick.LoadFromFile('data/sprites/brick_red.bmp');
  PApple.LoadFromFile('data/sprites/apple.bmp');
  PMelon.LoadFromFile('data/sprites/watermelon.bmp');
  PPumpkin.LoadFromFile('data/sprites/pumpkin.bmp');
  PPortalBefore.LoadFromFile('data/sprites/portal_before.bmp');
  PPortalAfter.LoadFromFile('data/sprites/portal_after.bmp');
  PBackground.LoadFromFile('data/fones/fone.bmp');

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
  PMobKiller1_down.LoadFromFile('data/sprites/spider_down.bmp');
  PMobKiller1_left.LoadFromFile('data/sprites/spider_left.bmp');
  PMobKiller1_right.LoadFromFile('data/sprites/spider_right.bmp');
  PMobKiller1_up.LoadFromFile('data/sprites/spider_up.bmp');


  {Параметры окна}
  Width := BLOCK_SIZE * (BLOCK_COUNT + 1);
  Height := Width;

  {Параметры таймера}
  timer_main.Enabled := False;
  timer_main.Interval := SNAKE_MIN_SPEED;

  {Открытие панели начала игры}
  gmpn.Visible := True;

  {Игра ещё не началась}
  StartedGame := False;

end;

procedure Tgame_mode_2_form.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ClearGame;
  main_form.Visible:=true;
end;


{Обработчик нажатий клавиш}
procedure Tgame_mode_2_form.FormKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  //ShowMessage(IntToStr(Key));
  {

        1 - влево
        2 - вправо
        3 - вверх
        4 - вниз
  }
  case Key of
    40:
    begin
      if (Vect <> 3) and (GameKeyZalip <> True) and (IsFreeCoordsKeyB(Snake_Head.getX, Snake_Head.getY + BLOCK_SIZE)) then
      begin
        Vect := 4;
        PNowHead := PHeadDown;
        GameKeyZalip := True;
      end;
    end;
    39:
    begin
      if (Vect <> 1) and (GameKeyZalip <> True) and (IsFreeCoordsKeyB(Snake_Head.getX + BLOCK_SIZE, Snake_Head.getY)) then
      begin
        Vect := 2;
        PNowHead := PHeadRigth;
        GameKeyZalip := True;
      end;
    end;
    38:
    begin
      if (Vect <> 4) and (GameKeyZalip <> True) and (IsFreeCoordsKeyB(Snake_Head.getX, Snake_Head.getY - BLOCK_SIZE)) then
      begin
        Vect := 3;
        PNowHead := PHeadUp;
        GameKeyZalip := True;
      end;
    end;
    37:
    begin
      if (Vect <> 2) and (GameKeyZalip <> True) and (IsFreeCoordsKeyB(Snake_Head.getX - BLOCK_SIZE, Snake_Head.getY)) then
      begin
        Vect := 1;
        PNowHead := PHeadLeft;
        GameKeyZalip := True;
      end;
    end;
    27:
    begin
      if StartedGame = True then
      begin
        ;
        gamepause.Visible := not (gamepause.Visible);
        PausedGame := not (PausedGame);
        timer_main.Enabled := not (timer_main.Enabled);
      end;
    end;
    13:
    begin
      if (StartedGame = False) and (gameoverp.Visible = True) then
      begin
        gameoverp.Visible := False;
        StartGame;
      end
      else if (gamewin.Visible = True) then
      begin
        gamewin.Visible := False;
        NextLevel;
      end
      else if (panel_win_ine.Visible = True) or (panel_win_ine2.Visible = True) or
        (panel_win_ine4.Visible = True) or (panel_win_ine5.Visible = True) then
      begin
        panel_win_ine.Visible := False;
        panel_win_ine2.Visible := False;
        panel_win_ine4.Visible := False;
        panel_win_ine5.Visible := False;
        StartGame;
      end;
    end;
    88:
    begin
      if StartedGame = True then
        panel_info.Visible := not (panel_info.Visible);
    end;
  end;

end;

procedure Tgame_mode_2_form.FormKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    'z', 'Z':
    begin
      if GameMode <> 2 then
        timer_main.Interval := SNAKE_MIN_SPEED;
    end;
  end;
end;

procedure Tgame_mode_2_form.FormKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  case key of
    90:
    begin
      if GameMode <> 2 then
        timer_main.Interval := SNAKE_MAX_SPEED;
    end;
  end;

  if GameKeyZalip = True then
    GameKeyZalip := False;
end;

procedure Tgame_mode_2_form.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

end;

//Отрисовка каждые 0,3 сек
procedure Tgame_mode_2_form.FormPaint(Sender: TObject);
var
  i: integer;
begin
  if StartedGame = True then
  begin
    {Фон}
    Canvas.Draw(0,0,PBackground);

    {Отогружаем карту}
    LoadMap;

    {Отрисовываем хвост}
    for i := 1 to Lenght do
      Canvas.Draw(Snake_Tail[i].getX, Snake_Tail[i].getY, Snake_Tail[i].getBitmap);

    {Отрисовка головы}
    Canvas.Draw(Snake_Head.getX, Snake_Head.getY, PNowHead);

    {Отрисовка мобов}

    for i := 1 to MOBS_ON_FORM do
    begin
      if Snake_Mobs[i].getVisComp = 1 then
      begin
        Canvas.Draw(Snake_Mobs[i].getX, Snake_Mobs[i].getY, Snake_Mobs[i].getBitmap);
      end;
    end;

    {Отрисовка киллеров}
    for i := 1 to KILLERS_ON_FORM do
    begin
      if Snake_Killers[i].getVisComp = 1 then
      begin
        Canvas.Draw(Snake_Killers[i].getX, Snake_Killers[i].getY,
          Snake_Killers[i].getBitmap);
      end;
    end;
  end;
end;

procedure Tgame_mode_2_form.lb_restartClick(Sender: TObject);
begin
  StartGame;
  gameoverp.Visible := False;
end;

procedure Tgame_mode_2_form.timer_keyboardTimer(Sender: TObject);
begin
  {Двигаем мобов}
  MobsMove;
  KillerMove;
end;

procedure Tgame_mode_2_form.timer_mainTimer(Sender: TObject);
begin
  {Двигаем змейку}
  Move;

  {Обработчик возможных событий при движении}
  OnMove;

  {Обновление кадра}
  Refresh;
end;

procedure Tgame_mode_2_form.timer_realTimer(Sender: TObject);
begin
  //Анимация портала
  if (GameMode = 3) then
  begin
    if SpPortal.getVisComp = 1 then
    begin
      if SpPortal.getMode = 1 then
      begin
        SpPortal.SetMode(0);
        SpPortal.setBitmap(PPortalBefore);
      end
      else
      begin
        SpPortal.SetMode(1);
        SpPortal.setBitmap(PPortalAfter);
      end;
    end;
  end;
end;

{Функция перехода на следующий уровень}
procedure Tgame_mode_2_form.NextLevel;
var
  crdname: string;
begin
  //Получаем уровень с карты
  Inc(GameLevel);
  if GameLevel <= 5 then
  begin
    //Генерируем название карты
    crdname := 'map_0' + IntToStr(GameLevel) + '.map';

    //Открываем карту
    OpenCard(crdname);

    //Убираем панель, начинаем игру
    gmpn.Visible := False;
    panel_info_fm.Visible := False;
    case GameMode of
      1:
      begin
        panel_win_ine.Visible := True;
        N.Caption := IntToStr(GamePlan);
      end;
      2:
      begin
        panel_win_ine2.Visible := True;
        N1.Caption := IntToStr(GamePlan);
      end;
      3:
      begin
        panel_win_ine4.Visible := True;
        N3.Caption := IntToStr(GamePlan);
      end;
      4:
      begin
        panel_win_ine5.Visible := True;
        N4.Caption := IntToStr(GamePlan);
      end;
    end;

  end
  else
  begin
    ShowMessage('Следующих уровней в игре нет!');
    ClearGame;
  end;
end;

procedure Tgame_mode_2_form._lv_exitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure Tgame_mode_2_form._startgame1Click(Sender: TObject);
begin
  panel_win_ine.Visible := False;
  StartGame;
end;

procedure Tgame_mode_2_form._startgame2Click(Sender: TObject);
begin
  panel_win_ine2.Visible := False;
  StartGame;
end;

procedure Tgame_mode_2_form._startgame3Click(Sender: TObject);
begin
  panel_win_ine4.Visible := False;
  StartGame;
end;

procedure Tgame_mode_2_form._startgame5Click(Sender: TObject);
begin
  panel_win_ine5.Visible := False;
  StartGame;
end;

procedure Tgame_mode_2_form._title2Click(Sender: TObject);
begin

end;

procedure Tgame_mode_2_form.SetGameSeason(season: integer);
begin
  GameSeason := season;
end;

procedure Tgame_mode_2_form._lv1Click(Sender: TObject);
var
  crdname: string;
begin
  //Получаем уровень с карты
  GameLevel := (Sender as TLabel).Tag;

  //Генерируем название карты
  crdname := 'map_0' + IntToStr((Sender as TLabel).Tag) + '.map';
  //Приводим к типу

  //Открываем карту
  OpenCard(crdname);

  if KILL <> true then begin
  //Убираем панель, начинаем игру
  gmpn.Visible := False;

  case GameMode of
    1:
    begin
      panel_win_ine.Visible := True;
      N.Caption := IntToStr(GamePlan);
    end;
    2:
    begin
      panel_win_ine2.Visible := True;
      N1.Caption := IntToStr(GamePlan);
    end;
    3:
    begin
      panel_win_ine4.Visible := True;
      N3.Caption := IntToStr(GamePlan);
    end;
    4:
    begin
      panel_win_ine5.Visible := True;
      N4.Caption := IntToStr(GamePlan);
    end;
  end;
  end
  else begin
     ShowMessage('Критическая ошибка!');
  end;
end;

procedure Tgame_mode_2_form.ClearGame;
var
  i: integer;
begin
  Objects := nil;
  BLOCKS_ON_FORM := 0;
  MOBS_ON_FORM := 0;
  FOOD_ON_FORM := 0;
  BL_ON_FORM := 0;
  GameLevel := 0;
  GamePlan := 0;
  KILLERS_ON_FORM:=0;
  PausedGame := False;
  StartedGame := False;
  gmpn.Visible := True;
  gameoverp.Visible := False;
  gamepause.Visible := False;
  gamewin.Visible := False;
  KILL:=False;
  panel_info_fm.Visible := False;
  if GameMode = 3 then
  begin
    SpPortal.SetVisComp(0);
    SpPortal.setBitmap(PPortalBefore);
  end;
  timer_main.Enabled := False;
  timer_real.Enabled := False;
end;

end.
