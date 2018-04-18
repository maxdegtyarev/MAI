program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, game, source, help, author
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tmain_form, main_form);
  Application.CreateForm(Tform_sc, form_sc);
  Application.CreateForm(Tform_help, form_help);
  Application.CreateForm(Tform_author, form_author);
  Application.Run;
end.

