unit form_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, mechanics,mmsystem;

const
  BLOCK_SIZE = 24; //Размер блока в игре
  BLOCK_COUNT = 25;
  //Количество блоков на поле. Оно есть квадрат
  SNAKE_MAX_LENGHT = 1500; //Максимальная длина змейки
  SNAKE_MIN_LENGHT = 2; //Минимальная длина змейки
  SNAKE_MAX_SPEED = 200;
  //Максимальная скорость змейки. Регулирует период таймера
  SNAKE_MIN_SPEED = 50;   //Мин.скорость

type

  { Tmain_form }

  Tmain_form = class(TForm)
    copur: TLabel;
    lb_obr: TLabel;
    lb_season: TLabel;
    lb_start1: TLabel;
    pn_seasons: TPanel;
    seas_1: TImage;
    seas_2: TImage;
    seas_3: TImage;
    shutup: TImage;
    imlogo: TImage;
    lb_start: TLabel;
    lb_start3: TLabel;
    timer_main: TTimer;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormPaint(Sender: TObject);
    procedure lb_obrClick(Sender: TObject);
    procedure lb_startMouseLeave(Sender: TObject);
    procedure pn_seasonsClick(Sender: TObject);
    procedure seas_1Click(Sender: TObject);
    procedure shutupClick(Sender: TObject);
    procedure StartGame;
    procedure Move;
    procedure OnMove;

    procedure btn_startgmClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lb_startClick(Sender: TObject);
    procedure lb_startMouseEnter(Sender: TObject);
    procedure timer_mainTimer(Sender: TObject);
  private

  public

  end;

var
  main_form: Tmain_form;
  Snake_Tail: array[1..10] of TTail; //Массив есть хвост
  Snake_Head: THead;
  PApple, PMelon, PPumpkin, PHead, PTail: TBitmap;
  Lenght: integer;
  vect: integer;
  cx, cy: integer;
  music: boolean;
implementation

uses
  form_game_mode_2, help;

{$R *.lfm}

{ Tmain_form }

procedure startGameMusic;
begin
  sndPlaySound('data/sounds/main.wav', SND_ASYNC or SND_NODEFAULT);
end;
procedure stopGameMusic;
begin
  sndPlaySound(nil,0);
end;

procedure Tmain_form.OnMove;
var
  i: integer;
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

  for i:= 2 to Lenght do begin;
  if ((Snake_Head.getX = CX) and (Snake_Head.getY = CY)) or ((Snake_Tail[i].getX = CX) and (Snake_Tail[i].getY = CY)) then begin
    timer_main.Interval:=20;

  end
  else
  timer_main.Interval:=300;
  end;
end;

procedure Tmain_form.Move;
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

procedure Tmain_form.StartGame;
var
  coord_x, coord_y: integer;
begin
  Lenght := 3;
  PHeadUp := TBitmap.Create();
  PHeadDown := TBitmap.Create();
  PHeadLeft := TBitmap.Create();
  PHeadRigth := TBitmap.Create();
  PTail := TBitmap.Create();
  PApple := TBitmap.Create();
  PMelon := TBitmap.Create();
  PPumpkin := TBitmap.Create();

  PHeadUp.LoadFromFile('data/sprites/head_up.bmp');
  PHeadDown.LoadFromFile('data/sprites/head_down.bmp');
  PHeadLeft.LoadFromFile('data/sprites/head_left.bmp');
  PHeadRigth.LoadFromFile('data/sprites/head_rigth.bmp');
  PTail.LoadFromFile('data/sprites/body.bmp');
  PApple.LoadFromFile('data/sprites/apple.bmp');
  PMelon.LoadFromFile('data/sprites/watermelon.bmp');
  PPumpkin.LoadFromFile('data/sprites/pumpkin.bmp');
  randomize;
  vect := 1 + Random(4);

  //Случайные координаты головы
  coord_x := Random(BLOCK_COUNT + 1) * BLOCK_SIZE;
  coord_y := Random(BLOCK_COUNT + 1) * BLOCK_SIZE;

  case vect of
    1:
      Snake_Head := THead.Init(coord_x, coord_y, 1, PHeadLeft);
    2:
      Snake_Head := THead.Init(coord_x, coord_y, 1, PHeadRigth);
    3:
      Snake_Head := THead.Init(coord_x, coord_y, 1, PHeadUp);
    4:
      Snake_Head := THead.Init(coord_x, coord_y, 1, PHeadDown);

  end;

  case vect of
    1:
    begin
      Snake_Tail[1] := TTail.Init(Snake_Head.getX + BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX + 2 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[3] := TTail.Init(Snake_Head.getX + 3 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
    end;
    2:
    begin
      Snake_Tail[1] := TTail.Init(Snake_Head.getX - BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX - 2 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
      Snake_Tail[3] := TTail.Init(Snake_Head.getX - 3 * BLOCK_SIZE,
        Snake_Head.getY, 1, PTail);
    end;
    3:
    begin
      Snake_Tail[1] := TTail.Init(Snake_Head.getX, Snake_Head.getY +
        BLOCK_SIZE, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX, Snake_Head.getY +
        2 * BLOCK_SIZE, 1, PTail);
      Snake_Tail[3] := TTail.Init(Snake_Head.getX, Snake_Head.getY +
        3 * BLOCK_SIZE, 1, PTail);
    end;
    4:
    begin
      Snake_Tail[1] := TTail.Init(Snake_Head.getX, Snake_Head.getY -
        BLOCK_SIZE, 1, PTail);
      Snake_Tail[2] := TTail.Init(Snake_Head.getX, Snake_Head.getY -
        2 * BLOCK_SIZE, 1, PTail);
      Snake_Tail[3] := TTail.Init(Snake_Head.getX, Snake_Head.getY -
        3 * BLOCK_SIZE, 1, PTail);
    end;
  end;

end;

procedure Tmain_form.FormPaint(Sender: TObject);
var
  i: integer;
begin
  {Отрисовываем хвост}
  for i := 1 to Lenght do
    Canvas.Draw(Snake_Tail[i].getX, Snake_Tail[i].getY, Snake_Tail[i].getBitmap);

  {Отрисовка головы}
  Canvas.Draw(Snake_Head.getX, Snake_Head.getY, Snake_Head.getBitmap);
end;

procedure Tmain_form.lb_obrClick(Sender: TObject);
begin
  pn_seasons.Visible:=False;
end;

procedure Tmain_form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);

begin
  cx := X - (X mod BLOCK_SIZE);
  cy := Y - (Y mod BLOCK_SIZE);
end;

procedure Tmain_form.lb_startMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := RGBToColor(0, 0, 0);
end;

procedure Tmain_form.pn_seasonsClick(Sender: TObject);
begin

end;

procedure Tmain_form.seas_1Click(Sender: TObject);
begin
  game_mode_2_form.SetGameSeason((Sender as TImage).Tag);
  game_mode_2_form.Show;
  //Self.Visible:=false;
end;

procedure Tmain_form.shutupClick(Sender: TObject);
begin
  if music = true then
     begin
       stopGameMusic;
       music:=false;
     end
  else
  begin
       startGameMusic;
       music:=True;
  end;
end;

procedure Tmain_form.btn_editClick(Sender: TObject);
begin
  //redact.Show;
end;

procedure Tmain_form.FormCreate(Sender: TObject);
begin
  {Основные задачи}
  DoubleBuffered := True; //Буферизация
  startGameMusic;
  music:=true;
  Width := BLOCK_SIZE * (BLOCK_COUNT + 1);
  Height := Width;
  StartGame;
end;


procedure Tmain_form.lb_startClick(Sender: TObject);
begin
  stopGameMusic;
  case (Sender as TLabel).Tag of
    1: pn_seasons.Visible:=true;
    2: helpform.Show;
    4: Self.Close;
  end;

end;

procedure Tmain_form.lb_startMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := TColor($0015B72E);

end;

procedure Tmain_form.timer_mainTimer(Sender: TObject);
var
  i: integer;
  tempv: integer;
begin
  Inc(i);
  if i >= 4 + Random(8) then
  begin
    tempv := 1 + Random(4);
    i := 0;
    case tempv of
      4:
      begin
        if (Vect <> 3) then
        begin
          Vect := 4;
          Snake_Head.setBitmap(PHeadDown);
        end;
      end;
      2:
      begin
        if (Vect <> 1) then
        begin
          Vect := 2;
          Snake_Head.setBitmap(PHeadRigth);
        end;
      end;
      3:
      begin
        if (Vect <> 4) then
        begin
          Vect := 3;
          Snake_Head.setBitmap(PHeadUp);
        end;
      end;
      1:
      begin
        if (Vect <> 2) then
        begin
          Vect := 1;
          Snake_Head.setBitmap(PHeadLeft);
        end;
      end;
    end;
  end;

  Move;
  OnMove;
  Refresh;

end;

procedure Tmain_form.btn_startgmClick(Sender: TObject);
begin
end;

end.
