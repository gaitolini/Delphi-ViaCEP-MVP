program ViaCEP;

uses
  Vcl.Forms,
  view.utils in '..\src\utils\view.utils.pas',
  view.layout in '..\src\views\view.layout.pas' {viewLayout},
  view.main in '..\src\views\view.main.pas' {viewMain},
  view.base in '..\src\views\view.base.pas' {viewBase},
  view.buscacep in '..\src\views\view.buscacep.pas' {viewBuscaCEP},
  view.endereco in '..\src\views\view.endereco.pas' {viewEndereco};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TviewMain, viewMain);
  Application.Run;
end.
