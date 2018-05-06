unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { Tform_Main }

  Tform_Main = class(TForm)
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  form_Main: Tform_Main;

implementation

{$R *.lfm}

{ Tform_Main }

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  form_Main.Canvas.Pen.Color:=clWhite;
  form_Main.Canvas.Pen.;
end;

end.

