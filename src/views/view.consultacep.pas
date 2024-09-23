{*******************************************************}
{                                                       }
{       Anderson Gaitolini                              }
{                                                       }
{       Copyright (C) 2024 Gaitolini                    }
{                                                       }
{*******************************************************}

unit view.consultacep;

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
  Uni, Vcl.ComCtrls, Vcl.ExtActns;

type
  TViewConsultaCEP = class(TviewBase)
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
    InternetBrowseURL1: TBrowseURL;
    procedure FormCreate(Sender: TObject);
    procedure actConsultarCepExecute(Sender: TObject);
    procedure edtLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgEnderecoTitleClick(Column: TColumn);
    procedure dsViacepDataChange(Sender: TObject; Field: TField);
    procedure edtLocationChange(Sender: TObject);
  private
    FUltimaColuna: TColumn;
    procedure OrdenaColuna(Column: TColumn);
    function GetUltimaColuna: TColumn;
    procedure SetUltimaColuna(const Value: TColumn);
    { Private declarations }
  public
    { Public declarations }
    property  UltimaColuna: TColumn read GetUltimaColuna write SetUltimaColuna;
  end;

var
  ViewConsultaCEP: TViewConsultaCEP;

implementation

uses
  controller.cep, model.cep, dao.cep, utils.str;

{$R *.dfm}

procedure TViewConsultaCEP.actConsultarCepExecute(Sender: TObject);
var
  Controller: TCEPController;
  ErroAPI: TErroAPI;
  Formato: TFormato;
  Parts: TArray<string>;
  InputStr, UF, Localidade, Logradouro: string;
  InputInt: Integer;
begin
  inherited;

  InputStr := Trim(edtLocation.Text);
  if (InputStr = EmptyStr) then
  begin
    MessageDlg('Informe um valor para pesquisar.', mtInformation, [mbOK], 0);
    Abort;
  end;

  if TryStrToInt(InputStr, InputInt) then
  begin
     if Length(InputStr) <> 8 then
     begin
       MessageDlg('Informe um CEP de 8 dígitos.', mtInformation, [mbOK], 0);
       Abort;
     end;

  end
  else
  begin
    Parts := InputStr.Split([',']);

    UF := Trim(Parts[0]);
    if (Length(UF) <> 2) then
    begin
      MessageDlg('O Campo UF é esperado apenas 2 letras.', mtInformation, [mbOK], 0);
      Abort;
    end;

    Localidade := Parts[1];
    if (Length(Localidade) < 3) then
    begin
      MessageDlg('O Campo Localidade é esperado pelo menos 3 letras.', mtInformation, [mbOK], 0);
      Abort;
    end;

    Logradouro := Parts[2];
    if (Length(Logradouro) < 3) then
    begin
      MessageDlg('O Campo Logradouro é esperado pelo menos 3 letras.', mtInformation, [mbOK], 0);
      Abort;
    end;
  end;

  Controller := TCEPController.Create(dm.conViacep);
  try
    if rgTipo.ItemIndex = 0 then
      Formato := tfJSON
    else
      Formato := tfXML;

    Controller.ConsultaCEP(InputStr, Formato,
      function(const Msg: string; const CEPsExistentes, CEPsNovos: TList<TCEPModel>; IsCEPGeneral: Boolean): Boolean
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
          Option := MessageDlg(Msg, mtConfirmation, [mbOK], 0);
          Result := True
        end;

        if IsCEPGeneral then
        begin
            InputStr := Trim(Self.edtLocation.Text);

            if not TryStrToInt(InputStr, InputInt) then
            begin
              Parts := InputStr.Split([',']);
              if (Length(Parts[0]) = 2) and (Length(Parts[1]) >= 3) and (Length(Parts[2]) >= 3) then
              begin
                Self.edtLocation.Text := Parts[0]+', '+Parts[1];
              end;
            end;
        end;

      end, ErroAPI);

    if ErroAPI.HasError then
    begin
      ShowMessage(Format('Erro: %s', [ErroAPI.Msg]));
    end;

    qryViacep.Refresh;

  finally
    Controller.Free;
  end;
end;

procedure TViewConsultaCEP.dbgEnderecoTitleClick(Column: TColumn);
begin
  OrdenaColuna(Column);
end;

procedure TViewConsultaCEP.dsViacepDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  statConsultaCEP.Panels[1].Text := Format('%0000000d',[qryViacep.RecordCount]);
end;

procedure TViewConsultaCEP.OrdenaColuna(Column: TColumn);
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



procedure TViewConsultaCEP.SetUltimaColuna(const Value: TColumn);
begin
  FUltimaColuna := Value;
end;

procedure TViewConsultaCEP.edtLocationChange(Sender: TObject);
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
            qryViacep.SQL.Text := SQLBase + 'UPPER(uf) LIKE UPPER(:pUF) ORDER BY '+ UltimaColuna.FieldName +' ASC';
            qryViacep.ParamByName('pUF').AsString := Trim(Parts[0]) + '%';

            if (Length(Trim(Parts[0])) = 2) then
            begin
              edtLocation.Text := Trim(Parts[0]);
              edtLocation.SelStart := Length(edtLocation.Text); // Posiciona o cursor no final
            end;
          end;
        2:
          begin
            qryViacep.SQL.Text := SQLBase +
              'UPPER(uf) LIKE UPPER(:pUF) AND unaccent(LOWER(localidade)) LIKE unaccent(LOWER(:pLocalidade)) ORDER BY '+ UltimaColuna.FieldName +' ASC';
            qryViacep.ParamByName('pUF').AsString := '%'+ Trim(Parts[0]) + '%';
            qryViacep.ParamByName('pLocalidade').AsString := '%'+ Trim(Parts[1]) + '%';
          end;
        3:
          begin
            qryViacep.SQL.Text := SQLBase +
              'UPPER(uf) LIKE UPPER(:pUF) AND ' +
              'unaccent(LOWER(localidade)) LIKE unaccent(LOWER(:pLocalidade)) AND ' +
              'unaccent(LOWER(logradouro)) LIKE unaccent(LOWER(:pLogradouro)) ORDER BY '+ UltimaColuna.FieldName +' ASC';

            qryViacep.ParamByName('pUF').AsString := Trim(Parts[0]) + '%';
            qryViacep.ParamByName('pLocalidade').AsString := '%'+ Trim(Parts[1]) + '%';
            qryViacep.ParamByName('pLogradouro').AsString := '%'+ Trim(Parts[2]) + '%';
          end;
      else
        qryViacep.SQL.Text := 'SELECT * FROM ceps ORDER BY '+ UltimaColuna.FieldName +' ASC';
      end;
    end;

    qryViacep.Open;
  finally
    qryViacep.EnableControls;
  end;
end;

procedure TViewConsultaCEP.edtLocationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    actConsultarCepExecute(nil);
end;

procedure TViewConsultaCEP.FormCreate(Sender: TObject);
begin
  inherited;
  qryViacep.Active := True;
  UltimaColuna := dbgEndereco.Columns[0];
  OrdenaColuna(UltimaColuna);
end;

function TViewConsultaCEP.GetUltimaColuna: TColumn;
begin
  if not Assigned(FUltimaColuna) then
  begin
    FUltimaColuna := dbgEndereco.Columns[0];
  end;

  Result := FUltimaColuna;
end;

end.
