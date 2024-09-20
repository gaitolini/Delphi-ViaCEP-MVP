{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit view.buscacep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, view.base, System.Skia, Vcl.Skia,
  Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.Bind.Navigator, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdActns, datamodule.viacep;

type
  TviewBuscaCEP = class(TviewBase)
    actlstConsultaCEP: TActionList;
    ilConsultaCEP: TImageList;
    dsConsultaCEP: TDataSource;
    qryConsultaCEP: TFDQuery;
    LiveBindingsBindNavigateFirst1: TBindNavigateFirst;
    LiveBindingsBindNavigatePrior1: TBindNavigatePrior;
    LiveBindingsBindNavigateNext1: TBindNavigateNext;
    LiveBindingsBindNavigateLast1: TBindNavigateLast;
    LiveBindingsBindNavigateDelete1: TBindNavigateDelete;
    LiveBindingsBindNavigateRefresh1: TBindNavigateRefresh;
    actConsultarCep: TAction;
    actSaveAsJSON: TFileSaveAs;
    actSaveAsXML: TFileSaveAs;
    fdtncfldConsultaCEPid: TFDAutoIncField;
    strngfldConsultaCEPcep: TStringField;
    strngfldConsultaCEPlogradouro: TStringField;
    strngfldConsultaCEPcomplemento: TStringField;
    strngfldConsultaCEPbairro: TStringField;
    strngfldConsultaCEPlocalidade: TStringField;
    strngfldConsultaCEPuf: TStringField;
    strngfldConsultaCEPestado: TStringField;
    strngfldConsultaCEPregiao: TStringField;
    qryConsultaCEPibge: TIntegerField;
    qryConsultaCEPgia: TIntegerField;
    qryConsultaCEPddd: TIntegerField;
    qryConsultaCEPsiafi: TIntegerField;
    pnl1: TPanel;
    dbgEndereco: TDBGrid;
    pnlMenu: TPanel;
    rgTipo: TRadioGroup;
    edtCEP: TEdit;
    btnInsert: TButton;
    btnNavDB_Prior: TButton;
    btnNavDB_First: TButton;
    btnNavDB_Next: TButton;
    btnNavDB_Last: TButton;
    btnNavDB_Delete: TButton;
    btnNavDB_Refresh: TButton;
    btnSaveJSON: TButton;
    btnSaveAsXML: TButton;
    procedure FormCreate(Sender: TObject);
    procedure actConsultarCepExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewBuscaCEP: TviewBuscaCEP;

implementation

uses
  controller.cep;

{$R *.dfm}

procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
var
  Controller: TCEPController;
  Success: Boolean;
begin
  inherited;

  // Criando o controller e inicializando com a conexão do DataModule
  Controller := TCEPController.Create(dm.connViacep);
  try
    // Consulta do CEP: verifica se o RadioGroup está selecionado para JSON ou XML
    Success := Controller.ConsultarCEP(edtCEP.Text, rgTipo.ItemIndex = 0);

    if Success then
    begin
      ShowMessage('Consulta realizada e dados inseridos com sucesso.');
      qryConsultaCEP.Refresh; // Atualiza o DBGrid
    end
    else
      ShowMessage('Falha na consulta do CEP.');
  finally
    Controller.Free;
  end;
end;

procedure TviewBuscaCEP.FormCreate(Sender: TObject);
begin
  inherited;
  qryConsultaCEP.Active := True;
end;

end.
