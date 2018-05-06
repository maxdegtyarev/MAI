unit mainw;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    main_button_cancel: TButton;
    main_button_exp: TButton;
    main_button_exp1: TButton;
    main_button_sqrtn: TButton;
    main_button_procent: TButton;
    main_button_cos: TButton;
    main_button_sqrt: TButton;
    main_button_sqr: TButton;
    main_button_clearE: TButton;
    main_button_sin: TButton;
    main_lb_result: TLabel;
    main_text: TEdit;
    main_lb: TLabel;
    main_button_clear: TButton;
    main_button_del: TButton;
    main_button_eight: TButton;
    main_button_eqv: TButton;
    main_button_five: TButton;
    main_button_four: TButton;
    main_button_minus: TButton;
    main_button_nine: TButton;
    main_button_obr: TButton;
    main_button_one: TButton;
    main_button_plus: TButton;
    main_button_pm: TButton;
    main_button_punct: TButton;
    main_button_seven: TButton;
    main_button_six: TButton;
    main_button_three: TButton;
    main_button_two: TButton;
    main_button_umn: TButton;
    main_button_ziro: TButton;
    procedure FormCreate(Sender: TObject);
    procedure main_button_cancelClick(Sender: TObject);
    procedure main_button_plusClick(Sender: TObject);
    procedure main_button_sinClick(Sender: TObject);
    procedure main_button_ziroClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  mem: real;
  op: char;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.main_button_ziroClick(Sender: TObject);
begin
  if ((main_lb_result.Caption <> '') and (op <> 'N')) then
  begin
    main_lb_result.Caption := '';
  end
  else
  main_lb_result.Caption:= main_lb_result.Caption + (Sender as Tbutton).Caption;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mem := 0;
  op:= 'N';
end;
procedure TForm1.main_button_plusClick(Sender: TObject);
begin
  if not (op = 'N') then
  begin
    case op of
      '+': mem := mem + StrToFloat(main_lb_result.Caption);
      '-': mem := mem - StrToFloat(main_lb_result.Caption);
      '*': mem := mem * StrToFloat(main_lb_result.Caption);
      '/': mem := mem + StrToFloat(main_lb_result.Caption);
    end;
    op := 'N';
  end
  else
  begin
    mem := StrToFloat(main_lb_result.Caption);
    op := ((Sender as TButton).Caption)[1];
  end;
end;




procedure TForm1.main_button_cancelClick(Sender: TObject);
var
  str: string;
begin
  str := main_lb_result.Caption;
  Delete(str, str.Length, 1);
  main_lb_result.Caption := str;
end;

procedure TForm1.main_button_sinClick(Sender: TObject);
begin

end;

end.
