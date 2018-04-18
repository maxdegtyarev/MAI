unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    sg: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  sg.Cells[0,0]:= 'Kek';
  sg.Cells[sg.ColCount-1, sg.RowCount - 1] := 'Kek';
  if goEditing in sg.Options then begin
      sg.Options:= sg.Options - [goEditing];
  end
  else
  begin
     sg.Options:= sg.Options + [goEditing];
  //sg.ColCount:= seCol.Value //TextBox
  //sg.RowCount:= seRow.Value //TextBox
end;

  end;
end;

end.

