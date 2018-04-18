unit source;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tform_source }

  Tform_source = class(TForm)
    source_code: TMemo;
    source_files: TRadioGroup;
    procedure source_filesClick(Sender: TObject);
  private

  public

  end;

var
  form_source: Tform_source;

implementation

{$R *.lfm}

{ Tform_source }

procedure Tform_source.source_filesClick(Sender: TObject);
begin
    source_code.Clear;
  source_code.Lines.LoadFromFile(source_files.Items[source_files.ItemIndex]);
end;

end.

