unit dao.cep;

interface

uses
  model.cep, FireDAC.Comp.Client, Data.DB;

type
  TCEPDAO = class
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    procedure Insert(ACEPModel: TCEPModel);
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

end.

