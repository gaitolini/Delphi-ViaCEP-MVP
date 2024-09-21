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
  Vcl.DBActns, System.Generics.Collections, System.StrUtils, MemDS, DBAccess,
  Uni, Vcl.ComCtrls;

const
  cnstMsgPluralDuplicidade = 'Há endereços enconstrados na base.'+#10#13+'Deseja efetuar uma nova consulta atualizando as informações dos endereços existentes?';
  cnstMsgSigularDupicidade = 'O endereço foi encontrado na base!'+#10#13+'Deseja efetuar uma nova consulta atualizando as informações do endereço existente?';
  cnstMsgPluralConfirmaUpdate = 'Todos os endereços existentes foram atualizados.';
  cnstMsgSingularConfirmaUpdate = 'O endereço existente foi atualizado.';

type
  TviewBuscaCEP = class(TviewBase)
    actlstConsultaCEP: TActionList;
    ilConsultaCEP: TImageList;
    actConsultarCep: TAction;
    actSaveAsJSON: TFileSaveAs;
    actSaveAsXML: TFileSaveAs;
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
    dsViacep: TUniDataSource;
    qryViacep: TUniQuery;
    qryViacepid: TIntegerField;
    strngfldViacepcep: TStringField;
    strngfldViaceplogradouro: TStringField;
    strngfldViacepcomplemento: TStringField;
    strngfldViacepbairro: TStringField;
    strngfldViaceplocalidade: TStringField;
    strngfldViacepuf: TStringField;
    strngfldViacepestado: TStringField;
    strngfldViacepregiao: TStringField;
    qryViacepibge: TIntegerField;
    qryViacepgia: TIntegerField;
    qryViacepddd: TIntegerField;
    qryViacepsiafi: TIntegerField;
    statConsultaCEP: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure actConsultarCepExecute(Sender: TObject);
    procedure edtLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgEnderecoTitleClick(Column: TColumn);
    procedure dsViacepDataChange(Sender: TObject; Field: TField);
  private
    UltimaColuna: TColumn;
    procedure OrdenaColuna(Column: TColumn);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewBuscaCEP: TviewBuscaCEP;

implementation

uses
  controller.cep, model.cep, dao.cep, utils.str;

{$R *.dfm}

procedure TviewBuscaCEP.actConsultarCepExecute(Sender: TObject);
var
  Controller: TCEPController;
  EnderecoList, ExistEnderecoList: TList<TCEPModel>;
  Endereco1, Endereco2: TCEPModel;
  Option, ExistingID: Integer;
  Encontrou: Boolean;
begin
  inherited;

  if Trim(edtLocation.Text) = EmptyStr then
  begin
    ShowMessage('Informe um valor válido!');
    Abort;
  end;

  Controller := TCEPController.Create(dm.conViacep);
  ExistEnderecoList := Controller.ConsultaCEP_DB(edtLocation.Text);

  try
    if (ExistEnderecoList.Count > 0) then
    begin
      Option := MessageDlg(IfThen(ExistEnderecoList.Count=1,cnstMsgSigularDupicidade, cnstMsgPluralDuplicidade), mtConfirmation, [mbYes, mbNo, mbCancel], 0);

      case Option of
        mrYes:
        begin
          EnderecoList := Controller.ConsultarCEP_WS(edtLocation.Text, rgTipo.ItemIndex = 0);

          for Endereco1 in EnderecoList do
          begin
            Encontrou := False;

            for Endereco2 in ExistEnderecoList do
            begin
              if Endereco2.CEP = Endereco1.CEP then
              begin
                Controller.UpdateEndereco(Endereco1);
                Encontrou := True;
                Break;
              end;
            end;

            if not Encontrou then
            begin
              Controller.InsertEndereco(Endereco1);
            end;
          end;

          ShowMessage(IfThen(ExistEnderecoList.Count=1, cnstMsgSingularConfirmaUpdate, cnstMsgSingularConfirmaUpdate));
        end;

        mrNo:
        begin
          Abort;
        end;
      end;
    end
    else
    begin
      EnderecoList := Controller.ConsultarCEP_WS(edtLocation.Text, rgTipo.ItemIndex = 0);
      for Endereco1 in EnderecoList do
      begin
        Controller.InsertEndereco(Endereco1)
      end;
    end;

    qryViacep.Refresh;
  finally
//    FreeAndNil(EnderecoList);
    FreeAndNil(Controller);
    FreeAndNil(ExistEnderecoList);
  end;
end;

procedure TviewBuscaCEP.dbgEnderecoTitleClick(Column: TColumn);
begin
  OrdenaColuna(Column);
end;

procedure TviewBuscaCEP.dsViacepDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  statConsultaCEP.Panels[1].Text := Format('%0000000d',[qryViacep.RecordCount]);
end;

procedure TviewBuscaCEP.OrdenaColuna(Column: TColumn);
var
  lFieldName: string;
  lOrderBy: string;
  i: Integer;
begin
  lFieldName := Column.FieldName;

  for i := 0 to dbgEndereco.Columns.Count-1  do
    dbgEndereco.Columns[i].Title.Font.Style := [];

  if Pos(lFieldName + ' ASC', qryViacep.SQL.Text) > 0 then
  begin
    lOrderBy := lFieldName + ' DESC';
    Column.Title.Font.Style := [fsBold];
  end
  else
  begin
    lOrderBy := lFieldName + ' ASC';
    Column.Title.Font.Style := [fsBold];
  end;

  qryViacep.DisableControls;
  try
    qryViacep.Close;
    qryViacep.SQL.Text := 'SELECT * FROM ceps ORDER BY ' + lOrderBy;
    qryViacep.Open;
  finally
    qryViacep.EnableControls;
    UltimaColuna := Column;
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
  qryViacep.Active := True;
  UltimaColuna := dbgEndereco.Columns[0];
  OrdenaColuna(UltimaColuna);
end;

end.
