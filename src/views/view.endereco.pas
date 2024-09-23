unit view.endereco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, view.base, System.Skia, Vcl.Skia,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB, DBAccess, Uni,
  MemDS;

type
  TViewEndereco = class(TviewBase)
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
    dsViacep: TUniDataSource;
    lbl: TLabel;
    edtcep: TDBEdit;
    lbl1: TLabel;
    edtlogradouro: TDBEdit;
    lbl2: TLabel;
    edtcomplemento: TDBEdit;
    lbl3: TLabel;
    edtbairro: TDBEdit;
    lbl4: TLabel;
    edtestado: TDBEdit;
    lbl5: TLabel;
    edtuf: TDBEdit;
    lbl6: TLabel;
    edtregiao: TDBEdit;
    lbl7: TLabel;
    edtibge: TDBEdit;
    lbl8: TLabel;
    edtgia: TDBEdit;
    lbl9: TLabel;
    edtddd: TDBEdit;
    lbl10: TLabel;
    edtsiafi: TDBEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewEndereco: TViewEndereco;

implementation

uses
  datamodule.viacep;

{$R *.dfm}

procedure TViewEndereco.FormShow(Sender: TObject);
begin
  inherited;
  qryViacep.Active := True;
end;

end.
