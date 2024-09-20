unit controller.cep;

interface

uses
  model.cep, service.viacep, dao.cep, datamodule.viacep, FireDAC.Comp.Client, System.JSON,
  Xml.XMLDoc, Xml.XMLIntf;

type
  TCEPController = class
  private
    FModel: TCEPModel;
    FService: TViaCEPService;
    FDAO: TCEPDAO;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    function ConsultarCEP(ACEP: string; AFormatoJSON: Boolean): Boolean; // True if successful
    procedure CarregarCEPDoBanco(ACEP: string);
  end;

implementation

constructor TCEPController.Create(AConnection: TFDConnection);
begin
  FModel := TCEPModel.Create(AConnection);
  FService := TViaCEPService.Create;
  FDAO := TCEPDAO.Create(AConnection); // DAO para persistência
end;

destructor TCEPController.Destroy;
begin
  FModel.Free;
  FService.Free;
  FDAO.Free;
  inherited;
end;

function TCEPController.ConsultarCEP(ACEP: string; AFormatoJSON: Boolean): Boolean;
var
  JSONObject: TJSONObject;
  XMLResult: IXMLDocument;
begin
  Result := False;

  if AFormatoJSON then
  begin
    JSONObject := FService.ConsultarCEPJSON(ACEP);

    if (JSONObject <> nil) then
    begin
      FModel.LoadFromJSON(JSONObject);
      Result := True;
    end;

  end
  else
  begin
    XMLResult := FService.ConsultarCEPXML(ACEP);
    if XMLResult <> nil then
    begin
      FModel.LoadFromXML(XMLResult);
      Result := True;
    end;
  end;

  if Result then
    FDAO.Insert(FModel); // Persiste os dados no banco
end;

procedure TCEPController.CarregarCEPDoBanco(ACEP: string);
begin
  FModel.LoadFromDatabase(ACEP);
end;

end.

