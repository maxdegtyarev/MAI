unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    main_button_clear: TButton;
    main_button_del: TButton;
    main_button_obr: TButton;
    main_button_umn: TButton;
    main_button_pm: TButton;
    main_promlabel: TLabel;
    main_button_eight: TButton;
    main_button_eqv: TButton;
    main_button_five: TButton;
    main_button_four: TButton;
    main_button_minus: TButton;
    main_button_nine: TButton;
    main_button_one: TButton;
    main_button_plus: TButton;
    main_button_punct: TButton;
    main_button_seven: TButton;
    main_button_six: TButton;
    main_button_three: TButton;
    main_button_two: TButton;
    main_button_ziro: TButton;
    main_form: TMainMenu;
    main_promlabelinf: TLabel;
    main_secondtext: TEdit;
    main_text: TEdit;
    menu_file: TMenuItem;
    menu_file_exit: TMenuItem;
    menu_help: TMenuItem;
    menu_help_author: TMenuItem;
    menu_help_help: TMenuItem;
    menu_help_source: TMenuItem;
    procedure main_button_clearClick(Sender: TObject);
    procedure main_button_eqvClick(Sender: TObject);
    procedure main_button_minusClick(Sender: TObject);
    procedure main_button_plusClick(Sender: TObject);
    procedure main_button_pmClick(Sender: TObject);
    procedure main_button_ziroClick(Sender: TObject);
  private
    usedZnak: boolean;
    globalChar: char;
    globalBuffer: real;
    globalMemory: real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.main_button_ziroClick(Sender: TObject);
begin
  main_text.Text := main_text.Text + (Sender as TButton).Caption;
end;

procedure TForm1.main_button_plusClick(Sender: TObject);
begin
  globalChar := '+';
  if ((main_text.Text = '') and not (usedZnak = True)) then
  begin
    usedZnak := True;
    main_secondtext.Text := main_secondtext.Text + '+';
  end;

  if ((usedZnak = True) and not (main_text.Text = '')) then
  begin
    main_secondtext.Text := main_secondtext.Text + main_text.Text;
    usedZnak := False;
    globalBuffer := globalBuffer + StrToFloat(main_text.Text);
    main_text.Clear();
  end
  else if ((usedZnak = False) and not (main_text.Text = '')) then
  begin
    main_secondtext.Text := main_secondtext.Text + '+' + main_text.Text;
    globalBuffer := globalBuffer + StrToFloat(main_text.Text);
    main_text.Clear();
  end;

  main_promlabelinf.Caption := FloatToStr(globalBuffer);
end;

procedure TForm1.main_button_pmClick(Sender: TObject);
begin
  globalBuffer := globalBuffer * (-1);
  main_promlabelinf.Caption := FloatToStr(globalBuffer);
end;

procedure TForm1.main_button_minusClick(Sender: TObject);
begin
  globalChar := '-';
  if ((main_text.Text = '') and not (usedZnak = True)) then
  begin
    usedZnak := True;
    main_secondtext.Text := main_secondtext.Text + '-';
  end;

  if ((usedZnak = True) and not (main_text.Text = '')) then
  begin
    main_secondtext.Text := main_secondtext.Text + main_text.Text;
    usedZnak := False;
    globalBuffer := globalBuffer - StrToFloat(main_text.Text);
    main_text.Clear();
  end
  else if ((usedZnak = False) and not (main_text.Text = '')) then
  begin
    main_secondtext.Text := main_secondtext.Text + '-' + main_text.Text;
    globalBuffer := globalBuffer - StrToFloat(main_text.Text);
    main_text.Clear();
  end;

  main_promlabelinf.Caption := FloatToStr(globalBuffer);
end;

procedure TForm1.main_button_eqvClick(Sender: TObject);
begin
  main_secondtext.Clear();
  if not (main_text.Text = '') then
  begin
    case globalchar of
      '+':
      begin
        globalBuffer := globalBuffer + StrToFloat(main_text.Text);
      end;
      '-':
      begin
        globalBuffer := globalBuffer - StrToFloat(main_text.Text);
      end;
    end;
  end;
  main_promlabelinf.Caption := FloatToStr(globalBuffer);

end;

procedure TForm1.main_button_clearClick(Sender: TObject);
begin
  main_promlabelinf.Caption := '';
  main_text.Clear;
  main_secondtext.Clear;
  globalBuffer:= 0;
end;

end.
