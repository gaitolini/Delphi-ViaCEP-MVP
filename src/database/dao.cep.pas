unit dao.cep;

interface

uses
  model.cep, FireDAC.Comp.Client, Data.DB, System.SysUtils, System.Generics.Collections;

type
  TCEPDAO = class
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Insert(ACEPModel: TCEPModel);
    function ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
    procedure Update(ACEPModel: TCEPModel);
  end;

implementation

constructor TCEPDAO.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TCEPDAO.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TCEPDAO.Insert(ACEPModel: TCEPModel);
begin
  FQuery.SQL.Text :=
    'INSERT INTO ceps (cep, logradouro, complemento, bairro, localidade, uf, estado, regiao, ibge, gia, ddd, siafi) ' +
    'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :estado, :regiao, :ibge, :gia, :ddd, :siafi)';

  FQuery.ParamByName('cep').AsString := ACEPModel.CEP;
  FQuery.ParamByName('logradouro').AsString := ACEPModel.Logradouro;
  FQuery.ParamByName('complemento').AsString := ACEPModel.Complemento;
  FQuery.ParamByName('bairro').AsString := ACEPModel.Bairro;
  FQuery.ParamByName('localidade').AsString := ACEPModel.Localidade;
  FQuery.ParamByName('uf').AsString := ACEPModel.UF;
  FQuery.ParamByName('estado').AsString := ACEPModel.Estado;
  FQuery.ParamByName('regiao').AsString := ACEPModel.Regiao;
  FQuery.ParamByName('ibge').AsString := ACEPModel.IBGE;
  FQuery.ParamByName('gia').AsString := ACEPModel.GIA;
  FQuery.ParamByName('ddd').AsString := ACEPModel.DDD;
  FQuery.ParamByName('siafi').AsString := ACEPModel.SIAFI;
  FQuery.ExecSQL;
end;

function TCEPDAO.ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
var
  Parts: TArray<string>;
  UF, Localidade, Logradouro: string;
  aInt: Integer;
  aCEPModel: TCEPModel;
begin
  Result := TList<TCEPModel>.Create;

  if TryStrToInt(aInput.Replace('-', '').Trim,aInt) then
  begin
    FQuery.SQL.Text := 'SELECT id FROM ceps WHERE cep = :cep';
    FQuery.ParamByName('cep').AsString := aInput;
  end
  else
  begin
    Parts := aInput.Split([',']);

    if Length(Parts) <> 3 then
      raise Exception.Create('O formato para consulta por endereço é UF, Cidade, Logradouro.');

    UF := Parts[0].Trim;
    Localidade := Parts[1].Trim;
    Logradouro := Parts[2].Trim;

    FQuery.SQL.Text := 'SELECT * FROM ceps WHERE UPPER(uf) = UPPER(:puf) AND LOWER(localidade) LIKE  :pLocalidade || ''%'' AND LOWER(logradouro) LIKE  :plogradouro || ''%''';
    FQuery.ParamByName('puf').AsString := UF;
    FQuery.ParamByName('pLocalidade').AsString := LowerCase(Localidade);
    FQuery.ParamByName('pLogradouro').AsString := LowerCase(Logradouro);
  end;

  FQuery.Open;

  while not FQuery.Eof do
  begin

    aCEPModel := TCEPModel.Create(nil);
    aCEPModel.CEP := FQuery.FieldByName('cep').AsString;
    aCEPModel.Logradouro := FQuery.FieldByName('logradouro').AsString;
    aCEPModel.Complemento := FQuery.FieldByName('complemento').AsString;
    aCEPModel.Bairro := FQuery.FieldByName('bairro').AsString;
    aCEPModel.Localidade := FQuery.FieldByName('localidade').AsString;
    aCEPModel.UF := FQuery.FieldByName('uf').AsString;
    aCEPModel.Estado := FQuery.FieldByName('estado').AsString;
    aCEPModel.Regiao := FQuery.FieldByName('regiao').AsString;
    aCEPModel.IBGE := FQuery.FieldByName('ibge').AsString;
    aCEPModel.GIA := FQuery.FieldByName('gia').AsString;
    aCEPModel.DDD := FQuery.FieldByName('ddd').AsString;
    aCEPModel.SIAFI := FQuery.FieldByName('siafi').AsString;
    Result.Add(aCEPModel);

    FQuery.Next;
  end;

  FQuery.Close;
end;

procedure TCEPDAO.Update(ACEPModel: TCEPModel);
begin
  FQuery.SQL.Text :=
    'UPDATE ceps SET ' +
    'cep = :cep, logradouro = :logradouro, complemento = :complemento, ' +
    'bairro = :bairro, localidade = :localidade, uf = :uf, ' +
    'estado = :estado, regiao = :regiao, ibge = :ibge, ' +
    'gia = :gia, ddd = :ddd, siafi = :siafi ' +
    'WHERE cep = :cep';

  FQuery.ParamByName('cep').AsString := ACEPModel.CEP;
  FQuery.ParamByName('logradouro').AsString := ACEPModel.Logradouro;
  FQuery.ParamByName('complemento').AsString := ACEPModel.Complemento;
  FQuery.ParamByName('bairro').AsString := ACEPModel.Bairro;
  FQuery.ParamByName('localidade').AsString := ACEPModel.Localidade;
  FQuery.ParamByName('uf').AsString := ACEPModel.UF;
  FQuery.ParamByName('estado').AsString := ACEPModel.Estado;
  FQuery.ParamByName('regiao').AsString := ACEPModel.Regiao;
  FQuery.ParamByName('ibge').AsString := ACEPModel.IBGE;
  FQuery.ParamByName('gia').AsString := ACEPModel.GIA;
  FQuery.ParamByName('ddd').AsString := ACEPModel.DDD;
  FQuery.ParamByName('siafi').AsString := ACEPModel.SIAFI;

  FQuery.ExecSQL;
end;

end.

