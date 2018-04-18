unit help;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tform_help }

  Tform_help = class(TForm)
    author_image: TImage;
    author_inf: TLabel;
  private

  public

  end;

var
  form_help: Tform_help;

implementation

{$R *.lfm}

end.

