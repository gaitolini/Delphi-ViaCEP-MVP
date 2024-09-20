unit view.main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.Actions,
  System.Skia,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Skia,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.CategoryButtons,
  Vcl.WinXCtrls,
  Vcl.StdCtrls,
  Vcl.StdActns,
  Vcl.Menus,
  view.base,
  view.Utils, Vcl.DBCtrls;

type
  TviewMain = class(TviewBase)
    ActionList1: TActionList;
    actMenu_Home: TAction;
    actMenu_Layout: TAction;
    actMenu_Usuario: TAction;
    actMenu_ControleAcesso: TAction;
    actMenu_API: TAction;
    actEfeitos: TAction;
    actMenu_Carteira: TAction;
    actMenu_Boleto: TAction;
    actMunu_Banco: TAction;
    imlIcons: TImageList;
    ilHotIcons: TImageList;
    SV: TSplitView;
    pnlToolbar: TPanel;
    SkLabel1: TSkLabel;
    imgMenuMain_Toggle: TSkAnimatedImage;
    imgMenuMain_CEP: TSkAnimatedImage;
    sklblMenuMain_CEP: TSkLabel;
    imgMenuMain_Endereco: TSkAnimatedImage;
    sklblMenuMain_Endereco: TSkLabel;
    imgMenuMain_Layout: TSkAnimatedImage;
    sklblMenuMain_layout: TSkLabel;
    imgWallPapper: TSkAnimatedImage;
    imgMenuMain_Picture: TSkAnimatedImage;
    sklblMenuMain_Picture: TSkLabel;
    actAbrirLottie: TFileOpen;
    pmMainMenus: TPopupMenu;
    mniLoop: TMenuItem;
    mniVelocidade: TMenuItem;
    rocar1: TMenuItem;
    mniStart: TMenuItem;
    mniStop: TMenuItem;
    procedure SVOpening(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actMenu_HomeExecute(Sender: TObject);
    procedure actMunu_BancoExecute(Sender: TObject);
    procedure imgMenuMain_ToggleClick(Sender: TObject);
    procedure imgMenuMain_ToggleAnimationFinish(Sender: TObject);
    procedure imgMenuMain_ToggleAnimationStart(Sender: TObject);
    procedure SVClosing(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sklblMenuMain_layoutClick(Sender: TObject);
    procedure actAbrirLottieAccept(Sender: TObject);
    procedure sklblMenuMain_PictureClick(Sender: TObject);
    procedure pmMainMenusPopup(Sender: TObject);
    procedure mniLoopClick(Sender: TObject);
    procedure mniVelocidadeClick(Sender: TObject);
    procedure mniStartClick(Sender: TObject);
    procedure mniStopClick(Sender: TObject);
    procedure imgMenuMain_GenericMouseLeave(Sender: TObject);
    procedure imgMenuMain_EnderecoClick(Sender: TObject);
    procedure imgMenuMain_LayoutClick(Sender: TObject);
    procedure imgMenuMain_PictureClick(Sender: TObject);
    procedure imgMenuMain_CEPClick(Sender: TObject);
    procedure sklblMenuMain_EnderecoClick(Sender: TObject);
    procedure sklblMenuMain_CEPClick(Sender: TObject);
  private
    { Private declarations }
    FCloseOnMenuClick: Boolean;
    procedure ControlSKLabel(var aSKLabel: TSKlabel; aShowing: Boolean );
  public
    { Public declarations }
    property CloseOnMenuClick: Boolean read FCloseOnMenuClick write FCloseOnMenuClick;
  end;

var
  viewMain: TviewMain;

implementation

uses
  view.layout, view.buscacep, view.endereco;

{$R *.dfm}

procedure TviewMain.actMenu_HomeExecute(Sender: TObject);
begin
  inherited;
//    ChildForm<TfrmSplashScreen>.Show;
end;

procedure TviewMain.actMunu_BancoExecute(Sender: TObject);
var debugs: TAlign;
begin
  inherited;

end;
procedure TviewMain.ControlSKLabel(var aSKLabel: TSKlabel; aShowing: Boolean);
begin
  aSKLabel.Visible := aShowing;
  if aShowing then
    aSKLabel.BringToFront
  else
    aSKLabel.SendToBack;
end;

procedure TviewMain.actAbrirLottieAccept(Sender: TObject);
begin
  inherited;
  imgWallPapper.LoadFromFile(actAbrirLottie.Dialog.FileName);
end;

procedure TviewMain.FormCreate(Sender: TObject);
begin
  inherited;
  SV.CloseStyle := svcCompact;
  SV.Opened := False;
  SV.Placement := svpLeft;
  SV.Locked := True;
end;

procedure TviewMain.FormShow(Sender: TObject);
begin
  SV.Visible := False;
  try
//    ChildForm<TfrmSplashScreen>.Show;

  finally
    SV.Visible := True;
    inherited;
    SV.Locked := False;

  end;

  imgMenuMain_CEP.AnimeOneMoretime;
  imgMenuMain_Layout.AnimeOneMoretime;
  imgMenuMain_Endereco.AnimeOneMoretime;
  imgMenuMain_Picture.AnimeOneMoretime;
end;

procedure TviewMain.imgMenuMain_GenericMouseLeave(Sender: TObject);
begin
  inherited;
  TSkAnimatedImage(Sender).Animation.Stop;
end;

procedure TviewMain.imgMenuMain_LayoutClick(Sender: TObject);
begin
  inherited;
  TSkAnimatedImage(Sender).Animation.Stop;
  ChildForm<TviewLayout>(False).Show;
  if SV.Opened and FCloseOnMenuClick then
    SV.Close;
end;

procedure TviewMain.imgMenuMain_PictureClick(Sender: TObject);
begin
  inherited;
  TSkAnimatedImage(Sender).Animation.Stop;
  actAbrirLottie.Execute;
end;

procedure TviewMain.imgMenuMain_CEPClick(Sender: TObject);
begin
  inherited;
  ChildForm<TviewBuscaCEP>(False).Show;
  TSkAnimatedImage(Sender).Animation.Stop;
end;

procedure TviewMain.imgMenuMain_EnderecoClick(Sender: TObject);
begin
  inherited;
  TSkAnimatedImage(Sender).Animation.Stop;
  ChildForm<TviewEndereco>(False).Show;
  if SV.Opened and FCloseOnMenuClick then
    SV.Close;
end;

procedure TviewMain.imgMenuMain_ToggleAnimationFinish(Sender: TObject);
begin
  inherited;
  imgMenuMain_Toggle.Animation.Enabled := False;
end;

procedure TviewMain.imgMenuMain_ToggleAnimationStart(Sender: TObject);
begin
  inherited;
  imgMenuMain_Toggle.Animation.StartProgress := 0;
end;

procedure TviewMain.imgMenuMain_ToggleClick(Sender: TObject);
begin
  inherited;
  imgMenuMain_Toggle.Animation.Enabled := True;
  if SV.Opened then
    SV.Close
  else
    SV.Open;

end;

procedure TviewMain.mniLoopClick(Sender: TObject);
begin
  inherited;
  imgWallPapper.Animation.Loop := mniLoop.Checked;
  imgWallPapper.Animation.Start;
end;

procedure TviewMain.mniStartClick(Sender: TObject);
begin
  inherited;
  imgWallPapper.Animation.Start;
end;

procedure TviewMain.mniStopClick(Sender: TObject);
begin
  inherited;
   imgWallPapper.Animation.Stop;
end;

procedure TviewMain.mniVelocidadeClick(Sender: TObject);
var
    aValueList: array of string;
begin
  SetLength(aValueList,1);
  aValueList[0]:= FloatToStr(imgWallPapper.Animation.Speed);
  inherited;
  InputQuery('Informe um valor para a velocidade da animação',['Valocidade'],aValueList[0]);
  imgWallPapper.Animation.Speed := StrToFloatDef(aValueList[0],imgWallPapper.Animation.Speed);

end;

procedure TviewMain.pmMainMenusPopup(Sender: TObject);
begin
  inherited;
  mniLoop.Checked := imgWallPapper.Animation.Loop;
end;

procedure TviewMain.sklblMenuMain_CEPClick(Sender: TObject);
begin
  inherited;
  ChildForm<TviewBuscaCEP>(False).Show;
  if SV.Opened and FCloseOnMenuClick then
    SV.Close;
end;

procedure TviewMain.sklblMenuMain_EnderecoClick(Sender: TObject);
begin
  inherited;
  ChildForm<TviewEndereco>(False).Show;
  if SV.Opened and FCloseOnMenuClick then
    SV.Close;
end;

procedure TviewMain.sklblMenuMain_layoutClick(Sender: TObject);
begin
  inherited;
  ChildForm<TviewLayout>(False).Show;
  if SV.Opened and FCloseOnMenuClick then
    SV.Close;
end;

procedure TviewMain.sklblMenuMain_PictureClick(Sender: TObject);
begin
  inherited;
  actAbrirLottie.Execute;
end;

procedure TviewMain.SVClosing(Sender: TObject);
begin
  inherited;
  ControlSKLabel(sklblMenuMain_CEP, False);
  ControlSKLabel(sklblMenuMain_Endereco, False);
  ControlSKLabel(sklblMenuMain_layout, False);
  ControlSKLabel(sklblMenuMain_Picture, False);

  imgMenuMain_CEP.AnimeOneMoretime;
  imgMenuMain_Endereco.AnimeOneMoretime;
  imgMenuMain_Layout.AnimeOneMoretime;
  imgMenuMain_Picture.AnimeOneMoretime;
end;

procedure TviewMain.SVOpening(Sender: TObject);
begin
  inherited;

  ControlSKLabel(sklblMenuMain_CEP, True);
  ControlSKLabel(sklblMenuMain_Endereco, True);
  ControlSKLabel(sklblMenuMain_layout, True);
  ControlSKLabel(sklblMenuMain_Picture, True);

  imgMenuMain_CEP.AnimeOneMoretime;
  imgMenuMain_Endereco.AnimeOneMoretime;
  imgMenuMain_Layout.AnimeOneMoretime;
  imgMenuMain_Picture.AnimeOneMoretime;
end;

end.
