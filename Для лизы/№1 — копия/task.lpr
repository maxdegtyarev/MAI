program task;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, author, source, help
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tform_main, form_main);
  Application.CreateForm(Tform_author, form_author);
  Application.CreateForm(Tform_source, form_source);
  Application.CreateForm(Tform_help, form_help);
  Application.Run;
end.

