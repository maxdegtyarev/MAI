unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { Tform_About }

  Tform_About = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  form_About: Tform_About;

implementation

{$R *.lfm}

{ Tform_About }

procedure Tform_About.BitBtn1Click(Sender: TObject);
begin
  form_About.Close;
end;

end.

