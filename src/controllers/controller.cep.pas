{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit controller.cep;

interface

uses
  System.SysUtils, model.cep, service.viacep, dao.cep, datamodule.viacep, System.JSON,
  Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections, Uni, Data.DB, System.Variants;

type
  TFormato = (tfJSON, tfXML);

  //5. Utilização de Interfaces
  TValidaCEP = reference to function(const Msg: string; const CEPsExistentes, CEPsNovos: TList<TCEPModel>; IsCEPGeneral: Boolean = false): Boolean;

  TErroAPI = record
    StatusCode: Integer;
    Msg: string;
    HasError: Boolean;
  end;

  //3. Utilização de POO
  TCEPController = class
  private
    FModel: TCEPModel;
    FService: TViaCEPService;
    FDAO: TCEPDAO;

    //3. Utilização de POO
    function GetDAO: TCEPDAO;

    //4. Serialização e desserialização de objetos JSON
    function ProcessarConsultaJSON(const aInput: string; out Erro: TErroAPI): TList<TCEPModel>;

    //4. Serialização e desserialização de objetos JSON / XML
    function ProcessarConsultaXML(const aInput: string; out Erro: TErroAPI): TList<TCEPModel>;

    //3. Utilização de POO
    procedure ProcessarEndereco(EnderecoList, ExistEnderecoList: TList<TCEPModel>; var NewCount, UpdatedCount: Integer);

    procedure InsertEndereco(Endereco: TCEPModel);
    procedure InserirEnderecos(EnderecoList: TList<TCEPModel>);
    procedure UpdateEndereco(Endereco: TCEPModel);

    //6. Aplicação de Patterns (DAO)
    function ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
    function ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean; out Erro: TErroAPI): TList<TCEPModel>;

    function GerarMensagemResultado(NewCount, UpdatedCount: Integer): string;
  public
    //3. Utilização de POO / 2. Utilização de SOLID (Single Responsibility Principle)
    constructor Create(AConnection: TUniConnection);
    destructor Destroy; override;

    procedure ConsultaCEP(const aInput: string; aFormato: TFormato; ValidaCEP: TValidaCEP; out Erro: TErroAPI);

    property DAO: TCEPDAO read GetDAO;
  end;

implementation

uses
  Vcl.Dialogs, System.UITypes;

constructor TCEPController.Create(AConnection: TUniConnection);
begin
  //3. Utilização de POO
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

function TCEPController.GerarMensagemResultado(NewCount, UpdatedCount: Integer): string;
begin
  Result := Format('Foram encontrados %d novos CEP', [NewCount]);
  Result := Result + sLineBreak + Format('Foram atualizados %d CEP', [UpdatedCount]);
end;

function TCEPController.GetDAO: TCEPDAO;
begin
  Result := FDAO;
end;

function TCEPController.ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
begin
  Result := FDAO.ConsultaCEP_DB(aInput);
end;

procedure TCEPController.InserirEnderecos(EnderecoList: TList<TCEPModel>);
var
  Endereco: TCEPModel;
begin
  for Endereco in EnderecoList do
    InsertEndereco(Endereco);
end;

procedure TCEPController.InsertEndereco(Endereco: TCEPModel);
begin
  FDAO.Insert(Endereco);
end;

procedure TCEPController.ProcessarEndereco(EnderecoList, ExistEnderecoList: TList<TCEPModel>; var NewCount, UpdatedCount: Integer);
var
  Endereco1, Endereco2: TCEPModel;
  Encontrou: Boolean;
  IsCEPGeneral: Boolean;
begin
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
end;

procedure TCEPController.UpdateEndereco(Endereco: TCEPModel);
begin
  FDAO.Update(Endereco);
end;

procedure TCEPController.ConsultaCEP(const aInput: string; aFormato: TFormato; ValidaCEP: TValidaCEP; out Erro: TErroAPI);
var
  EnderecoList, ExistEnderecoList: TList<TCEPModel>;
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
        Exit;

      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
      if Erro.HasError then Exit;

      ProcessarEndereco(EnderecoList, ExistEnderecoList, NewCount, UpdatedCount);

      if (NewCount > 0) or (UpdatedCount > 0) then
        aMensagem := GerarMensagemResultado(NewCount, UpdatedCount);
        if not ValidaCEP(aMensagem, nil, nil) then
          Exit;
    end
    else
    begin
      EnderecoList := ConsultarCEP_WS(aInput, aFormato = tfJSON, Erro);
      if Erro.HasError then Exit;

      if not ValidaCEP('Nenhum CEP encontrado. Deseja inserir os endereços retornados?', nil, EnderecoList) then
        Exit;

      InserirEnderecos(EnderecoList);
    end;
  finally
    ExistEnderecoList := nil;
    EnderecoList := nil;
  end;
end;

function TCEPController.ConsultarCEP_WS(const aInput: string; AFormatoJSON: Boolean; out Erro: TErroAPI): TList<TCEPModel>;
var
  Enderecos:  TList<TCEPModel>;
begin
  Erro.HasError := False;
  Enderecos := TList<TCEPModel>.Create;

  try
    if AFormatoJSON then
      Enderecos := ProcessarConsultaJSON(aInput, Erro)
    else
      Enderecos := ProcessarConsultaXML(aInput, Erro);

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

function TCEPController.ProcessarConsultaJSON(const aInput: string; out Erro: TErroAPI): TList<TCEPModel>;
var
  JSONResults: TJSONArray;
  JSONObject: TJSONObject;
  Endereco: TCEPModel;
  I: Integer;
  ErroJSON: TJSONValue;
begin
  Result := TList<TCEPModel>.Create;
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
      Result.Add(Endereco);
    end;
  end;
end;

function TCEPController.ProcessarConsultaXML(const aInput: string; out Erro: TErroAPI): TList<TCEPModel>;
var
  XMLDoc: IXMLDocument;
  XMLResults: IXMLNodeList;
  Endereco: TCEPModel;
  I: Integer;
  ErroXML: IXMLNode;
begin
  Result := TList<TCEPModel>.Create;
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
    for I := 0 to XMLResults.Count - 1 do
    begin
      Endereco := TCEPModel.Create(nil);
      Endereco.LoadFromXML(XMLResults[I]);
      Result.Add(Endereco);
    end;
  end;
end;

end.

