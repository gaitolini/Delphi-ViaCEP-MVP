{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit service.viacep;

interface

uses
  component.viacep, System.JSON, Xml.XMLDoc, Xml.XMLIntf;

type
  //3. Utiliza��o de POO
  TViaCEPService = class
  private
    FViaCEPClient: TViaCEPClient;
  public
    //3. Utiliza��o de POO / 2. Utiliza��o de SOLID (Princ�pio da Responsabilidade �nica)
    constructor Create;
    destructor Destroy; override;

    //4. Serializa��o e desserializa��o de objetos JSON
    function ConsultarCEPJSON(ACEP: string): TJSONObject;

    //4. Serializa��o e desserializa��o de objetos XML
    function ConsultarCEPXML(ACEP: string): IXMLDocument;
  end;

implementation

constructor TViaCEPService.Create;
begin
  //7. Cria��o de Componentes (TViaCEPClient)
  FViaCEPClient := TViaCEPClient.Create(nil);
end;

destructor TViaCEPService.Destroy;
begin
  FViaCEPClient.Free;
  inherited;
end;

function TViaCEPService.ConsultarCEPJSON(ACEP: string): TJSONObject;
var
  JSONResult: TSerializableJSON;
begin
  //3. Utiliza��o de POO
  FViaCEPClient.Input := ACEP;

  //5. Utiliza��o de Interfaces (TSerializableJSON)
  JSONResult := FViaCEPClient.Consultar<TSerializableJSON>;

  Result := JSONResult.AsJSON;
end;

function TViaCEPService.ConsultarCEPXML(ACEP: string): IXMLDocument;
var
  XMLResult: TSerializableXML;
begin
  //3. Utiliza��o de POO
  FViaCEPClient.Input := ACEP;

  //5. Utiliza��o de Interfaces (TSerializableXML)
  XMLResult := FViaCEPClient.Consultar<TSerializableXML>;

  Result := XMLResult.AsXML;
end;

end.

