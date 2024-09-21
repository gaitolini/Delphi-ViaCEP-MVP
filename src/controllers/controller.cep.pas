unit controller.cep;

interface

uses
  System.SysUtils, model.cep, service.viacep, dao.cep, datamodule.viacep, System.JSON,
  Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections, Uni, Data.DB;

type
  TCEPController = class
  private
    FModel: TCEPModel;
    FService: TViaCEPService;
    FDAO: TCEPDAO;
    function GetDAO: TCEPDAO;
  public
    constructor Create(AConnection: TUniConnection);
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

constructor TCEPController.Create(AConnection: TUniConnection);
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
  JSONObject: TJSONObject;
  XMLResults: IXMLNodeList;
  XMLDoc: IXMLDocument;
  Enderecos: TList<TCEPModel>;
  Endereco: TCEPModel;
  I: Integer;
  ErroJSON: TJSONValue;
  ErroXML: IXMLNode;
begin
  Enderecos := TList<TCEPModel>.Create;

  try
    if AFormatoJSON then
    begin
      // Recebe o JSON completo
      JSONObject := FService.ConsultarCEPJSON(aInput);

      // Verifica se contém o campo "erro" no JSON
      ErroJSON := JSONObject.GetValue('erro');
      if (ErroJSON <> nil) and (ErroJSON.Value = 'true') then
        raise Exception.Create('Erro na consulta do CEP: ' + aInput);

      // Se não houver erro, processa os resultados
      JSONResults := JSONObject.GetValue<TJSONArray>('enderecos');
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
      // Recebe o XML completo
      XMLDoc := FService.ConsultarCEPXML(aInput);
      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
      begin
        // Verifica se contém o nó "erro" no XML
        ErroXML := XMLDoc.DocumentElement.ChildNodes.FindNode('erro');
        if (ErroXML <> nil) and (ErroXML.Text = 'true') then
          raise Exception.Create('Erro na consulta do CEP (XML): ' + aInput);

        // Processa os nós XML normalmente
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

