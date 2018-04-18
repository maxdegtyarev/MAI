unit game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { Tmain_form }

  Tmain_form = class(TForm)
    game_playbuttonid0: TButton;
    game_playbuttonid1: TButton;
    game_playbuttonid10: TButton;
    game_playbuttonid11: TButton;
    game_playbuttonid12: TButton;
    game_playbuttonid13: TButton;
    game_playbuttonid14: TButton;
    game_playbuttonid15: TButton;
    game_playbuttonid16: TButton;
    game_playbuttonid17: TButton;
    game_playbuttonid18: TButton;
    game_playbuttonid19: TButton;
    game_playbuttonid2: TButton;
    game_playbuttonid20: TButton;
    game_playbuttonid21: TButton;
    game_playbuttonid22: TButton;
    game_playbuttonid23: TButton;
    game_playbuttonid24: TButton;
    game_playbuttonid25: TButton;
    game_playbuttonid26: TButton;
    game_playbuttonid27: TButton;
    game_playbuttonid28: TButton;
    game_playbuttonid29: TButton;
    game_playbuttonid3: TButton;
    game_playbuttonid30: TButton;
    game_playbuttonid31: TButton;
    game_playbuttonid32: TButton;
    game_playbuttonid33: TButton;
    game_playbuttonid34: TButton;
    game_playbuttonid35: TButton;
    game_playbuttonid4: TButton;
    game_playbuttonid5: TButton;
    game_playbuttonid6: TButton;
    game_playbuttonid7: TButton;
    game_playbuttonid8: TButton;
    game_playbuttonid9: TButton;
    MainMenu: TMainMenu;
    main_file: TMenuItem;
    main_exit: TMenuItem;
    main_help: TMenuItem;
    main_help_author: TMenuItem;
    main_help_help: TMenuItem;
    main_help_source: TMenuItem;
    main_reset: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure game_playbuttonid0Click(Sender: TObject);
    procedure main_exitClick(Sender: TObject);
    procedure main_help_authorClick(Sender: TObject);
    procedure main_help_helpClick(Sender: TObject);
    procedure main_help_sourceClick(Sender: TObject);
    procedure main_resetClick(Sender: TObject);
  private

  public

  end;

var
  main_form: Tmain_form;
  Buttons: array[0..35] of TButton;
  SelectedWord: string;
  words: array[0..35] of string;
  index1,index2, counter, bts: integer;
  wd: array[0..18] of string;

implementation

uses
  Source,
  help,
  author;

{$R *.lfm}

{ Tmain_form }
procedure HideButtons();
var
  i: integer;
begin
  for i := 0 to 35 do
  begin
    Buttons[i].Caption := '';
  end;
end;

procedure ShowButtons();
var
  i: integer;
begin
  for i := 0 to 35 do
  begin
    if not (words[i] = 'DELETED') then
    begin
      Buttons[i].Visible := True;
      Buttons[i].Caption := words[i];
    end
    else
    begin
      Buttons[i].Visible := False;
    end;
  end;
end;

procedure SetBts();
var
  i, seed, meed, k: integer;
begin
  bts := 36;
  counter := 0;
  meed := 0;
  k := 0;
  seed := 0;
  i := 0;
  randomize;

  while (i < 17) do
  begin
    if ((words[k] = '') and (seed <> k)) then
    begin
      seed := k;
      words[k] := wd[i];
      Inc(meed);
    end;
    if (meed = 2) then
    begin
      meed := 0;
      Inc(i);
    end;
    k := random(35);
  end;
  k := random(2);
  //Ещё напоследок
  for i := 0 to 35 do
  begin
    if (words[i] = '') then
     words[i] := wd[17 + k];
     Buttons[i].Caption := words[i];
  end;
end;

procedure Tmain_form.FormCreate(Sender: TObject);
begin

  //Да, решение крайне каверзное и неэффективное, но другого я пока что не придумал
  Buttons[0] := game_playbuttonid0;
  Buttons[1] := game_playbuttonid1;
  Buttons[2] := game_playbuttonid2;
  Buttons[3] := game_playbuttonid3;
  Buttons[4] := game_playbuttonid4;
  Buttons[5] := game_playbuttonid5;
  Buttons[6] := game_playbuttonid6;
  Buttons[7] := game_playbuttonid7;
  Buttons[8] := game_playbuttonid8;
  Buttons[9] := game_playbuttonid9;
  Buttons[10] := game_playbuttonid10;
  Buttons[11] := game_playbuttonid11;
  Buttons[12] := game_playbuttonid12;
  Buttons[13] := game_playbuttonid13;
  Buttons[14] := game_playbuttonid14;
  Buttons[15] := game_playbuttonid15;
  Buttons[16] := game_playbuttonid16;
  Buttons[17] := game_playbuttonid17;
  Buttons[18] := game_playbuttonid18;
  Buttons[19] := game_playbuttonid19;
  Buttons[20] := game_playbuttonid20;
  Buttons[21] := game_playbuttonid21;
  Buttons[22] := game_playbuttonid22;
  Buttons[23] := game_playbuttonid23;
  Buttons[24] := game_playbuttonid24;
  Buttons[25] := game_playbuttonid25;
  Buttons[26] := game_playbuttonid26;
  Buttons[27] := game_playbuttonid27;
  Buttons[28] := game_playbuttonid28;
  Buttons[29] := game_playbuttonid29;
  Buttons[30] := game_playbuttonid30;
  Buttons[31] := game_playbuttonid31;
  Buttons[32] := game_playbuttonid32;
  Buttons[33] := game_playbuttonid33;
  Buttons[34] := game_playbuttonid34;
  Buttons[35] := game_playbuttonid35;

  //Массив слов
  wd[0] := 'Моцарелла';
  wd[1] := 'Мимика';
  wd[2] := 'Кобра';
  wd[3] := 'Лагранж';
  wd[4] := 'Физика';
  wd[5] := 'Металл';
  wd[6] := 'Интеграл';
  wd[7] := 'Графика';
  wd[8] := 'Мемы';
  wd[9] := 'Полиномы';
  wd[10] := 'Мономы';
  wd[11] := 'Подарок';
  wd[12] := 'Дискретно';
  wd[13] := 'Помидор';
  wd[14] := 'Автор';
  wd[15] := 'Параметр';
  wd[16] := 'Зонт';
  wd[17] := 'Архив';
  wd[18] := 'Кек';

  index1 := -1;
  index2:= -1;
  SetBts();
end;

procedure Tmain_form.game_playbuttonid0Click(Sender: TObject);
begin
  (Sender as TButton).Caption := words[(Sender as TButton).TabOrder];
  Inc(counter);
  if (((index1 <> -1) or (index2 <> -1)) and (SelectedWord= '')) then begin
      Buttons[index1].Caption := '';
      Buttons[index2].Caption:= '';
  end;
  if ((SelectedWord = '')) then
  begin
    SelectedWord := (Sender as TButton).Caption;
    index1 := (Sender as TButton).TabOrder;
    HideButtons();
    Buttons[index1].Caption := SelectedWord;
  end
  else
  begin
    if ((words[(Sender as TButton).TabOrder] = SelectedWord) and
      (not (index1 = (Sender as TButton).TabOrder)) and (index1 <> index2)) then
    begin
      bts := bts - 2;
      (Sender as TButton).Caption := words[(Sender as TButton).TabOrder];
      //Sleep(1000);
      words[index1] := 'DELETED';
      words[(Sender as TButton).TabOrder] := 'DELETED';
      Buttons[index1].Visible := False;
      (Sender as TButton).Visible := False;
      SelectedWord := '';
      index1 := -1;
      index2:= -1;
      if (bts = 0) then
      begin
        ShowMessage('Вы победили! Кликов: ' + IntToStr(counter));
      end;
    end
    else
    begin
      index2:= (Sender as TButton).TabOrder;
      (Sender as TButton).Caption := Words[(Sender as TButton).TabOrder];
      selectedWord := '';
    end;
  end;
end;

procedure Tmain_form.main_exitClick(Sender: TObject);
begin
  main_form.Close;
end;

procedure Tmain_form.main_help_authorClick(Sender: TObject);
begin
  author.form_author.Show;
end;

procedure Tmain_form.main_help_helpClick(Sender: TObject);
begin
  help.form_help.Show;
end;

procedure Tmain_form.main_help_sourceClick(Sender: TObject);
begin
  Source.form_sc.Show;
end;

procedure Tmain_form.main_resetClick(Sender: TObject);
var
  i: integer;
begin
  bts := 36;
  counter := 0;
  for i := 0 to 35 do
  begin
    words[i] := '';
    Buttons[i].Visible := True;
  end;
  setbts();
end;



end.
