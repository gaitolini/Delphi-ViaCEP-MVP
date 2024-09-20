unit dao.cep;

interface

uses
  model.cep, FireDAC.Comp.Client, Data.DB, System.SysUtils;

type
  TCEPDAO = class
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Insert(ACEPModel: TCEPModel);
    function CEPExists(AInput: string; out AID: Integer): Boolean;
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

function TCEPDAO.CEPExists(AInput: string; out AID: Integer): Boolean;
var
  Parts: TArray<string>;
  UF, Localidade, Logradouro: string;
  aInt: Integer;
begin
  Result := False;
  AID := -1;

  if TryStrToInt(AInput.Replace('-', '').Trim,aInt) then
  begin
    FQuery.SQL.Text := 'SELECT id FROM ceps WHERE cep = :cep';
    FQuery.ParamByName('cep').AsString := AInput;
  end
  else
  begin
    Parts := AInput.Split([',']);
    if Length(Parts) <> 3 then
      raise Exception.Create('O formato para consulta por endereço é UF, Cidade, Logradouro.');

    UF := Parts[0].Trim;
    Localidade := Parts[1].Trim;
    Logradouro := Parts[2].Trim;

    FQuery.SQL.Text := 'SELECT id FROM ceps WHERE uf = :uf AND localidade = :localidade AND logradouro = :logradouro';
    FQuery.ParamByName('uf').AsString := UF;
    FQuery.ParamByName('localidade').AsString := Localidade;
    FQuery.ParamByName('logradouro').AsString := Logradouro;
  end;

  FQuery.Open;
  if not FQuery.Eof then
  begin
    AID := FQuery.FieldByName('id').AsInteger; // Retorna o ID do registro encontrado
    Result := True;
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

  // Atribui os parâmetros a partir do modelo
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

  // Executa a consulta SQL de atualização
  FQuery.ExecSQL;
end;

end.

