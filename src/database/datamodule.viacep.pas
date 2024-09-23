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

procedure Tdm.InitializeDatabase;
begin

  conViacep.Disconnect;
  conViacep.ProviderName := 'PostgreSQL';
  conViacep.Server := 'localhost';
  conViacep.Database := 'viacepdb';
  conViacep.Username := 'postgres';
  conViacep.Password := '04060811';
  conViacep.Port := 5432;
  conViacep.Connect;
end;

end.


