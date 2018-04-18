unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { Tform_Main }

  Tform_Main = class(TForm)
    button_Main: TButton;
    ed_ColorDialog: TColorDialog;
    ed_Color: TMenuItem;
    ed_OnlyRead: TMenuItem;
    ed_font: TMenuItem;
    combo_Main: TComboBox;
    edit_popup: TPopupMenu;
    edit_Main: TEdit;
    ed_FontDialog: TFontDialog;
    main_menu: TMainMenu;
    main_menu_file: TMenuItem;
    main_menu_file_exit: TMenuItem;
    main_menu_help: TMenuItem;
    memo_Main: TMemo;
    hide_button: TMenuItem;
    hide_combo: TMenuItem;
    hide_memo: TMenuItem;
    hide_edit: TMenuItem;
    button_popup: TPopupMenu;
    bm_editname: TMenuItem;
    bm_editsize: TMenuItem;
    bm_editenable: TMenuItem;
    combo_popup: TPopupMenu;
    cm_sort: TMenuItem;
    cm_add: TMenuItem;
    cm_delete: TMenuItem;
    memo_Popup: TPopupMenu;
    memo_AddStr: TMenuItem;
    memo_DeleteStr: TMenuItem;
    memo_LoadFromFile: TMenuItem;
    memo_OpenDialog: TOpenDialog;
    menu_menu_help_author: TMenuItem;
    menu_menu_help_help: TMenuItem;
    menu_menu_help_source: TMenuItem;
    popup_Window: TPopupMenu;
    procedure bm_editenableClick(Sender: TObject);
    procedure bm_editnameClick(Sender: TObject);
    procedure bm_editsizeClick(Sender: TObject);
    procedure cm_addClick(Sender: TObject);
    procedure cm_deleteClick(Sender: TObject);
    procedure cm_sortClick(Sender: TObject);
    procedure ed_ColorClick(Sender: TObject);
    procedure ed_fontClick(Sender: TObject);
    procedure ed_OnlyReadClick(Sender: TObject);
    procedure hide_buttonClick(Sender: TObject);
    procedure hide_comboClick(Sender: TObject);
    procedure hide_editClick(Sender: TObject);
    procedure hide_memoClick(Sender: TObject);
    procedure main_menu_file_exitClick(Sender: TObject);
    procedure memo_AddStrClick(Sender: TObject);
    procedure memo_DeleteStrClick(Sender: TObject);
    procedure memo_LoadFromFileClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure menu_menu_help_authorClick(Sender: TObject);
    procedure menu_menu_help_helpClick(Sender: TObject);
    procedure menu_menu_help_sourceClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  form_Main: Tform_Main;
  f: textfile;

implementation
uses
  author,
  Source,
  help;

{$R *.lfm}

{ Tform_Main }

procedure Tform_Main.hide_buttonClick(Sender: TObject);
begin
  button_Main.Visible := not (button_Main.Visible);
end;

procedure Tform_Main.bm_editsizeClick(Sender: TObject);
begin
  button_Main.Height := (1 + random(55));
  button_Main.Width := (1 + random(55));
end;

procedure Tform_Main.cm_addClick(Sender: TObject);
var
  texter: array[1..6] of string;
begin
  texter[1] := 'Сало';
  texter[2] := 'Молоко';
  texter[3] := 'Яблоки';
  texter[4] := 'Колбаса';
  texter[5] := 'Москва';
  texter[6] := 'Алгоритм';
  combo_Main.Items.Add(texter[random(6)]);
end;

procedure Tform_Main.cm_deleteClick(Sender: TObject);
begin
    combo_Main.Items.Delete(combo_Main.Items.Count-1);
end;

procedure Tform_Main.cm_sortClick(Sender: TObject);
begin
  combo_Main.Sorted := not (combo_Main.Sorted);
end;

procedure Tform_Main.ed_ColorClick(Sender: TObject);
begin
    if (ed_ColorDialog.Execute) then begin
      edit_Main.Color:=ed_ColorDialog.Color;
    end;
end;

procedure Tform_Main.ed_fontClick(Sender: TObject);
begin
  if ed_FontDialog.Execute then begin
    edit_Main.Font := ed_FontDialog.Font;
  end;
end;

procedure Tform_Main.ed_OnlyReadClick(Sender: TObject);
begin
  edit_Main.ReadOnly:=not(edit_Main.ReadOnly);
end;

procedure Tform_Main.bm_editnameClick(Sender: TObject);
var
  texter: array[1..3] of string;
begin
  texter[1] := 'Сало';
  texter[2] := 'Молоко';
  texter[3] := 'Яблоки';
  button_Main.Caption := texter[random(3)];
end;

procedure Tform_Main.bm_editenableClick(Sender: TObject);
begin
  button_Main.AutoSize := not (button_Main.AutoSize);
end;

procedure Tform_Main.hide_comboClick(Sender: TObject);
begin
  combo_Main.Visible := not (combo_Main.Visible);
end;

procedure Tform_Main.hide_editClick(Sender: TObject);
begin
  edit_Main.Visible := not (edit_Main.Visible);
end;

procedure Tform_Main.hide_memoClick(Sender: TObject);
begin
  memo_Main.Visible := not (memo_Main.Visible);
end;

procedure Tform_Main.main_menu_file_exitClick(Sender: TObject);
begin
  form_Main.Close;
end;

procedure Tform_Main.memo_AddStrClick(Sender: TObject);
begin
  memo_Main.Lines.Add('String');
end;

procedure Tform_Main.memo_DeleteStrClick(Sender: TObject);
begin
  memo_Main.Lines.Delete(memo_Main.Lines.Count-1);
end;

procedure Tform_Main.memo_LoadFromFileClick(Sender: TObject);
 var
   S: string;
begin
  if ((memo_OpenDialog.Execute) and (memo_OpenDialog.FileName <> '')) then begin
    AssignFile(f,memo_OpenDialog.FileName);
    {$I-}
    reset(f);
    {$I+}
    if IORESULT <> 0 then
    begin
      ShowMessage('Ошибка файла!');
      Self.Close;
      Exit;
    end;
    while (not(EOF(f))) do begin
      read(F,S);
      memo_Main.Lines.Add(S);
    end;

    closeFile(f);
  end;
end;

procedure Tform_Main.MenuItem2Click(Sender: TObject);
begin

end;

procedure Tform_Main.menu_menu_help_authorClick(Sender: TObject);
begin
  author.form_author.Show;
end;

procedure Tform_Main.menu_menu_help_helpClick(Sender: TObject);
begin
  help.form_help.Show;
end;

procedure Tform_Main.menu_menu_help_sourceClick(Sender: TObject);
begin
  Source.form_source.Show;
end;

end.

