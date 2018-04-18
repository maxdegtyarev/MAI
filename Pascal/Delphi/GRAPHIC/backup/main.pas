unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  x: integer;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Canvas.Pen.Color:= clGreen; //RGBTOCOLOR(..);
  Form1.Canvas.Pen.Style:= psDashDot;
  Form1.Canvas.Pen.Width:=5;
  Form1.Canvas.Brush.Color:= clRed;
  Form1.Canvas.Rectangle(10,10,100,100);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
    Form1.Canvas.Pen.Color:= clGreen; //RGBTOCOLOR(..);
  Form1.Canvas.Pen.Style:= psDashDot;
  Form1.Canvas.Pen.Width:=5;
  Form1.Canvas.Brush.Color:= clRed;
  randomize;
  Form1.Canvas.Rectangle(random(x),random(x)+10,random(x)+100,random(x));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  inc(x);
  Repaint;
  update;
end;

end.

