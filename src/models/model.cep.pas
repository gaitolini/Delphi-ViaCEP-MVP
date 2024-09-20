unit model.cep;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, Data.DB, System.JSON, Xml.XMLDoc, Xml.XMLIntf;

type
  TCEPModel = class
  private
    FCEP: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;
    FEstado: string;
    FRegiao: string;
    FIBGE: string;
    FGIA: string;
    FDDD: string;
    FSIAFI: string;
    FConnection: TFDConnection;
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    procedure LoadFromJSON(AJSON: TJSONObject);
    procedure LoadFromXML(AXML: IXMLDocument);
    procedure SaveToDatabase;
    procedure LoadFromDatabase(ACEP: string);

    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;
    property Estado: string read FEstado write FEstado;
    property Regiao: string read FRegiao write FRegiao;
    property IBGE: string read FIBGE write FIBGE;
    property GIA: string read FGIA write FGIA;
    property DDD: string read FDDD write FDDD;
    property SIAFI: string read FSIAFI write FSIAFI;
  end;

implementation

constructor TCEPModel.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TCEPModel.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TCEPModel.LoadFromJSON(AJSON: TJSONObject);
begin
  FCEP := AJSON.GetValue<string>('cep');
  FLogradouro := AJSON.GetValue<string>('logradouro');
  FComplemento := AJSON.GetValue<string>('complemento');
  FBairro := AJSON.GetValue<string>('bairro');
  FLocalidade := AJSON.GetValue<string>('localidade');
  FUF := AJSON.GetValue<string>('uf');
  FEstado := AJSON.GetValue<string>('estado');
  FRegiao := AJSON.GetValue<string>('regiao');
  FIBGE := AJSON.GetValue<string>('ibge');
  FGIA := AJSON.GetValue<string>('gia');
  FDDD := AJSON.GetValue<string>('ddd');
  FSIAFI := AJSON.GetValue<string>('siafi');
end;

procedure TCEPModel.LoadFromXML(AXML: IXMLDocument);
begin
  FCEP := AXML.DocumentElement.ChildNodes['cep'].Text;
  FLogradouro := AXML.DocumentElement.ChildNodes['logradouro'].Text;
  FComplemento := AXML.DocumentElement.ChildNodes['complemento'].Text;
  FBairro := AXML.DocumentElement.ChildNodes['bairro'].Text;
  FLocalidade := AXML.DocumentElement.ChildNodes['localidade'].Text;
  FUF := AXML.DocumentElement.ChildNodes['uf'].Text;
  FEstado := AXML.DocumentElement.ChildNodes['estado'].Text;
  FRegiao := AXML.DocumentElement.ChildNodes['regiao'].Text;
  FIBGE := AXML.DocumentElement.ChildNodes['ibge'].Text;
  FGIA := AXML.DocumentElement.ChildNodes['gia'].Text;
  FDDD := AXML.DocumentElement.ChildNodes['ddd'].Text;
  FSIAFI := AXML.DocumentElement.ChildNodes['siafi'].Text;
end;

procedure TCEPModel.SaveToDatabase;
begin
  FQuery.SQL.Text :=
    'INSERT INTO ceps (cep, logradouro, complemento, bairro, localidade, uf, estado, regiao, ibge, gia, ddd, siafi) ' +
    'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :estado, :regiao, :ibge, :gia, :ddd, :siafi)';
  FQuery.ParamByName('cep').AsString := FCEP;
  FQuery.ParamByName('logradouro').AsString := FLogradouro;
  FQuery.ParamByName('complemento').AsString := FComplemento;
  FQuery.ParamByName('bairro').AsString := FBairro;
  FQuery.ParamByName('localidade').AsString := FLocalidade;
  FQuery.ParamByName('uf').AsString := FUF;
  FQuery.ParamByName('estado').AsString := FEstado;
  FQuery.ParamByName('regiao').AsString := FRegiao;
  FQuery.ParamByName('ibge').AsString := FIBGE;
  FQuery.ParamByName('gia').AsString := FGIA;
  FQuery.ParamByName('ddd').AsString := FDDD;
  FQuery.ParamByName('siafi').AsString := FSIAFI;
  FQuery.ExecSQL;
end;

procedure TCEPModel.LoadFromDatabase(ACEP: string);
begin
  FQuery.SQL.Text := 'SELECT * FROM ceps WHERE cep = :pcep';
  FQuery.ParamByName('pcep').AsString := ACEP;
  FQuery.Open;

  FCEP := FQuery.FieldByName('cep').AsString;
  FLogradouro := FQuery.FieldByName('logradouro').AsString;
  FComplemento := FQuery.FieldByName('complemento').AsString;
  FBairro := FQuery.FieldByName('bairro').AsString;
  FLocalidade := FQuery.FieldByName('localidade').AsString;
  FUF := FQuery.FieldByName('uf').AsString;
  FEstado := FQuery.FieldByName('estado').AsString;
  FRegiao := FQuery.FieldByName('regiao').AsString;
  FIBGE := FQuery.FieldByName('ibge').AsString;
  FGIA := FQuery.FieldByName('gia').AsString;
  FDDD := FQuery.FieldByName('ddd').AsString;
  FSIAFI := FQuery.FieldByName('siafi').AsString;
end;

end.

