unit ain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  f: TextFile;
  a: string;
begin
  if (OpenDialog1.Execute) then
  begin
    ;
    Label1.Caption := OpenDialog1.FileName;
    AssignFile(f, OpenDialog1.FileName);
    if (IORESULT <> 0) then
      label1.Caption := 'Not found';
    Reset(f);
    ReadLn(f, a);
    Label1.Caption := a;
    CloseFile(f);
  end;
end;

end.
