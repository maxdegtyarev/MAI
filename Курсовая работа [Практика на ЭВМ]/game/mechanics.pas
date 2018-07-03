unit mechanics;

{
     2018, Максим Дегтярев
     Основные классы игры
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  { TBase }

  TAbstract = class
    private
      x : Integer;
      y : Integer;
      bitmap : TBitmap;
      viscomp: integer;
      mode: Integer;
    public

      {Constructor}
      Constructor Init(x0,y0, v0 : Integer; texture : TBitmap);

      {Setters}
      procedure setX(x0 : Integer);
      procedure setY(y0 : Integer);
      procedure setVisComp(v0: Integer);
      procedure setBitmap(texture : TBitmap);
      procedure SetMode(value: integer);
      {Getters}
      function getX : Integer;
      function getY : Integer;
      function getVisComp: Integer;
      function getMode: Integer;
      function getBitmap : TBitmap;
  end;

  TFood = class (TAbstract) end;

  TBlock = class (TAbstract) end;

  TMob = class (TAbstract)
  private
    myvect, codemob: integer; //Направление движения моба, код моба
  public
    procedure setVect(me: integer);
    procedure setCodeMob(me: integer);

    function getCodeMob: integer;
    function getVect: integer;
  end;

  THead = class (TAbstract) end;

  TTail = class (TAbstract) end;
implementation

{ TAbstract }

{Functions}
constructor TAbstract.Init(x0, y0, v0: Integer; texture: TBitmap);
begin
  x := x0;
  y := y0;
  viscomp:=v0;
  bitmap := texture;
end;

procedure TAbstract.setX(x0: Integer);
begin
  x := x0;
end;

procedure TAbstract.setY(y0: Integer);
begin
  y := y0;
end;

procedure TAbstract.setVisComp(v0: integer);
begin
  viscomp:=v0;
end;

procedure TAbstract.SetMode(value: integer);
begin
  mode:=value;
end;

procedure TAbstract.setBitmap(texture: TBitmap);
begin
  bitmap := texture;
end;

function TAbstract.getX: Integer;
begin
  Result := x;
end;

function TAbstract.getY: Integer;
begin
  Result := y;
end;

function TAbstract.getMode: Integer;
begin
  result:= mode;
end;

function TAbstract.getVisComp: Integer;
begin
  Result:= viscomp;
end;

function TAbstract.getBitmap: TBitmap;
begin
  Result := bitmap;
end;

//Для моба

procedure TMob.setCodeMob(me: integer);
begin
  codemob:=me;
end;

procedure TMob.setVect(me: integer);
begin
  myvect:=me;
end;

function TMob.getCodeMob: integer;
begin
  result:= codemob;
end;

function TMob.getVect: integer;
begin
  result:= myvect;
end;

end.

