unit help;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Thelpform }

  Thelpform = class(TForm)
    helptext: TMemo;
  private

  public

  end;

var
  helpform: Thelpform;

implementation

{$R *.lfm}

end.

