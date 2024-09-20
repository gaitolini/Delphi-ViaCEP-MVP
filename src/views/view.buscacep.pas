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
  Vcl.DBActns;

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
  controller.cep;

{$R *.dfm}

//procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
//var
//  Controller: TCEPController;
//  Success: Boolean;
//  InputText: string;
//  aInteger: Integer;
//begin
//  inherited;
//
//  // Criando o controller e inicializando com a conexão do DataModule
//  Controller := TCEPController.Create(dm.connViacep);
//  try
//    InputText := edtLocation.Text;
//
//    if Length(InputText) < 3 then
//    begin
//      ShowMessage('O CEP ou endereço informado deve conter pelo menos 3 caracteres.');
//      Exit;
//    end;
//
//    Success := Controller.ConsultarCEP(InputText, rgTipo.ItemIndex = 0);
//
//    if Success then
//    begin
//      ShowMessage('Consulta realizada e dados inseridos com sucesso.');
//      qryConsultaCEP.Refresh; // Atualiza o DBGrid
//    end
//    else
//      ShowMessage('Falha na consulta.');
//  finally
//    Controller.Free;
//  end;
//end;

//procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
//var
//  Controller: TCEPController;
//  Success, IsExisting: Boolean;
//begin
//  inherited;
//
//  Controller := TCEPController.Create(dm.connViacep);
//  try
//    Success := Controller.ConsultarCEP(edtLocation.Text, rgTipo.ItemIndex = 0, IsExisting);
//
//    if IsExisting then
//    begin
//      if MessageDlg('CEP já existe no banco de dados. Deseja usar o endereço salvo ou consultar novamente?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//      begin
//        ShowMessage('Usando os dados salvos no banco de dados.');
//      end
//      else
//      begin
//        Abort;
////        Success := Controller.ConsultarCEP(edtLocation.Text, rgTipo.ItemIndex = 0, IsExisting);
////        if Success then
////          ShowMessage('Consulta realizada e dados atualizados com sucesso.');
//      end;
//    end
//    else if Success then
//      ShowMessage('Consulta realizada e dados inseridos com sucesso.')
//    else
//      ShowMessage('Falha na consulta do CEP.');
//
//    qryConsultaCEP.Refresh;
//  finally
//    Controller.Free;
//  end;
//end;

procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
var
  Controller: TCEPController;
  Success, IsExisting: Boolean;
  ExistingID: Integer;
begin
  inherited;

  Controller := TCEPController.Create(dm.connViacep);
  try
    Success := Controller.ConsultarCEP(edtLocation.Text, rgTipo.ItemIndex = 0, IsExisting, ExistingID);

    if IsExisting then
    begin
      if MessageDlg('CEP já existe no banco de dados. Deseja usar o endereço salvo ou consultar novamente?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        ShowMessage('Usando os dados salvos no banco de dados.');

        if ExistingID <> -1 then
        begin
          if not qryConsultaCEP.Locate('id', ExistingID, []) then
            ShowMessage('Registro não encontrado no DBGrid.');
        end;

        Abort;
      end;
    end
    else
    if Success then
      ShowMessage('Consulta realizada e dados inseridos com sucesso.')
    else
      ShowMessage('Falha na consulta do CEP.');

    qryConsultaCEP.Refresh;
  finally
    Controller.Free;
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
