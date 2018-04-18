unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus;

type

  { Tform_Main }

  Tform_Main = class(TForm)
    checkgroup_Main: TCheckGroup;
    main_menu: TMainMenu;
    main_menu_help: TMenuItem;
    main_menu_file: TMenuItem;
    main_menu_file_exit: TMenuItem;
    main_menu_reset: TMenuItem;
    menu_menu_help_author: TMenuItem;
    menu_menu_help_source: TMenuItem;
    menu_menu_help_help: TMenuItem;
    procedure checkgroup_MainClick(Sender: TObject);
    procedure checkgroup_MainItemClick(Sender: TObject; Index: integer);
    procedure main_menu_file_exitClick(Sender: TObject);
    procedure main_menu_resetClick(Sender: TObject);
    procedure menu_menu_help_authorClick(Sender: TObject);
    procedure menu_menu_help_helpClick(Sender: TObject);
    procedure menu_menu_help_sourceClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  form_Main: Tform_Main;
  clicks: integer;
  R: integer;

implementation
uses
  about,
  help,
  source;
{$R *.lfm}

{ Tform_Main }

procedure Tform_Main.checkgroup_MainClick(Sender: TObject);
begin

end;

procedure Tform_Main.checkgroup_MainItemClick(Sender: TObject; Index: integer);
var
  a, c, k: integer;
begin
  clicks := clicks + 1;
  a := Index mod 6;
  k := Index - a;

  for c := 0 to 5 do
  begin
    if (a > 35) then
      a := 35;
    checkgroup_Main.Checked[a] := not (checkgroup_Main.Checked[a]);
    checkgroup_Main.Checked[k] := not (checkgroup_Main.Checked[k]);
    a := a + 6;
    k := k + 1;
  end;

  for k := 0 to 35 do
  begin
    if (checkgroup_Main.Checked[k] = True) then
      R := R + 1;
  end;

  if (R = 36) then
  begin
    ShowMessage('Поздравляем! Количество кликов: ' + FloatToStr(clicks));
  end;

  R := 0;
end;

procedure Tform_Main.main_menu_file_exitClick(Sender: TObject);
begin
  form_Main.Close();
end;

procedure Tform_Main.main_menu_resetClick(Sender: TObject);
begin
  clicks:= 0;
  R:= 0;
  for R := 0 to 35 do
  begin
    checkgroup_Main.Checked[R]:= false;
  end;
  ShowMessage('Успешно сброшено!');
end;

procedure Tform_Main.menu_menu_help_authorClick(Sender: TObject);
begin
  about.form_author.Show();
end;

procedure Tform_Main.menu_menu_help_helpClick(Sender: TObject);
begin
  help.form_help.Show();
end;

procedure Tform_Main.menu_menu_help_sourceClick(Sender: TObject);
begin
  source.form_source.Show();
end;

end.
