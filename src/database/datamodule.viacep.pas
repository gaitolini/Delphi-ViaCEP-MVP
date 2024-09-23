unit datamodule.viacep;

interface

uses
  System.SysUtils,
  System.Classes,
  DAScript,
  UniScript,
  DADump,
  UniDump,
  UniProvider,
  PostgreSQLUniProvider,
  DBAccess,
  Uni,
  Data.DB;

type
  Tdm = class(TDataModule)
    conViacep: TUniConnection;
    transcViacep: TUniTransaction;
    driverPGViacep: TPostgreSQLUniProvider;
    dmpViacep: TUniDump;
    scrptDDL: TUniScript;
    scrptDML: TUniScript;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeDatabase;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tdm }

uses
  IniFiles, System.IOUtils;

{ Tdm }

procedure Tdm.InitializeDatabase;
var
  IniFile: TIniFile;
  IniFilePath: string;
begin
  IniFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');

  if not FileExists(IniFilePath) then
    raise Exception.Create('Arquivo de configuração "config.ini" não encontrado!');

  IniFile := TIniFile.Create(IniFilePath);
  try
    conViacep.Disconnect;

    conViacep.ProviderName := 'PostgreSQL';
    conViacep.Server := IniFile.ReadString('Database', 'Server', 'localhost');
    conViacep.Database := IniFile.ReadString('Database', 'Database', 'viacepdb');
    conViacep.Username := IniFile.ReadString('Database', 'Username', 'postgres');
    conViacep.Password := IniFile.ReadString('Database', 'Password', '');
    conViacep.Port := IniFile.ReadInteger('Database', 'Port', 5432);

    conViacep.Connect;
  finally
    IniFile.Free;
  end;
end;

end.


