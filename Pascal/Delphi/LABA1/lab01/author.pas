unit author;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tauthor_form }

  Tauthor_form = class(TForm)
    image_Author: TImage;
    Label1: TLabel;
    procedure Label1Click(Sender: TObject);
  private

  public

  end;

var
  author_form: Tauthor_form;

implementation

{$R *.lfm}

{ Tauthor_form }

procedure Tauthor_form.Label1Click(Sender: TObject);
begin

end;

end.

