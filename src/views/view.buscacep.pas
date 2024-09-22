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
    procedure edtLocationChange(Sender: TObject);
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
  ErroAPI: TErroAPI;
  Formato: TFormato;
begin
  inherited;

  if Trim(edtLocation.Text) = '' then
  begin
    ShowMessage('Informe um valor válido!');
    Exit;
  end;

  Controller := TCEPController.Create(dm.conViacep);
  try
    if rgTipo.ItemIndex = 0 then
      Formato := tfJSON
    else
      Formato := tfXML;

    Controller.ConsultaCEP(edtLocation.Text, Formato,
      function(const Msg: string; const CEPsExistentes, CEPsNovos: TList<TCEPModel>): Boolean
      var
        Option: Integer;
      begin
        if (CEPsExistentes <> nil) and (CEPsExistentes.Count > 0) then
        begin
          Option := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0);
          if Option = mrYes then
            Result := True
          else
            Result := False;
        end
        else
        begin
          Option := MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0);
          if Option = mrYes then
            Result := True
          else
            Result := False;
        end;
      end, ErroAPI);

    if ErroAPI.HasError then
    begin
      ShowMessage(Format('Erro [%d]: %s', [ErroAPI.StatusCode, ErroAPI.Msg]));
    end;

    qryViacep.Refresh;

  finally
    Controller.Free;
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



procedure TviewBuscaCEP.edtLocationChange(Sender: TObject);
var
  Input: string;
  IsCEP: Boolean;
  Parts: TArray<string>;
  SQLBase, FilterSQL: string;
begin
  Input := Trim(edtLocation.Text);

  if Input = '' then
  begin
    qryViacep.Close;
    qryViacep.SQL.Text := 'SELECT * FROM ceps ORDER BY cep ASC';
    qryViacep.Open;
    Exit;
  end;

  IsCEP := (Length(Input) >= 2) and (CharInSet(Input[1], ['0'..'9']));

  qryViacep.DisableControls;
  try
    qryViacep.Close;
    qryViacep.SQL.Clear;

    SQLBase := 'SELECT * FROM ceps WHERE ';
    FilterSQL := '';

    if IsCEP then
    begin
      qryViacep.SQL.Text := SQLBase + 'cep LIKE :pCep ORDER BY cep ASC';
      qryViacep.ParamByName('pCep').AsString := Input + '%'; // Filtra pelo início do CEP
    end
    else
    begin
      Parts := Input.Split([',']);

      case Length(Parts) of
        1:
          begin
            qryViacep.SQL.Text := SQLBase + 'UPPER(uf) LIKE UPPER(:pUF) ORDER BY uf ASC';
            qryViacep.ParamByName('pUF').AsString := Trim(Parts[0]) + '%';

            if Length(Trim(Parts[0])) = 2 then
            begin
              edtLocation.Text := Trim(Parts[0]) + ', ';
              edtLocation.SelStart := Length(edtLocation.Text); // Posiciona o cursor no final
            end;
          end;
        2:
          begin
            qryViacep.SQL.Text := SQLBase +
              'UPPER(uf) LIKE UPPER(:pUF) AND UPPER(localidade) LIKE UPPER(:pLocalidade) ORDER BY localidade ASC';
            qryViacep.ParamByName('pUF').AsString := Trim(Parts[0]) + '%';
            qryViacep.ParamByName('pLocalidade').AsString := Trim(Parts[1]) + '%';
          end;
        3:
          begin
            qryViacep.SQL.Text := SQLBase +
              'UPPER(uf) LIKE UPPER(:pUF) AND ' +
              'UPPER(localidade) LIKE UPPER(:pLocalidade) AND ' +
              'UPPER(logradouro) LIKE UPPER(:pLogradouro) ORDER BY logradouro ASC';
            qryViacep.ParamByName('pUF').AsString := Trim(Parts[0]) + '%';
            qryViacep.ParamByName('pLocalidade').AsString := Trim(Parts[1]) + '%';
            qryViacep.ParamByName('pLogradouro').AsString := Trim(Parts[2]) + '%';
          end;
      else
        qryViacep.SQL.Text := 'SELECT * FROM ceps ORDER BY cep ASC';
      end;
    end;

    qryViacep.Open;
  finally
    qryViacep.EnableControls;
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
