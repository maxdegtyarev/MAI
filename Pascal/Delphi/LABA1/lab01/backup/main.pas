unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus;

type

  { Tmain_form }

  Tmain_form = class(TForm)
    main_form: TMainMenu;
    menu_help_source: TMenuItem;
    menu_help_author: TMenuItem;
    menu_help_help: TMenuItem;
    menu_file_exit: TMenuItem;
    menu_help: TMenuItem;
    menu_file: TMenuItem;
    procedure menu_file_exitClick(Sender: TObject);
    procedure menu_help_authorClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  main_form: Tmain_form;

implementation
uses author;
{$R *.lfm}

{ Tmain_form }

procedure Tmain_form.menu_help_authorClick(Sender: TObject);
begin
  author.author_form.Show; //Показать форму
end;

procedure Tmain_form.menu_file_exitClick(Sender: TObject);
begin
  author.author_form.Close;
end;

end.

