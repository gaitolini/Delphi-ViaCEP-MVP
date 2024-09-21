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
  Vcl.Bind.Navigator, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdActns, datamodule.viacep,
  Vcl.DBActns, System.Generics.Collections, System.StrUtils;

const
  cnstMsgPluralDuplicidade = 'Há endereços enconstrados na base. Deseja efetuar uma nova consulta atualizando as informações dos endereços existentes?';
  cnstMsgSigularDupicidade = 'O endereço encontrado na base! Deseja efetuar uma nova consulta atualizando as informações do endereço existente?';
  cnstMsgPluralConfirmaUpdate = 'Todos os endereços existentes foram atualizados.';
  cnstMsgSingularConfirmaUpdate = 'O endereço existente foi atualizado.';

type
  TviewBuscaCEP = class(TviewBase)
    actlstConsultaCEP: TActionList;
    ilConsultaCEP: TImageList;
    dsConsultaCEP: TDataSource;
    qryConsultaCEP: TFDQuery;
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
    edtLocation: TEdit;
    btnInsert: TButton;
    btnNavDB_Prior: TButton;
    btnNavDB_First: TButton;
    btnNavDB_Next: TButton;
    btnNavDB_Last: TButton;
    btnNavDB_Delete: TButton;
    btnNavDB_Refresh: TButton;
    btnSaveJSON: TButton;
    btnSaveAsXML: TButton;
    DatasetFirst1: TDataSetFirst;
    DatasetPrior1: TDataSetPrior;
    DatasetNext1: TDataSetNext;
    DatasetLast1: TDataSetLast;
    DatasetDelete1: TDataSetDelete;
    DatasetRefresh1: TDataSetRefresh;
    procedure FormCreate(Sender: TObject);
    procedure actConsultarCepExecute(Sender: TObject);
    procedure edtLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewBuscaCEP: TviewBuscaCEP;

implementation

uses
  controller.cep, model.cep, dao.cep;

{$R *.dfm}

procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
var
  Controller: TCEPController;
  Enderecos, ExistingEnderecos: TList<TCEPModel>;
  Endereco: TCEPModel;
  Option, ExistingID: Integer;
begin
  inherited;

  if Trim(edtLocation.Text) = EmptyStr then
  begin
    ShowMessage('Informe um valor válido!');
    Abort;
  end;


  Controller := TCEPController.Create(dm.connViacep);
  ExistingEnderecos := Controller.ConsultaCEP_DB(edtLocation.Text);

  try
    if (ExistingEnderecos.Count > 0) then
    begin
      Option := MessageDlg(IfThen(ExistingEnderecos.Count=1,cnstMsgSigularDupicidade, cnstMsgPluralDuplicidade), mtConfirmation, [mbYes, mbNo, mbCancel], 0);


      case Option of
        mrYes:
        begin
          Enderecos := Controller.ConsultarCEP_WS(edtLocation.Text, rgTipo.ItemIndex = 0);

          for Endereco in Enderecos do
          begin
            if ExistingEnderecos.BinarySearch(Endereco, ExistingID) then
              Controller.UpdateEndereco(Endereco)
            else
              Controller.InsertEndereco(Endereco);
          end;

          ShowMessage(IfThen(ExistingEnderecos.Count=1, cnstMsgSingularConfirmaUpdate, cnstMsgSingularConfirmaUpdate));
        end;

        mrNo:
        begin
          Abort;
        end;
      end;

    end
    else
    begin
      Enderecos := Controller.ConsultarCEP_WS(edtLocation.Text, rgTipo.ItemIndex = 0);
      for Endereco in Enderecos do
      begin
        Controller.InsertEndereco(Endereco)
      end;
    end;

    qryConsultaCEP.Refresh;
  finally
    FreeAndNil(Enderecos);
    FreeAndNil(Controller);
    FreeAndNil(ExistingEnderecos);
  end;
end;


procedure TviewBuscaCEP.edtLocationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    actConsultarCepExecute(nil);
end;

procedure TviewBuscaCEP.FormCreate(Sender: TObject);
begin
  inherited;
  qryConsultaCEP.Active := True;
end;

end.
