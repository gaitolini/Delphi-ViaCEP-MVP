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
      'Á','À','Â','Ã','Ä','á','à','â','ã','ä': AcentoRemovido := 'a';
      'É','È','Ê','Ë','é','è','ê','ë': AcentoRemovido := 'e';
      'Í','Ì','Î','Ï','í','ì','î','ï': AcentoRemovido := 'i';
      'Ó','Ò','Ô','Õ','Ö','ó','ò','ô','õ','ö': AcentoRemovido := 'o';
      'Ú','Ù','Û','Ü','ú','ù','û','ü': AcentoRemovido := 'u';
      'Ç','ç': AcentoRemovido := 'c';
    else
      AcentoRemovido := S[I];
    end;
    Result := Result + AcentoRemovido;
  end;
end;

end.
