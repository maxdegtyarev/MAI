unit form_select_mode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons ;

type

  { Tform_selectlevel }

  Tform_selectlevel = class(TForm)
    btn_startgame: TButton;
    cmb_mode: TComboBox;
    lb_title: TLabel;
    lb_selrezh: TLabel;
    procedure btn_startgameClick(Sender: TObject);
    procedure cmb_modeChange(Sender: TObject);
  private

  public

  end;

var
  form_selectlevel: Tform_selectlevel;

implementation
uses
  form_game_mode_2;
{$R *.lfm}

{ Tform_selectlevel }

procedure Tform_selectlevel.cmb_modeChange(Sender: TObject);
begin

end;

procedure Tform_selectlevel.btn_startgameClick(Sender: TObject);
begin
  game_mode_2_form.SetGameSeason(cmb_mode.ItemIndex+1);
  Self.Visible:=false;
end;
end.

