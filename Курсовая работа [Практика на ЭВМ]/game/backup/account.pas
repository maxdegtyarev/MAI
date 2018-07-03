unit account;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type
    User = class
      private
        UserName: string;
        UserBalance: integer;
      public

        Constructor Init(Name);

        {Геттеры}
        function GetUserName: string;
        function GetBalance: integer;
        {Сеттеры}

        procedure SetUserName(Name: string);
        procedure AddToBalance(how: integer);

    end;
implementation

end.

