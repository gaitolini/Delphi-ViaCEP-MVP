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

    function ConsultarCEP(ACEP: string; AFormatoJSON: Boolean; var IsExisting: Boolean; out AExistingID: Integer): Boolean;
    procedure CarregarCEPDoBanco(ACEP: string);
  end;

implementation

uses
  Vcl.Dialogs, System.UITypes;

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

function TCEPController.ConsultarCEP(ACEP: string; AFormatoJSON: Boolean; var IsExisting: Boolean; out AExistingID: Integer): Boolean;
var
  JSONResult: TJSONObject;
  XMLResult: IXMLDocument;
begin
  Result := False;
  AExistingID := -1;
  IsExisting := FDAO.CEPExists(ACEP, AExistingID);

  if IsExisting then
  begin
    FModel.LoadFromDatabase(ACEP);
    Result := True;
  end
  else
  begin
    if AFormatoJSON then
    begin
      JSONResult := FService.ConsultarCEPJSON(ACEP);
      if JSONResult <> nil then
      begin
        FModel.LoadFromJSON(JSONResult);
        FDAO.Insert(FModel);
        Result := True;
      end;
    end
    else
    begin
      XMLResult := FService.ConsultarCEPXML(ACEP);
      if XMLResult <> nil then
      begin
        FModel.LoadFromXML(XMLResult);
        FDAO.Insert(FModel);
        Result := True;
      end;
    end;
  end;
end;

procedure TCEPController.CarregarCEPDoBanco(ACEP: string);
begin
  FModel.LoadFromDatabase(ACEP);
end;

end.

