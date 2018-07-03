unit soundsplayer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,mmsystem ;


implementation

procedure GameWin;
begin
  sndPlaySound('data/sounds/level_complete.wav', SND_ASYNC or SND_NODEFAULT)
end;

procedure GameMusic;
begin
  sndPlaySound('data/sounds/main.wav', SND_ASYNC or SND_NODEFAULT)
end;

end.
