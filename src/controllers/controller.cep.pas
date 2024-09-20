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
    function CEPExists(aInput: string; out AID: Integer): Boolean;
//    function ConsultarCEP(ACEP: string; AFormatoJSON: Boolean; var IsExisting: Boolean; out AExistingID: Integer): Boolean;
    function ConsultarEnderecoLista(AEndereco: string; AFormatoJSON: Boolean; out ExistingList: TList<TCEPModel>): TList<TCEPModel>;
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

function TCEPController.CEPExists(aInput: string; out AID: Integer): Boolean;
begin
  Result := FDAO.CEPExists(aInput, AID);
end;

procedure TCEPController.InsertEndereco(Endereco: TCEPModel);
begin
  FDAO.Insert(Endereco);
end;

procedure TCEPController.UpdateEndereco(Endereco: TCEPModel);
begin
  FDAO.Update(Endereco);
end;

//function TCEPController.ConsultarCEP(ACEP: string; AFormatoJSON: Boolean; var IsExisting: Boolean; out AExistingID: Integer): Boolean;
//var
//  JSONResult: TJSONObject;
//  XMLResult: IXMLDocument;
//begin
//  Result := False;
//  AExistingID := -1;
//  IsExisting := FDAO.CEPExists(ACEP, AExistingID);
//
//  if IsExisting then
//  begin
//    FModel.LoadFromDatabase(ACEP);
//    Result := True;
//  end
//  else
//  begin
//    if AFormatoJSON then
//    begin
//      JSONResult := FService.ConsultarCEPJSON(ACEP);
//      if JSONResult <> nil then
//      begin
//        FModel.LoadFromJSON(JSONResult);
//        FDAO.Insert(FModel);
//        Result := True;
//      end;
//    end
//    else
//    begin
//      XMLResult := FService.ConsultarCEPXML(ACEP);
//      if XMLResult <> nil then
//      begin
//        FModel.LoadFromXML(XMLResult);
//        FDAO.Insert(FModel);
//        Result := True;
//      end;
//    end;
//  end;
//end;

//function TCEPController.ConsultarEnderecoLista(AEndereco: string; AFormatoJSON: Boolean; out ExistingList: TList<TCEPModel>): TList<TCEPModel>;
//var
//  JSONObject: TJSONObject;
//  JSONResults: TJSONArray;
//  JSONValue: TJSONValue;
//  XMLResults: IXMLNodeList;
//  XMLDoc: IXMLDocument;
//  Enderecos: TList<TCEPModel>;
//  Endereco: TCEPModel;
//  I: Integer;
//begin
//  Enderecos := TList<TCEPModel>.Create;
//  ExistingList := TList<TCEPModel>.Create;
//
//  try
//    if AFormatoJSON then
//    begin
//      JSONValue := FService.ConsultarCEPJSON(AEndereco);
//
//      if JSONValue is TJSONArray then
//        JSONResults := TJSONArray(JSONValue)
//      else if JSONValue is TJSONObject then
//      begin
//        JSONResults := TJSONArray.Create;
//        JSONResults.AddElement(TJSONObject(JSONValue.Clone as TJSONValue));
//      end;
//
//      if JSONResults <> nil then
//      begin
//        for I := 0 to JSONResults.Count - 1 do
//        begin
//          Endereco := TCEPModel.Create(nil);
//          JSONObject := JSONResults.Items[I] as TJSONObject;
//          Endereco.LoadFromJSON(JSONObject);
//          Enderecos.Add(Endereco);
//        end;
//      end;
//    end
//    else
//    begin
//      XMLDoc := FService.ConsultarCEPXML(AEndereco);
//      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
//      begin
//        XMLResults := XMLDoc.DocumentElement.ChildNodes;
//        if XMLResults <> nil then
//        begin
//          for I := 0 to XMLResults.Count - 1 do
//          begin
//            Endereco := TCEPModel.Create(nil);
//            Endereco.LoadFromXML(XMLResults[I] as IXMLNode);
//
//            Enderecos.Add(Endereco);
//          end;
//        end;
//      end;
//    end;
//
//    ExistingList := FDAO.CheckExistingAddresses(Enderecos);
//
//    Result := Enderecos;
//  except
//    Enderecos.Free;
//    ExistingList.Free;
//    raise;
//  end;
//end;

//function TCEPController.ConsultarEnderecoLista(AEndereco: string; AFormatoJSON: Boolean; out ExistingList: TList<TCEPModel>): TList<TCEPModel>;
//var
//  JSONValue: TJSONValue;
//  JSONObject: TJSONObject;
//  JSONResults: TJSONArray;
//  XMLResults: IXMLNodeList;
//  XMLDoc: IXMLDocument;
//  Enderecos: TList<TCEPModel>;
//  Endereco: TCEPModel;
//  I: Integer;
//begin
//  Enderecos := TList<TCEPModel>.Create;
//  ExistingList := TList<TCEPModel>.Create;
//
//  try
//    if AFormatoJSON then
//    begin
//      // Obtém o valor JSON da consulta
//      JSONValue := FService.ConsultarCEPJSON(AEndereco);
//
//      // Se o valor for um array, processa diretamente
//      if JSONValue is TJSONArray then
//      begin
//        JSONResults := TJSONArray(JSONValue);
//      end
//      // Se for um objeto único, converte-o para uma lista
//      else if JSONValue is TJSONObject then
//      begin
//        JSONResults := TJSONArray.Create;
//        JSONResults.AddElement(TJSONObject(JSONValue.Clone as TJSONValue)); // Adiciona o objeto único ao array
//      end
//      else
//        raise Exception.Create('Formato de JSON inesperado');
//
//      // Processa o array de resultados JSON
//      if JSONResults <> nil then
//      begin
//        for I := 0 to JSONResults.Count - 1 do
//        begin
//          Endereco := TCEPModel.Create(nil);
//          JSONObject := JSONResults.Items[I] as TJSONObject; // Extrai o JSON de cada item
//          Endereco.LoadFromJSON(JSONObject); // Carrega os dados no modelo
//          Enderecos.Add(Endereco); // Adiciona à lista de endereços
//        end;
//      end;
//    end
//    else
//    begin
//      // Lógica para XML
//      XMLDoc := FService.ConsultarCEPXML(AEndereco);
//      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
//      begin
//        XMLResults := XMLDoc.DocumentElement.ChildNodes;
//        if XMLResults <> nil then
//        begin
//          for I := 0 to XMLResults.Count - 1 do
//          begin
//            Endereco := TCEPModel.Create(nil);
//            Endereco.LoadFromXML(XMLResults[I] as IXMLNode); // Carrega o nó XML no modelo
//            Enderecos.Add(Endereco); // Adiciona à lista de endereços
//          end;
//        end;
//      end;
//    end;
//
//    // Verifica se os endereços já existem no banco de dados
//    ExistingList := FDAO.CheckExistingAddresses(Enderecos);
//
//    Result := Enderecos; // Retorna a lista de endereços
//  except
//    Enderecos.Free;
//    ExistingList.Free;
//    raise;
//  end;
//end;

function TCEPController.ConsultarEnderecoLista(AEndereco: string; AFormatoJSON: Boolean; out ExistingList: TList<TCEPModel>): TList<TCEPModel>;
var
  JSONResults: TJSONArray;
  XMLResults: IXMLNodeList;
  XMLDoc: IXMLDocument;
  Enderecos: TList<TCEPModel>;
  Endereco: TCEPModel;
  I: Integer;
begin
  Enderecos := TList<TCEPModel>.Create;
  ExistingList := TList<TCEPModel>.Create;

  try
    if AFormatoJSON then
    begin
      JSONResults := FService.ConsultarCEPJSON(AEndereco).GetValue<TJSONArray>('enderecos');

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
      XMLDoc := FService.ConsultarCEPXML(AEndereco);
      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
      begin
        XMLResults := XMLDoc.DocumentElement.ChildNodes;
        if XMLResults <> nil then
        begin
          for I := 0 to XMLResults.Count - 1 do
          begin
            Endereco := TCEPModel.Create(nil);
            Endereco.LoadFromXML(XMLResults[I] as IXMLNode); // Carrega o nó XML no modelo
            Enderecos.Add(Endereco); // Adiciona à lista de endereços
          end;
        end;
      end;
    end;

    // Verifica se os endereços já existem no banco de dados
    ExistingList := FDAO.CheckExistingAddresses(Enderecos);

    Result := Enderecos; // Retorna a lista de endereços
  except
    Enderecos.Free;
    ExistingList.Free;
    raise;
  end;
end;

procedure TCEPController.CarregarCEPDoBanco(ACEP: string);
begin
  FModel.LoadFromDatabase(ACEP);
end;

end.

