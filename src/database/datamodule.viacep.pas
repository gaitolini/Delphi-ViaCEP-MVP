unit datamodule.viacep;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script;

type
  Tdm = class(TDataModule)
    connViacep: TFDConnection;
    waitViacep: TFDGUIxWaitCursor;
    driverViacep: TFDPhysSQLiteDriverLink;
    scriptViacep: TFDScript;
  private
    { Private declarations }
    procedure CreateDatabaseAndTables;
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

procedure Tdm.CreateDatabaseAndTables;
begin
  try
    scriptViacep.ExecuteAll;
  except
//    on E: Exception do
//      raise Exception.Create('Erro ao criar a tabela: ' + E.Message);
  end;
end;

procedure Tdm.InitializeDatabase;
begin
  connViacep.Connected := False;
  connViacep.Connected := True;
  CreateDatabaseAndTables;
end;

end.
