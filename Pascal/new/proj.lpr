program proj;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, app, about, source
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tform_Main, form_Main);
  Application.CreateForm(Tform_About, form_About);
  Application.CreateForm(Tform_Source, form_Source);
  Application.Run;
end.

