unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tform_about }

  Tform_about = class(TForm)
    about_text: TMemo;
  private

  public

  end;

var
  form_about: Tform_about;

implementation

{$R *.lfm}

end.

