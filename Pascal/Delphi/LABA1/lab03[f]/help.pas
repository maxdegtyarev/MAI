unit help;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { Tform_help }

  Tform_help = class(TForm)
    help_text: TMemo;
  private

  public

  end;

var
  form_help: Tform_help;

implementation

{$R *.lfm}

end.

