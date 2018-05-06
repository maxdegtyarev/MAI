unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  rain = record
    x,y,r: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;
const
     MAX_RAIN = 10;
     MAX_R = 25;

var
  Form1: TForm1;
  a: array[1..MAX_RAIN] of rain;
implementation

{$R *.lfm}

{ TForm1 }

//procedure initrain();
//var
//  i: integer;
//begin
//  randomize;
//  for i:= 1 to MAX_RAIN do begin
//    a[i].x:= random(Form1.Width - MAX_R*2)+MAX_R;
//    a[i].y:= random(Form1.Height - MAX_R*2)+MAX_R;
//    a[i].r := 1;
//  end;
//
//end;

procedure initrain(var item: rain);
var
  i: integer;
begin
  randomize;
    item.x:= random(Form1.Width - MAX_R*2)+MAX_R;
    item.y:= random(Form1.Height - MAX_R*2)+MAX_R;
    item.r := 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  for i:= 1 to MAX_RAIN do begin
      inc(a[i].r,2);
  Repaint;
  end;
  if a[1].r >= MAX_R then initrain();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  for i:= 1 to MAX_RAIN do begin
        initrain(a[i]);
        a[i].r
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
  var
  i: integer;
begin
  for i:=1 to 10 do begin
      Form1.Canvas.Ellipse(a[i].x - a[i].r,a[i].y-a[i].r,a[i].x+a[i].r,a[i].y+a[i].r);
  end;
end;

end.

