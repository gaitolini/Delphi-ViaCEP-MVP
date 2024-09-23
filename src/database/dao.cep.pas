{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit dao.cep;

interface

uses
  model.cep, Uni, Data.DB, System.SysUtils, System.Generics.Collections, utils.str;

type
  //2. Utilização de SOLID (Princípio da Responsabilidade Única)
  TCEPDAO = class
  private
    FConnection: TUniConnection;
    FQuery: TUniQuery;
    procedure AtivaUnaccent;

  public
    constructor Create(AConnection: TUniConnection);
    destructor Destroy; override;

    //6. Aplicação de Patterns (Data Access Object Pattern)
    procedure Insert(ACEPModel: TCEPModel);
    function ConsultaCEP_DB(const aInput: string): TList<TCEPModel>;
    procedure Update(ACEPModel: TCEPModel);
    function CEPGeralJaExiste(const aCEP, aUF, aLocalidade: string): Boolean;
  end;

implementation

constructor TCEPDAO.Create(AConnection: TUniConnection);
begin
  FConnection := AConnection;
  FQuery := TUniQuery.Create(nil);
  FQuery.Connection := FConnection;
  AtivaUnaccent;
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
  FQuery.ParamByName('uf').AsString := UpperCase(ACEPModel.UF);
  FQuery.ParamByName('estado').AsString := ACEPModel.Estado;
  FQuery.ParamByName('regiao').AsString := ACEPModel.Regiao;
  FQuery.ParamByName('ibge').AsInteger := ACEPModel.IBGE;
  FQuery.ParamByName('gia').AsInteger := ACEPModel.GIA;
  FQuery.ParamByName('ddd').AsInteger := ACEPModel.DDD;
  FQuery.ParamByName('siafi').AsInteger := ACEPModel.SIAFI;
  FQuery.ExecSQL;
end;

procedure TCEPDAO.AtivaUnaccent;
begin
  //5. Utilização de Interfaces (Banco de Dados PostgreSQL com extensão Unaccent)
  FQuery.SQL.Clear;
  FQuery.SQL.Text := 'SELECT extname FROM pg_extension WHERE extname = :extname';
  FQuery.ParamByName('extname').AsString := 'unaccent';
  FQuery.Open;

  if FQuery.IsEmpty then
  begin
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Text := 'CREATE EXTENSION IF NOT EXISTS unaccent';
    try
      FQuery.ExecSQL;
    except
      on E: Exception do
        raise Exception.Create('Erro ao criar a extensão unaccent: ' + E.Message);
    end;
  end;
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
    FQuery.SQL.Text := 'SELECT * FROM ceps WHERE cep = :cep';
    FQuery.ParamByName('cep').AsString := aInput;
  end
  else
  begin
    Parts := aInput.Split([',']);

    if Length(Parts) <> 3 then
      raise Exception.Create('O formato para consulta por endereço é UF, Cidade, Logradouro.');

    UF := Parts[0].Trim;
    Localidade := Parts[1];
    Logradouro := Parts[2];

    //3. Utilização de POO
    FQuery.SQL.Text := 'SELECT * FROM ceps WHERE UPPER(uf) = UPPER(:puf) AND unaccent(LOWER(localidade)) LIKE ''%'' || unaccent(LOWER(TRIM(:pLocalidade))) || ''%'' AND unaccent(LOWER(logradouro)) LIKE ''%'' || unaccent(LOWER(TRIM(:plogradouro))) ||  ''%''';
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
    aCEPModel.IBGE := FQuery.FieldByName('ibge').AsInteger;
    aCEPModel.GIA := FQuery.FieldByName('gia').AsInteger;
    aCEPModel.DDD := FQuery.FieldByName('ddd').AsInteger;
    aCEPModel.SIAFI := FQuery.FieldByName('siafi').AsInteger;
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
  FQuery.ParamByName('uf').AsString := UpperCase(ACEPModel.UF);
  FQuery.ParamByName('estado').AsString := ACEPModel.Estado;
  FQuery.ParamByName('regiao').AsString := ACEPModel.Regiao;
  FQuery.ParamByName('ibge').AsInteger := ACEPModel.IBGE;
  FQuery.ParamByName('gia').AsInteger := ACEPModel.GIA;
  FQuery.ParamByName('ddd').AsInteger := ACEPModel.DDD;
  FQuery.ParamByName('siafi').AsInteger := ACEPModel.SIAFI;

  FQuery.ExecSQL;
end;

function TCEPDAO.CEPGeralJaExiste(const aCEP, aUF, aLocalidade: string): Boolean;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('SELECT 1 FROM CEPS WHERE CEP = :PCEP');
  FQuery.SQL.Add('AND UNACCENT(LOWER(UF)) = UNACCENT(LOWER(:PUF))');
  FQuery.SQL.Add('AND UNACCENT(LOWER(LOCALIDADE)) = UNACCENT(LOWER(:PLOCALIDADE))');
  FQuery.SQL.Add('AND (LOGRADOURO IS NULL OR LOGRADOURO = '''')');

  FQuery.ParamByName('PCEP').AsString := aCEP;
  FQuery.ParamByName('PUF').AsString := aUF;
  FQuery.ParamByName('PLOCALIDADE').AsString := aLocalidade;
  FQuery.Open;

  Result := not FQuery.IsEmpty;
  FQuery.Close;
end;

end.
