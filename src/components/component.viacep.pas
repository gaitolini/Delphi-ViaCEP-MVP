unit component.viacep;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, System.JSON, System.Math, System.StrUtils, Xml.XMLDoc, Xml.XMLIntf;

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
    FInput: string;
    FOnRequest: TOnRequest;
    FOnResponse: TOnResponse;
    procedure SetInput(const Value: string);
    function IsCEP(Input: string): Boolean;
    function BuildURLByCEP<T>(Input: string): string;
    function BuildURLByEndereco<T>(Input: string): string;
    procedure DoRequest;
    procedure DoResponse(const Body: string; StatusCode: Integer; Erro: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //5. Utilização de Interfaces
    function Consultar<T: ISerializable>: T;
  published
    property Input: string read FInput write SetInput;
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

procedure TViaCEPClient.SetInput(const Value: string);
begin
  FInput := Value.Trim;
end;

function TViaCEPClient.IsCEP(Input: string): Boolean;
var aInt: Integer;
begin
  Result := TryStrToInt(Input.Replace('-', '').Replace(' ', ''), aInt);
end;

function TViaCEPClient.BuildURLByCEP<T>(Input: string): string;
begin
  Result := Format('https://viacep.com.br/ws/%s/%s/', [Input.Replace('-', '').Replace(' ', ''), IfThen( TypeInfo(T) = TypeInfo(TSerializableJSON),'json','xml')]);
end;

function TViaCEPClient.BuildURLByEndereco<T>(Input: string): string;
var
  Parts: TArray<string>;
  UF, Cidade, Logradouro: string;
begin
  Parts := Input.Split([',']);

  if Length(Parts) <> 3 then
    raise Exception.Create('São necessários três parâmetros obrigatórios (UF, Cidade e Logradouro), '+#13+
                          '  sendo que para Cidade e Logradouro também é obrigatório um número mínimo de três caracteres');

  UF := Parts[0].Trim;
  Cidade := Parts[1].Trim;
  Logradouro := Parts[2].Trim;

  Result := Format('https://viacep.com.br/ws/%s/%s/%s/%s/', [UF, Cidade, Logradouro, IfThen( TypeInfo(T) = TypeInfo(TSerializableJSON),'json','xml')]);
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
  JSONResult: TJSONValue;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  XMLResult: IXMLDocument;
  XMLNodes: IXMLNodeList;
  StatusCode: Integer;
  Erro: Boolean;
begin
  Erro := False;
  StatusCode := 0;

  DoRequest;

  if IsCEP(FInput) then
    LURL := BuildURLByCEP<T>(FInput)
  else
    LURL := BuildURLByEndereco<T>(FInput);

  try
    FHttpClient.AcceptCharSet := 'utf-8';
    LResponse := FHttpClient.Get(LURL);
    StatusCode := LResponse.StatusCode;
    ResponseContent := LResponse.ContentAsString.Trim.Replace(#13, '').Replace(#10, '');

    if LResponse.StatusCode = 200 then
    begin
      if TypeInfo(T) = TypeInfo(TSerializableJSON) then
      begin
        JSONResult := TJSONObject.ParseJSONValue(ResponseContent);

        if Assigned(JSONResult) then
        begin
          if JSONResult is TJSONArray then
          begin
            JSONArray := TJSONArray(JSONResult);
          end
          else if JSONResult is TJSONObject then
          begin
            JSONArray := TJSONArray.Create;
            JSONArray.AddElement(TJSONObject(JSONResult.Clone as TJSONValue)); // Adiciona o objeto ao array
          end
          else
            raise Exception.Create('Erro ao parsear o retorno JSON.');

          Result := T(TSerializableJSON.Create(TJSONObject.Create.AddPair('enderecos', JSONArray.Clone as TJSONArray)));
        end
        else
          raise Exception.Create('Erro ao parsear o retorno JSON.');
      end
      else if TypeInfo(T) = TypeInfo(TSerializableXML) then
      begin
        XMLResult := TXMLDocument.Create(nil);
        XMLResult.LoadFromXML(ResponseContent);
        XMLNodes := XMLResult.DocumentElement.ChildNodes;

        if XMLNodes.Count > 1 then
        begin
          Result := T(TSerializableXML.Create(XMLResult));
        end
        else
        begin
          Result := T(TSerializableXML.Create(XMLResult));
        end;
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
