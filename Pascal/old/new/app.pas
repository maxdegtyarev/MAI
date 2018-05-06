unit app;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { Tform_Main }

  Tform_Main = class(TForm)
    MainMenu1: TMainMenu;
    About: TMenuItem;
    Help: TMenuItem;
    Exitt: TMenuItem;
    MyFile: TMenuItem;
    Spravka: TMenuItem;
    Source: TMenuItem;
    procedure AboutClick(Sender: TObject);
    procedure ExittClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure HelpClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
  {
   About, Help к программе, source(окно с исходным кодом приложения)
  }
var
  form_Main: Tform_Main;

implementation
uses about;
{$R *.lfm}

{ Tform_Main }


procedure Tform_Main.MenuItem1Click(Sender: TObject);
begin

end;

procedure Tform_Main.ExittClick(Sender: TObject);
begin
  form_Main.Close;
end;

procedure Tform_Main.AboutClick(Sender: TObject);
begin
     form_About.ShowModal;
end;

procedure Tform_Main.HelpClick(Sender: TObject);
begin

end;

end.

