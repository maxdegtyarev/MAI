program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, card_editor, form_panel_obs, form_panel_gmode
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tredact, redact);
  Application.CreateForm(Tform_panel_obj, form_panel_obj);
  Application.CreateForm(Tform_panel_mode, form_panel_mode);
  Application.Run;
end.

