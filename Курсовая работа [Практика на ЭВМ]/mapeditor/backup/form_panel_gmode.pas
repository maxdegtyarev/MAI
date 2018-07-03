unit form_panel_gmode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Spin;

type

  { Tform_panel_mode }

  Tform_panel_mode = class(TForm)
    cm_1: TComboBox;
    lb_1: TLabel;
    gm0pan: TPanel;
    lb_2: TLabel;
    sp1: TSpinEdit;
    procedure cm_1Change(Sender: TObject);
    procedure sp1Change(Sender: TObject);
  private

  public

  end;

var
  form_panel_mode: Tform_panel_mode;

implementation
uses
  card_editor;
{$R *.lfm}

{ Tform_panel_mode }

procedure Tform_panel_mode.sp1Change(Sender: TObject);
begin
  card_editor.codeplan:=sp1.Value;
end;

procedure Tform_panel_mode.cm_1Change(Sender: TObject);
begin
  card_editor.codemap:=cm_1.ItemIndex+1;
  case cm_1.ItemIndex of
       0: gm0pan.Visible:=True;
       1: gm0pan.Visible:=True;
       2: gm0pan.Visible:=True;
       3: gm0pan.Visible:=true;
  end;
end;

end.

