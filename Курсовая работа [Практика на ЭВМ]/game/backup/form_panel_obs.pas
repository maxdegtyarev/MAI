unit form_panel_obs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tform_panel_obj }

  Tform_panel_obj = class(TForm)
    apple: TImage;
    spider: TImage;
    portal: TImage;
    lb4: TLabel;
    melon: TImage;
    pumpkin: TImage;
    lb1: TLabel;
    killer: TImage;
    green_brick: TImage;
    lb2: TLabel;
    lb3: TLabel;
    mob1: TImage;
    mob2: TImage;
    mob3: TImage;
    mob4: TImage;
    sand: TImage;
    brick: TImage;
    brick_red: TImage;
    vect: TComboBox;
    head: TImage;
    stone: TImage;
    terrain: TImage;
    tree: TImage;
    wall: TImage;
    procedure stoneClick(Sender: TObject);
    procedure vectChange(Sender: TObject);
  private

  public

  end;

var
  form_panel_obj: Tform_panel_obj;

implementation
uses
  card_editor;
{$R *.lfm}

{ Tform_panel_obj }

procedure Tform_panel_obj.stoneClick(Sender: TObject);
begin
  if (Sender as TImage).Tag <> 6 then
     card_editor.act:= True
  else
      card_editor.act:= False;

  card_editor.brushe := (Sender as TImage).Tag;
end;

procedure Tform_panel_obj.vectChange(Sender: TObject);
begin
  if (card_editor.brushe >= 14) and (card_editor.brushe <= 17) then begin
    card_editor.vectmob:=vect.ItemIndex + 1;
  end
  else
  card_editor.vect:=vect.ItemIndex + 1;
end;

end.

