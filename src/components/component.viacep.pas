{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit component.viacep;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, System.JSON, Xml.XMLDoc, Xml.XMLIntf;

type
  TOnRequest = procedure(Sender: TObject) of object;
  TOnResponse = procedure(Sender: TObject; const Body: string; StatusCode: Integer; Erro: Boolean) of object;

  //5. Utilização de Interfaces
  ISerializable = interface
    ['{A1234567-B89C-123D-E456-000000000002}']
    function ToString: string;
    function AsJSON: TJSONObject;
    function AsXML: IXMLDocument;
  end;

  //4. Serialização e desserialização de objetos JSON
  TSerializableJSON = class(TInterfacedObject, ISerializable)
  private
    FJSON: TJSONObject;
  public
    constructor Create(AJSON: TJSONObject);
    destructor Destroy; override;
    function ToString: string; override;
    function AsJSON: TJSONObject;
    function AsXML: IXMLDocument;
  end;

  //4. Serialização e desserialização de objetos XML
  TSerializableXML = class(TInterfacedObject, ISerializable)
  private
    FXML: IXMLDocument;
  public
    constructor Create(AXML: IXMLDocument);
    function ToString: string; override;
    function AsJSON: TJSONObject;
    function AsXML: IXMLDocument;
  end;

  //7. Criação de Componentes
  TViaCEPClient = class(TComponent)
  private
    FHttpClient: THttpClient;
    FCEP: string;
    FOnRequest: TOnRequest;
    FOnResponse: TOnResponse;
    procedure SetCEP(const Value: string);
    procedure DoRequest;
    procedure DoResponse(const Body: string; StatusCode: Integer; Erro: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //5. Utilização de Interfaces
    function Consultar<T: ISerializable>: T;
  published
    property CEP: string read FCEP write SetCEP;
    property OnRequest: TOnRequest read FOnRequest write FOnRequest;
    property OnResponse: TOnResponse read FOnResponse write FOnResponse;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ViaCEP', [TViaCEPClient]);
end;

constructor TViaCEPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHttpClient := THttpClient.Create;
end;

destructor TViaCEPClient.Destroy;
begin
  FHttpClient.Free;
  inherited Destroy;
end;

procedure TViaCEPClient.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TViaCEPClient.DoRequest;
begin
  if Assigned(FOnRequest) then
    FOnRequest(Self);
end;

procedure TViaCEPClient.DoResponse(const Body: string; StatusCode: Integer; Erro: Boolean);
begin
  if Assigned(FOnResponse) then
    FOnResponse(Self, Body, StatusCode, Erro);
end;

//2. Utilização de SOLID
function TViaCEPClient.Consultar<T>: T;
var
  LResponse: IHTTPResponse;
  LURL, ResponseContent: string;
  JSONResult: TJSONObject;
  XMLResult: IXMLDocument;
  StatusCode: Integer;
  Erro: Boolean;
begin
  Erro := False;
  StatusCode := 0;

  DoRequest;

  if TypeInfo(T) = TypeInfo(TSerializableJSON) then
    LURL := Format('https://viacep.com.br/ws/%s/json/', [FCEP])
  else
  if TypeInfo(T) = TypeInfo(TSerializableXML) then
    LURL := Format('https://viacep.com.br/ws/%s/xml/', [FCEP])
  else
    raise Exception.Create('Tipo de retorno desconhecido.');

  try
    LResponse := FHttpClient.Get(LURL);
    StatusCode := LResponse.StatusCode;
    ResponseContent := LResponse.ContentAsString;

    if LResponse.StatusCode = 200 then
    begin
      if TypeInfo(T) = TypeInfo(TSerializableJSON) then
      begin
        JSONResult := TJSONObject.ParseJSONValue(ResponseContent) as TJSONObject;
        if Assigned(JSONResult) then
          Result := T(TSerializableJSON.Create(JSONResult))
        else
          raise Exception.Create('Erro ao parsear o retorno JSON.');
      end
      else if TypeInfo(T) = TypeInfo(TSerializableXML) then
      begin
        XMLResult := TXMLDocument.Create(nil);
        XMLResult.LoadFromXML(ResponseContent);
        Result := T(TSerializableXML.Create(XMLResult));
      end;
    end
    else
    begin
      Erro := True;
      if TypeInfo(T) = TypeInfo(TSerializableJSON) then
        Result := T(TSerializableJSON.Create(TJSONObject.Create))
      else
      begin
        XMLResult := TXMLDocument.Create(nil);
        XMLResult.LoadFromXML('<root></root>');
        Result := T(TSerializableXML.Create(XMLResult));
      end;
    end;
  except
    on E: Exception do
    begin
      Erro := True;
      ResponseContent := E.Message;
      if TypeInfo(T) = TypeInfo(TSerializableJSON) then
        Result := T(TSerializableJSON.Create(TJSONObject.Create))
      else
      begin
        XMLResult := TXMLDocument.Create(nil);
        XMLResult.LoadFromXML('<root></root>');
        Result := T(TSerializableXML.Create(XMLResult));
      end;
    end;
  end;

  DoResponse(ResponseContent, StatusCode, Erro);
end;

constructor TSerializableJSON.Create(AJSON: TJSONObject);
begin
  FJSON := AJSON;
end;

destructor TSerializableJSON.Destroy;
begin
  FJSON.Free;
  inherited Destroy;
end;

function TSerializableJSON.ToString: string;
begin
  Result := FJSON.ToString;
end;

function TSerializableJSON.AsJSON: TJSONObject;
begin
  Result := FJSON;
end;

function TSerializableJSON.AsXML: IXMLDocument;
begin
  Result := nil;
end;

constructor TSerializableXML.Create(AXML: IXMLDocument);
begin
  FXML := AXML;
end;

function TSerializableXML.ToString: string;
begin
  Result := FXML.XML.Text;
end;

function TSerializableXML.AsJSON: TJSONObject;
begin
  Result := nil;
end;

function TSerializableXML.AsXML: IXMLDocument;
begin
  Result := FXML;
end;

end.
