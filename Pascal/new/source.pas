unit source;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls;

type

  { Tform_Source }

  Tform_Source = class(TForm)
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
   // procedure FormCreate(Sender: TObject);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  form_Source: Tform_Source;

implementation

{$R *.lfm}

{ Tform_Source }

//procedure Tform_Source.FormCreate(Sender: TObject);
//var
//      SearchResult: TSearchRec;
//      nameoffile: string;
//begin
//     if FindFirst('*lpr', faAnyFile, searchresult) = 0 then
//     begin
//       repeat
//         nameoffile:= searchresult.name;
//         radiogroup.items.add;
//       until ;
//     end;
//end;

procedure Tform_Source.RadioGroup1SelectionChanged(Sender: TObject);
begin
 // Memo1.Lines.LoadFromFile(RadioGroup.Items[radiogroup.index])
end;

end.

