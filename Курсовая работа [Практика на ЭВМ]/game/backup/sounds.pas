unit sounds;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, mmsystem;
type
    TsoundMaker = class
      private

      public
            procedure playSound(musicPath: string);
    end;
implementation

procedure TsoundMaker.playSound(musicPath: string);
begin
  if FileExists(musicPath) then
     sndPlaySound(musicPath, SND_ASYNC or SND_NODEFAULT)
  else

end;

end.

