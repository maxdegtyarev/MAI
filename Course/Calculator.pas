{
        2017, �����ॢ ���ᨬ.
        ��㯯�: �80-112�-17
        �������� ��몭������� �஡��
        �����: 1.0
}

program Calculator;

uses
  Math,
  crt,
  SysUtils;

type
  Node = ^Stack;

  Stack = record
    Data: integer;
    NextElement: ^Node;
  end;

var
  FD: real;
  InputCommand: string;
  InputString: string;




  //�㭪樨 � ��楤���


  {��ࠡ��稪 �訡��}
  procedure ErrorHandler(TypeOfError: string);
  begin
    writeln('����������� ������!!! -> ' + TypeOfError);
    readln();
    halt(1);
  end;

  {�㭪�� �������஢���� ��ࠦ���� ���� x|y/z � ���筮� �᫮ ⨯� Real}
  function toR(input: string): real;
  var
    C: integer;
    R, T, F: real;
    K: boolean;
    L, G, B: string;
  begin

    C := 1;
    K := False;
    while C <= length(input) do
    begin
      if input[C] = '|' then
      begin
        K := True;
        Inc(C);
      end;
      if input[C] = '/' then
      begin
        T := StrToFloat(L);
        F := StrToFloat(G);
        Inc(C);

        while C <= length(input) do
        begin
          B := B + input[C];
          Inc(C);
        end;

        R := StrToFloat(B);
        if R = 0 then
          ErrorHandler('#1 : ����⪠ ������� �� ����. �஢���� �ଠ� �室���� ��ࠦ����');
        break;
      end;
      if not (K) then
      begin
        L := L + input[C];
      end
      else
      begin
        G := G + input[C];
      end;
      Inc(C);
    end;
    //����砥� १����
    F := F / R;
    T := T + F;
    Result := T;

  end;

begin
  writeln('���� ���������� � �������� �஡��!');

  while True do
  begin
    writeln('');
    writeln('������ ����⢨�, ���஥ �� ��� ᮢ�����:');
    writeln('������ 1, �᫨ �� ��� ����� ��ࠦ���� � ���᮫�');
    writeln('2, �᫨ �� ��� ������ ��ࠦ���� ��� ������⢮ ��ࠦ���� �� 䠩��');
    writeln('3, ��� ������ �����, ��� �� ����� ������������ � �ᥬ �㭪樮����� ');
    writeln('4, �᫨ �� ��� ����� ��ࠦ���� � ��ࠬ��ࠬ�, ��⥬ ������ ��ࠬ���');
    writeln('0, ��� ��室� �� �ணࠬ��');
    write('����:');
    readln(InputCommand);
    case InputCommand of
      '1':
      begin
        clrscr;
        writeln('');
        write('������ ��⥬���᪮� ��ࠦ����: ');
        read(InputString);
        writeln(toR(InputString));
        readln();
        readln();
        clrscr;
      end;
      '0':
        halt(0);
      else writeln('�����४�� ����!');
    end;
  end;
end.
