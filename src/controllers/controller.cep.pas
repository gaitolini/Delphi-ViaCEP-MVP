unit controller.cep;

interface

uses
  System.SysUtils, model.cep, service.viacep, dao.cep, datamodule.viacep, FireDAC.Comp.Client, System.JSON,
  Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections;

type
  TCEPController = class
  private
    FModel: TCEPModel;
    FService: TViaCEPService;
    FDAO: TCEPDAO;
    function GetDAO: TCEPDAO;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    procedure InsertEndereco(Endereco: TCEPModel);
    procedure UpdateEndereco(Endereco: TCEPModel);
    function ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
    function ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean): TList<TCEPModel>; overload;
//    function ConsultarCEP_WS(const aEnderecoList: TList<TCEPModel>): TList<TCEPModel>; overload;
    procedure CarregarCEPDoBanco(ACEP: string);

    property DAO: TCEPDAO read GetDAO;
  end;

implementation

uses
  Vcl.Dialogs, System.UITypes;

constructor TCEPController.Create(AConnection: TFDConnection);
begin
  FModel := TCEPModel.Create(AConnection);
  FService := TViaCEPService.Create;
  FDAO := TCEPDAO.Create(AConnection);
end;

destructor TCEPController.Destroy;
begin
  FModel.Free;
  FService.Free;
  FDAO.Free;
  inherited;
end;

function TCEPController.GetDAO: TCEPDAO;
begin
   Result := FDAO;
end;

function TCEPController.ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
begin
  Result := FDAO.ConsultaCEP_DB(aInput);
end;

procedure TCEPController.InsertEndereco(Endereco: TCEPModel);
begin
  FDAO.Insert(Endereco);
end;

procedure TCEPController.UpdateEndereco(Endereco: TCEPModel);
begin
  FDAO.Update(Endereco);
end;

function TCEPController.ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean): TList<TCEPModel>;
var
  JSONResults: TJSONArray;
  XMLResults: IXMLNodeList;
  XMLDoc: IXMLDocument;
  Enderecos: TList<TCEPModel>;
  Endereco: TCEPModel;
  I: Integer;
begin
  Enderecos := TList<TCEPModel>.Create;

  try
    if AFormatoJSON then
    begin
      JSONResults := FService.ConsultarCEPJSON(aInput).GetValue<TJSONArray>('enderecos');

      if JSONResults <> nil then
      begin
        for I := 0 to JSONResults.Count - 1 do
        begin
          Endereco := TCEPModel.Create(nil);
          Endereco.LoadFromJSON(JSONResults.Items[I] as TJSONObject);
          Enderecos.Add(Endereco);
        end;
      end;
    end
    else
    begin
      XMLDoc := FService.ConsultarCEPXML(aInput);
      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
      begin
        XMLResults := XMLDoc.DocumentElement.ChildNodes;
        if XMLResults <> nil then
        begin
          for I := 0 to XMLResults.Count - 1 do
          begin
            Endereco := TCEPModel.Create(nil);
            Endereco.LoadFromXML(XMLResults[I] as IXMLNode);
            Enderecos.Add(Endereco);
          end;
        end;
      end;
    end;

    Result := Enderecos;
  except
    Enderecos.Free;
    raise;
  end;
end;

procedure TCEPController.CarregarCEPDoBanco(ACEP: string);
begin
  FModel.LoadFromDatabase(ACEP);
end;

end.

