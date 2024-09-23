unit model.cep;

interface

uses
  System.SysUtils, System.Classes, Uni, Data.DB, System.JSON, System.Variants,Xml.XMLDoc, Xml.XMLIntf, Vcl.Dialogs,
  System.StrUtils, System.Math;

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
    FIBGE: Integer;
    FGIA: Integer;
    FDDD: Integer;
    FSIAFI: Integer;
    FConnection: TUniConnection;
    FQuery: TUniQuery;
  public
    constructor Create(AConnection: TUniConnection);
    destructor Destroy; override;

    procedure LoadFromJSON(AJSON: TJSONObject);
    procedure LoadFromXML(AXMLNode: IXMLNode);
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
    property IBGE: Integer read FIBGE write FIBGE;
    property GIA: Integer read FGIA write FGIA;
    property DDD: Integer read FDDD write FDDD;
    property SIAFI: Integer read FSIAFI write FSIAFI;
  end;

implementation

constructor TCEPModel.Create(AConnection: TUniConnection);
begin
  FConnection := AConnection;
  FQuery := TUniQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TCEPModel.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TCEPModel.LoadFromJSON(AJSON: TJSONObject);
begin
  if AJSON = nil then
    Exit;

  if not AJSON.TryGetValue<string>('cep', FCEP) or (FCEP.Trim = '') then
    Exit;

  FCEP := FCEP.Replace('-', '');

  FLogradouro := AJSON.GetValue<string>('logradouro', '');
  FComplemento := AJSON.GetValue<string>('complemento', '');
  FBairro := AJSON.GetValue<string>('bairro', '');
  FLocalidade := AJSON.GetValue<string>('localidade', '');
  FUF := AJSON.GetValue<string>('uf', '');
  FEstado := AJSON.GetValue<string>('estado', '');
  FRegiao := AJSON.GetValue<string>('regiao', '');
  FIBGE := StrToIntDef(AJSON.GetValue<string>('ibge', ''), 0);
  FGIA := StrToIntDef(AJSON.GetValue<string>('gia', ''), 0);
  FDDD := StrToIntDef(AJSON.GetValue<string>('ddd', ''), 0);
  FSIAFI := StrToIntDef(AJSON.GetValue<string>('siafi', ''), 0);
end;

procedure TCEPModel.LoadFromXML(AXMLNode: IXMLNode);
begin
  if (AXMLNode = nil) or (AXMLNode.IsTextElement) then
    Exit;

  if VarIsNull(AXMLNode.ChildValues['cep']) or VarIsEmpty(AXMLNode.ChildValues['cep']) then
    Exit;

  FCEP := VarToStr(AXMLNode.ChildValues['cep']).Replace('-','');
  FLogradouro := VarToStr(AXMLNode.ChildValues['logradouro']);
  FComplemento := VarToStr(AXMLNode.ChildValues['complemento']);
  FBairro := VarToStr(AXMLNode.ChildValues['bairro']);
  FLocalidade := VarToStr(AXMLNode.ChildValues['localidade']);
  FUF := VarToStr(AXMLNode.ChildValues['uf']);
  FEstado := VarToStr(AXMLNode.ChildValues['estado']);
  FRegiao := VarToStr(AXMLNode.ChildValues['regiao']);

  FIBGE := StrToIntDef(VarToStr(AXMLNode.ChildValues['ibge']), 0);
  FGIA := StrToIntDef(VarToStr(AXMLNode.ChildValues['gia']), 0);
  FDDD := StrToIntDef(VarToStr(AXMLNode.ChildValues['ddd']), 0);
  FSIAFI := StrToIntDef(VarToStr(AXMLNode.ChildValues['siafi']), 0);
end;

procedure TCEPModel.SaveToDatabase;
begin
  FQuery.SQL.Text :=
    'INSERT INTO ceps (cep, logradouro, complemento, bairro, localidade, uf, estado, regiao, ibge, gia, ddd, siafi) ' +
    'VALUES (:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :estado, :regiao, :ibge, :gia, :ddd, :siafi)';

  FQuery.ParamByName('cep').AsString := FCEP.Replace('-', '');;
  FQuery.ParamByName('logradouro').AsString := FLogradouro;
  FQuery.ParamByName('complemento').AsString := FComplemento;
  FQuery.ParamByName('bairro').AsString := FBairro;
  FQuery.ParamByName('localidade').AsString := FLocalidade;
  FQuery.ParamByName('uf').AsString := FUF;
  FQuery.ParamByName('estado').AsString := FEstado;
  FQuery.ParamByName('regiao').AsString := FRegiao;
  FQuery.ParamByName('ibge').AsInteger := FIBGE;
  FQuery.ParamByName('gia').AsInteger := FGIA;
  FQuery.ParamByName('ddd').AsInteger := FDDD;
  FQuery.ParamByName('siafi').AsInteger := FSIAFI;

  FQuery.ExecSQL;
end;

procedure TCEPModel.LoadFromDatabase(ACEP: string);
begin
  FQuery.SQL.Text := 'SELECT * FROM ceps WHERE cep = :pcep';
  FQuery.ParamByName('pcep').AsString := ACEP;
  FQuery.Open;

  FCEP := FQuery.FieldByName('cep').AsString.Replace('-', '');
  FLogradouro := FQuery.FieldByName('logradouro').AsString;
  FComplemento := FQuery.FieldByName('complemento').AsString;
  FBairro := FQuery.FieldByName('bairro').AsString;
  FLocalidade := FQuery.FieldByName('localidade').AsString;
  FUF := FQuery.FieldByName('uf').AsString;
  FEstado := FQuery.FieldByName('estado').AsString;
  FRegiao := FQuery.FieldByName('regiao').AsString;
  FIBGE := FQuery.FieldByName('ibge').AsInteger;
  FGIA := FQuery.FieldByName('gia').AsInteger;
  FDDD := FQuery.FieldByName('ddd').AsInteger;
  FSIAFI := FQuery.FieldByName('siafi').AsInteger;
end;

end.

