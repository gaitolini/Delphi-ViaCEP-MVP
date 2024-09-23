unit controller.cep;

interface

uses
  System.SysUtils, model.cep, service.viacep, dao.cep, datamodule.viacep, System.JSON,
  Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections, Uni, Data.DB, System.Variants;

type
  TFormato = (tfJSON, tfXML);
  TValidaCEP = reference to function(const Msg: string; const CEPsExistentes, CEPsNovos: TList<TCEPModel>; IsCEPGeneral: Boolean = false): Boolean;

  TErroAPI = record
    StatusCode: Integer;
    Msg: string;
    HasError: Boolean;
  end;

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
    function ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean; out Erro: TErroAPI): TList<TCEPModel>;
    procedure ConsultaCEP(const aInput: string; aFormato: TFormato; ValidaCEP: TValidaCEP; out Erro: TErroAPI);
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

//procedure TCEPController.ConsultaCEP(const aInput: string; aFormato: TFormato; ValidaCEP: TValidaCEP; out Erro: TErroAPI);
//var
//  EnderecoList, ExistEnderecoList: TList<TCEPModel>;
//  Endereco1, Endereco2: TCEPModel;
//  Encontrou: Boolean;
//begin
//  Erro.HasError := False;
//
//  try
//    ExistEnderecoList := ConsultaCEP_DB(aInput);
//
//    if ExistEnderecoList.Count > 0 then
//    begin
//      if not ValidaCEP('Endereço já existente. Deseja atualizar os endereços?', ExistEnderecoList, nil) then
//      begin
//        Exit;
//      end;
//
//      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
//      if Erro.HasError then
//        Exit;
//
//      for Endereco1 in EnderecoList do
//      begin
//        Encontrou := False;
//        for Endereco2 in ExistEnderecoList do
//        begin
//          if Endereco1.CEP = Endereco2.CEP then
//          begin
//            UpdateEndereco(Endereco1);
//            Encontrou := True;
//            Break;
//          end;
//        end;
//
//        if not Encontrou then
//          InsertEndereco(Endereco1);
//      end;
//    end
//    else
//    begin
//      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
//      if Erro.HasError then
//        Exit;
//
//      if not ValidaCEP('Nenhum CEP encontrado. Deseja inserir os endereços retornados?', nil, EnderecoList) then
//      begin
//        Exit;
//      end;
//
//      for Endereco1 in EnderecoList do
//      begin
//        Encontrou := False;
//        for Endereco2 in ExistEnderecoList do
//        begin
//          if Endereco1.CEP = Endereco2.CEP then
//          begin
//            UpdateEndereco(Endereco1);
//            Encontrou := True;
//            Break;
//          end;
//        end;
//
//        if not Encontrou then
//          InsertEndereco(Endereco1);
//      end;
//
////      for Endereco1 in EnderecoList do
////        InsertEndereco(Endereco1);
//    end;
//  finally
//    ExistEnderecoList := nil;
//    EnderecoList := nil;
//  end;
//end;

procedure TCEPController.ConsultaCEP(const aInput: string; aFormato: TFormato; ValidaCEP: TValidaCEP; out Erro: TErroAPI);
var
  EnderecoList, ExistEnderecoList: TList<TCEPModel>;
  Endereco1, Endereco2: TCEPModel;
  Encontrou: Boolean;
  IsCEPGeneral: Boolean;
  NewCount, UpdatedCount: Integer;
  aMensagem: string;
begin
  Erro.HasError := False;
  NewCount := 0;
  UpdatedCount := 0;

  try
    ExistEnderecoList := ConsultaCEP_DB(aInput);

    if ExistEnderecoList.Count > 0 then
    begin
      if not ValidaCEP('Endereço já existente. Deseja atualizar os endereços?', ExistEnderecoList, nil) then
      begin
        Exit;
      end;

      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
      if Erro.HasError then
        Exit;

      for Endereco1 in EnderecoList do
      begin
        Encontrou := False;
        IsCEPGeneral := (Endereco1.Logradouro = '');

        if IsCEPGeneral and FDAO.CEPGeralJaExiste(Endereco1.CEP, Endereco1.UF, Endereco1.Localidade) then
        begin
          UpdateEndereco(Endereco1);
          Continue;
        end;

        for Endereco2 in ExistEnderecoList do
        begin
          if Endereco1.CEP = Endereco2.CEP then
          begin
            UpdateEndereco(Endereco1);
            Encontrou := True;
            Inc(UpdatedCount);
            Break;
          end;
        end;

        if not Encontrou then
        begin
          InsertEndereco(Endereco1);
          Inc(NewCount);
        end;

      end;

      if (NewCount > 0) or (UpdatedCount > 0) then
      begin

        aMensagem := Format('Foram encontrados %d novos CEP',[NewCount]);
        aMensagem := aMensagem + #10#13+  Format('Foram atualizado %d CEP',[UpdatedCount]);

        if not ValidaCEP(aMensagem, nil, nil) then
          Exit;
      end;
    end
    else
    begin
      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
      if Erro.HasError then
        Exit;

      for Endereco1 in EnderecoList do
      begin
        Encontrou := False;
        IsCEPGeneral := (Endereco1.Logradouro.Trim = '');

        if IsCEPGeneral and FDAO.CEPGeralJaExiste(Endereco1.CEP, Endereco1.UF, Endereco1.Localidade) then
        begin
          if not ValidaCEP(Format('O CEP Geral %s  foi atualizado!',[Endereco1.CEP]), nil, EnderecoList,True) then
          begin
            Exit;
          end;

          UpdateEndereco(Endereco1);
          Continue;
        end;

        for Endereco2 in ExistEnderecoList do
        begin
          if Endereco1.CEP = Endereco2.CEP then
          begin
            UpdateEndereco(Endereco1);
            Encontrou := True;
            Break;
          end;
        end;

        if not Encontrou then
          InsertEndereco(Endereco1);
      end;
    end;
  finally
    ExistEnderecoList := nil;
    EnderecoList := nil;
  end;
end;

function TCEPController.ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean; out Erro: TErroAPI): TList<TCEPModel>;
var
  JSONResults: TJSONArray;
  JSONObject: TJSONObject;
  XMLResults: IXMLNodeList;
  XMLDoc: IXMLDocument;
  Enderecos: TList<TCEPModel>;
  Endereco: TCEPModel;
  I: Integer;
  ErroJSON: TJSONValue;
  ErroXML, aXML: IXMLNode;
begin
  Erro.HasError := False;
  Enderecos := TList<TCEPModel>.Create;

  try
    if AFormatoJSON then
    begin
      JSONObject := FService.ConsultarCEPJSON(aInput);

      ErroJSON := JSONObject.GetValue('erro');
      if (ErroJSON <> nil) and (ErroJSON.Value = 'true') then
      begin
        Erro.HasError := True;
        Erro.StatusCode := 200;
        Erro.Msg := 'CEP ou Endereço não encontrado.';
        Exit(nil);
      end;

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
      XMLDoc := FService.ConsultarCEPXML(aInput);

      if (XMLDoc <> nil) and (XMLDoc.DocumentElement <> nil) then
      begin
        ErroXML := XMLDoc.DocumentElement.ChildNodes.FindNode('erro');
        if (ErroXML <> nil) and (ErroXML.Text = 'true') then
        begin
          Erro.HasError := True;
          Erro.StatusCode := 200;
          Erro.Msg := 'CEP ou Endereço não encontrado.';
          Exit(nil);
        end;

        XMLResults := XMLDoc.DocumentElement.ChildNodes.FindNode('enderecos').ChildNodes;
        if XMLResults <> nil then
        begin
          for I := 0 to XMLResults.Count - 1 do
          begin
            aXML := XMLResults[I] as IXMLNode;

            if (aXML = nil) or (aXML.IsTextElement) then
              Continue;

            if (aXML.HasAttribute('endereco')) then
              Continue;

            Endereco := TCEPModel.Create(nil);
            Endereco.LoadFromXML(aXML);  // Passa o nó <endereco> diretamente
            Enderecos.Add(Endereco);
          end;
        end;
      end;
    end;

    Result := Enderecos;

  except
    on E: Exception do
    begin
      Enderecos.Free;
      Erro.HasError := True;
      Erro.StatusCode := 500;
      Erro.Msg := 'Erro ao consultar o WS ViaCEP: ' + E.Message;
      Result := nil;
    end;
  end;
end;

procedure TCEPController.CarregarCEPDoBanco(ACEP: string);
begin
  FModel.LoadFromDatabase(ACEP);
end;

end.

