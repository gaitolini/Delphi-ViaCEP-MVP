unit service.viacep;

interface

uses
  component.viacep, System.JSON, Xml.XMLDoc, Xml.XMLIntf;

type
  TViaCEPService = class
  private
    FViaCEPClient: TViaCEPClient;
  public
    constructor Create;
    destructor Destroy; override;

    function ConsultarCEPJSON(ACEP: string): TJSONObject;
    function ConsultarCEPXML(ACEP: string): IXMLDocument;
  end;

implementation

constructor TViaCEPService.Create;
begin
  FViaCEPClient := TViaCEPClient.Create(nil);
end;

destructor TViaCEPService.Destroy;
begin
  FViaCEPClient.Free;
  inherited;
end;

function TViaCEPService.ConsultarCEPJSON(ACEP: string): TJSONObject;
var
  JSONResult: ISerializable;
begin
  FViaCEPClient.CEP := ACEP;
  JSONResult := FViaCEPClient.Consultar<TSerializableJSON>;
  Result := JSONResult.AsJSON;
end;

function TViaCEPService.ConsultarCEPXML(ACEP: string): IXMLDocument;
var
  XMLResult: ISerializable;
begin
  FViaCEPClient.CEP := ACEP;
  XMLResult := FViaCEPClient.Consultar<TSerializableXML>;
  Result := XMLResult.AsXML;
end;

end.

