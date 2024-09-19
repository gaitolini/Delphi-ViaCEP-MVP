program ViaCEP;

uses
  Vcl.Forms,
  view.main in '..\src\views\view.main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
