unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCLType,
  ExtCtrls;

const
  D = 12;
  LGH= 100;
type
  Snake = record
    Head_x, Head_y, Foot_x, Foot_y: integer;
    Speed: integer;
    Lenght: integer;
    Tail: array[0..LGH, 0..1] of integer; //Будет хранить координаты хвоста
  end;
  Block = record
    X,Y: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    main_timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure main_timerTimer(Sender: TObject);
  private
  public

  end;

var
  Form1: TForm1;
  person: Snake;
  bl: Block;
implementation

{$R *.lfm}

{ TForm1 }

procedure GetSqrt(x,y: integer);
begin
  Form1.Canvas.Rectangle(x-D,y-D,x+D,y+D);
end;

procedure GetSnake();
begin
  GetSqrt(person.Head_x, person.Head_y);
   GetSqrt(bl.x, bl.y);
end;

procedure TForm1.main_timerTimer(Sender: TObject);
begin
   repaint;
   GetSnake();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   with person do begin
     Head_x:= 50;
     Head_y:= 50;
     Lenght:= 0;
   end;

   With bl do begin
     X:= 27;
     Y:= 36;
   end;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );

begin
   case Key of
        40: begin
          person.Head_y:=person.Head_y + D;
        end;
        39: begin
          person.Head_x:= person.Head_x + D;
        end;
        38: begin
           person.Head_y:= person.Head_y - D;
        end;
        37: begin
            person.Head_x:= person.Head_x - D;

        end;
   end;
end;

end.

