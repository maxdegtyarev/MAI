program task1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, about, source, help
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tform_Main, form_Main);
  Application.CreateForm(Tform_about, form_about);
  Application.CreateForm(Tform_source, form_source);
  Application.CreateForm(Tform_help, form_help);
  Application.Run;
end.

