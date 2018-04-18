unit author;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { Tform_author }

  Tform_author = class(TForm)
    author_image: TImage;
    author_inf: TLabel;
  private

  public

  end;

var
  form_author: Tform_author;

implementation

{$R *.lfm}

end.

