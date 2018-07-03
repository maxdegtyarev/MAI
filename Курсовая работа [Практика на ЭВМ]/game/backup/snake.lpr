program snake;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, form_main, card_editor, form_panel_obs,
  form_select_mode, mechanics, form_game_mode_2, form_panel_gmode, GR32_L
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tmain_form, main_form);
  Application.CreateForm(Tredact, redact);
  Application.CreateForm(Tform_panel_obj, form_panel_obj);
  Application.CreateForm(Tform_selectlevel, form_selectlevel);
  Application.CreateForm(Tgame_mode_2_form, game_mode_2_form);
  Application.CreateForm(Tform_panel_mode, form_panel_mode);
  Application.Run;
end.

