unit firstlab;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, Math;
const
  usedNums: set of char = ['0'..'9', '+', '-', '*', '/', 'd', 'm'];
type
  { TMainForm }

  TMainForm = class(TForm)
    button_div: TButton;
    button_procent: TButton;
    button_rez: TButton;
    button_plus: TButton;
    button_minus: TButton;
    button_umn: TButton;
    button_del: TButton;
    button_cans: TButton;
    button_c: TButton;
    button_clear: TButton;
    button_ziro: TButton;
    button_one: TButton;
    button_two: TButton;
    button_three: TButton;
    button_four: TButton;
    button_five: TButton;
    button_six: TButton;
    button_seven: TButton;
    button_eigth: TButton;
    button_nine: TButton;
    button_negate: TButton;
    button_punct: TButton;
    lb_result: TLabel;
    lb_num: TLabel;
    menum: TMainMenu;
    menu_help_source: TMenuItem;
    menu_help_help: TMenuItem;
    menu_help_author: TMenuItem;
    menu_file_exit: TMenuItem;
    menu_file: TMenuItem;
    menu_help: TMenuItem;
    procedure button_cansClick(Sender: TObject);
    procedure button_cClick(Sender: TObject);
    procedure button_clearClick(Sender: TObject);
    procedure button_delClick(Sender: TObject);
    procedure button_divClick(Sender: TObject);
    procedure button_minusClick(Sender: TObject);
    procedure button_negateClick(Sender: TObject);
    procedure button_oneClick(Sender: TObject);
    procedure button_oneKeyPress(Sender: TObject; var Key: char);
    procedure button_plusClick(Sender: TObject);
    procedure button_procentClick(Sender: TObject);
    procedure button_punctClick(Sender: TObject);
    procedure button_rezClick(Sender: TObject);
    procedure button_sqrClick(Sender: TObject);
    procedure button_sqrtClick(Sender: TObject);
    procedure button_umnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menu_file_exitClick(Sender: TObject);
    procedure menu_help_authorClick(Sender: TObject);
    procedure menu_help_helpClick(Sender: TObject);
    procedure menu_help_sourceClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Mem1, Mem2, Rez: real;
  usedPunc: boolean;

implementation
uses
  Author,
  source,
  help;
{$R *.lfm}

{ TMainForm }

procedure TMainForm.menu_file_exitClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.menu_help_authorClick(Sender: TObject);
begin
  author.form_author.Show;
end;

procedure TMainForm.menu_help_helpClick(Sender: TObject);
begin
  help.form_help.Show;
end;

procedure TMainForm.menu_help_sourceClick(Sender: TObject);
begin
  source.form_source.show;
end;

procedure TMainForm.button_oneClick(Sender: TObject);
var
  str: string;
begin
  str := lb_num.Caption;
  if (str.Length < 15) then
  begin
    lb_num.Caption := lb_num.Caption + (Sender as TButton).Caption;
  end;
end;

procedure TMainForm.button_oneKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TMainForm.button_plusClick(Sender: TObject);
begin
  if ((lb_num.Caption <> '')) then
  begin
    Rez := Rez + StrToFloat(lb_num.Caption);
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);

  end;
end;

procedure TMainForm.button_procentClick(Sender: TObject);
begin
    if ((lb_num.Caption <> '')) then begin
  if (Round(StrToFloat(lb_num.Caption)) <> 0) then
  begin
    Rez := Round(Rez) mod Round(StrToFloat(lb_num.Caption));
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);
  end
  else
    ShowMessage('Деление на нуль!');

  end;
end;

procedure TMainForm.button_punctClick(Sender: TObject);
begin
  if ((lb_num.Caption <> '')) then
  begin
    if (usedPunc = False) then
    begin
      lb_num.Caption := lb_num.Caption + ',';
      usedPunc := True;
    end;

  end;
end;

procedure TMainForm.button_rezClick(Sender: TObject);
  begin
    if ((lb_num.Caption <> '')) then
    begin
      Rez :=  StrToFloat(lb_num.Caption);
      lb_num.Caption := '';
      lb_result.Caption := FloatToStr(Rez);
    end;
end;

procedure TMainForm.button_sqrClick(Sender: TObject);
begin
    Rez := Rez * Rez;
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);
end;

procedure TMainForm.button_sqrtClick(Sender: TObject);
begin

end;

procedure TMainForm.button_umnClick(Sender: TObject);
begin
  if ((lb_num.Caption <> '')) then
  begin
    Rez := Rez * StrToFloat(lb_num.Caption);
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);
  end;
end;

procedure TMainForm.button_negateClick(Sender: TObject);
begin
  lb_num.Caption := FloatToStr((-1) * StrToFloat(lb_num.Caption));
  lb_result.Caption := FloatToStr(Rez);
end;

procedure TMainForm.button_cansClick(Sender: TObject);
var
  current: string;
begin
  if ((lb_num.Caption <> '')) then
  begin
    current := lb_num.Caption;
    if (current[current.Length] = ',') then
      UsedPunc := False;
    Delete(current, current.Length, 1);
    lb_num.Caption := current;

  end;
end;

procedure TMainForm.button_cClick(Sender: TObject);
begin
  lb_num.Caption:= '';
  usedPunc:= false;
end;

procedure TMainForm.button_clearClick(Sender: TObject);
begin
  Rez:= 0;
  lb_num.Caption:= '';
  lb_result.Caption:= '0';
  usedPunc:= false;
end;

procedure TMainForm.button_delClick(Sender: TObject);
begin
  if ((lb_num.Caption <> '')) then begin
  if ((StrToFloat(lb_num.Caption) <> 0)) then
  begin
    Rez := Rez / StrToFloat(lb_num.Caption);
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);
  end
  else
    ShowMessage('Деление на нуль!');

  end;
end;

procedure TMainForm.button_divClick(Sender: TObject);
begin
    if ((lb_num.Caption <> '')) then begin
  if (Round(StrToFloat(lb_num.Caption)) <> 0) then
  begin
    Rez := Round(Rez) div Round(StrToFloat(lb_num.Caption));
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);
  end
  else
    ShowMessage('Деление на нуль!');

  end;
end;

procedure TMainForm.button_minusClick(Sender: TObject);
var
  str: string;
begin
  if ((lb_num.Caption <> '')) then
  begin
    Rez := Rez - StrToFloat(lb_num.Caption);
    lb_num.Caption := '';
    lb_result.Caption := FloatToStr(Rez);

  end
  else begin
    str:= lb_num.Caption;
    if str = '' then str:= ' ';
    if (str[1] <> '-') then begin str:= '-'; end;
    lb_num.CAPTION:= str;
  end;
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Mem1 := 0;
  Mem2 := 0;
  Rez := 0;
end;


end.
