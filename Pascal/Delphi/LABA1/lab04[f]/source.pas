unit source;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tform_sc }

  Tform_sc = class(TForm)
    source_code: TMemo;
    source_files: TRadioGroup;
    procedure source_filesClick(Sender: TObject);
  private

  public

  end;

var
  form_sc: Tform_sc;

implementation

{$R *.lfm}

{ Tform_sc }

procedure Tform_sc.source_filesClick(Sender: TObject);
begin
  source_code.Clear;
  source_code.Lines.LoadFromFile(source_files.Items[source_files.ItemIndex]);
end;


end.

