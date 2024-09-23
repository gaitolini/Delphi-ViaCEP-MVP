unit utils.str;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.JSON,
  System.Character;

type
  TStrUtils = class
    class function RemoveAcentos(s: string): string;
  end;
implementation

{ TStrUtils }

class function TStrUtils.RemoveAcentos(s: string): string;
var
  I: Integer;
  AcentoRemovido: string;
begin
  Result := '';
  AcentoRemovido := '';
  for I := 1 to Length(S) do
  begin
    case S[I] of
      '�','�','�','�','�','�','�','�','�','�': AcentoRemovido := 'a';
      '�','�','�','�','�','�','�','�': AcentoRemovido := 'e';
      '�','�','�','�','�','�','�','�': AcentoRemovido := 'i';
      '�','�','�','�','�','�','�','�','�','�': AcentoRemovido := 'o';
      '�','�','�','�','�','�','�','�': AcentoRemovido := 'u';
      '�','�': AcentoRemovido := 'c';
    else
      AcentoRemovido := S[I];
    end;
    Result := Result + AcentoRemovido;
  end;
end;

end.
