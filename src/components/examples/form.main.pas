{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit form.main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  component.viacep, System.JSON, Xml.XMLDoc, Xml.XMLIntf, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    ViaCEPClient1: TViaCEPClient;
    pnlTop: TPanel;
    edtCEP: TEdit;
    rgTipo: TRadioGroup;
    btnConsultar: TButton;
    pnlMain: TPanel;
    statConsultaCEP: TStatusBar;
    mmoResultado: TMemo;
    procedure btnConsultarClick(Sender: TObject);
    procedure ViaCEPClient1Request(Sender: TObject);
    procedure ViaCEPClient1Response(Sender: TObject; const Body: string;
      StatusCode: Integer; Erro: Boolean);
  private
    procedure ExibirResultado(const Resultado: string);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ExibirResultado(const Resultado: string);
begin
  mmoResultado.Lines.Text := Resultado;
end;

procedure TForm1.btnConsultarClick(Sender: TObject);
var
  JSONResult: ISerializable;
  XMLResult: ISerializable;
  aJson: TJsonObject;
  aXML: IXMLDocument;
begin
  ViaCEPClient1.CEP := edtCEP.Text;

  // Consultar JSON
  if rgTipo.ItemIndex = 0 then
  begin
    JSONResult := ViaCEPClient1.Consultar<TSerializableJSON>;
    mmoResultado.Lines.Text := JSONResult.ToString;
    aJson := JSONResult.AsJSON;
  end
  // Consultar XML
  else
  begin
    XMLResult := ViaCEPClient1.Consultar<TSerializableXML>;
    mmoResultado.Lines.Text := XMLResult.ToString;
    aXML := XMLResult.AsXML;
  end;
end;

procedure TForm1.ViaCEPClient1Request(Sender: TObject);
begin
   mmoResultado.Lines.Add('Iniciando consulta...');
end;

procedure TForm1.ViaCEPClient1Response(Sender: TObject; const Body: string;
  StatusCode: Integer; Erro: Boolean);
begin
  statConsultaCEP.Panels[1].Text := Format('%3d',[StatusCode]);
  mmoResultado.Lines.Add(Format('Código de Status: %d', [StatusCode]));
  if Erro then
    mmoResultado.Lines.Add('Erro na consulta: ' + Body)
  else
    mmoResultado.Lines.Add('Consulta realizada com sucesso.');
end;


end.

