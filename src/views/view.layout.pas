unit view.layout;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  System.Skia,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Skia,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.WinXCtrls,
  Vcl.Themes,
  view.base;

type
  TviewLayout = class(TviewBase)
    pnlSettings: TPanel;
    lblLog: TLabel;
    lblVclStyle: TLabel;
    grpDisplayMode: TRadioGroup;
    grpPlacement: TRadioGroup;
    grpCloseStyle: TRadioGroup;
    lstLog: TListBox;
    grpAnimation: TGroupBox;
    lblAnimationDelay: TLabel;
    lblAnimationStep: TLabel;
    chkUseAnimation: TCheckBox;
    trkAnimationDelay: TTrackBar;
    trkAnimationStep: TTrackBar;
    chkCloseOnMenuClick: TCheckBox;
    cbxVclStyles: TComboBox;
    procedure trkAnimationDelayChange(Sender: TObject);
    procedure trkAnimationStepChange(Sender: TObject);
    procedure grpCloseStyleClick(Sender: TObject);
    procedure grpDisplayModeClick(Sender: TObject);
    procedure grpPlacementClick(Sender: TObject);
    procedure cbxVclStylesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkUseAnimationClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkCloseOnMenuClickClick(Sender: TObject);
  private
    { Private declarations }
    procedure Log(const Msg: string);
  public
    { Public declarations }
  end;

var
  viewLayout: TviewLayout;

implementation

uses
  view.main;

{$R *.dfm}

{ TfrmLayout }


{ TfrmLayout }

procedure TviewLayout.cbxVclStylesClick(Sender: TObject);
begin
  inherited;
  TStyleManager.SetStyle(cbxVclStyles.Text);
end;

procedure TviewLayout.chkCloseOnMenuClickClick(Sender: TObject);
begin
  inherited;
  viewMain.CloseOnMenuClick := chkCloseOnMenuClick.Checked;
end;

procedure TviewLayout.chkUseAnimationClick(Sender: TObject);
begin
  inherited;
  viewMain.SV.UseAnimation := chkUseAnimation.Checked;
  lblAnimationDelay.Enabled := viewMain.SV.UseAnimation;
  trkAnimationDelay.Enabled := viewMain.SV.UseAnimation;
  lblAnimationStep.Enabled := viewMain.SV.UseAnimation;
  trkAnimationStep.Enabled := viewMain.SV.UseAnimation;
end;

procedure TviewLayout.FormCreate(Sender: TObject);
var
  StyleName: string;
begin
  for StyleName in TStyleManager.StyleNames do
    cbxVclStyles.Items.Add(StyleName);

  cbxVclStyles.ItemIndex := cbxVclStyles.Items.IndexOf(TStyleManager.ActiveStyle.Name);

  inherited;
end;

procedure TviewLayout.FormShow(Sender: TObject);
begin
  inherited;
  grpCloseStyle.ItemIndex      := Integer( viewMain.SV.CloseStyle);
  grpDisplayMode.ItemIndex    := Integer(viewMain.SV.DisplayMode);
  grpPlacement.ItemIndex      := Integer(viewMain.SV.Placement);
  trkAnimationStep.Position   := viewMain.SV.AnimationStep * 5;
  trkAnimationDelay.Position  := viewMain.SV.AnimationDelay * 5;
  chkCloseOnMenuClick.Checked := viewMain.CloseOnMenuClick;
end;

procedure TviewLayout.grpCloseStyleClick(Sender: TObject);
begin
  inherited;
 viewMain.SV.CloseStyle := TSplitViewCloseStyle(grpCloseStyle.ItemIndex);
end;

procedure TviewLayout.grpDisplayModeClick(Sender: TObject);
begin
  inherited;
  viewMain.SV.DisplayMode := TSplitViewDisplayMode(grpDisplayMode.ItemIndex);
  if viewMain.SV.DisplayMode = svmOverlay then
    viewMain.SV.BringToFront;

end;

procedure TviewLayout.grpPlacementClick(Sender: TObject);
begin
  inherited;
  viewMain.SV.Placement := TSplitViewPlacement(grpPlacement.ItemIndex);
  viewMain.imgMenuMain_Toggle.Align :=  TAlign(IfThen(viewMain.SV.Placement = svpLeft, Integer(alLeft), Integer(alRight)));
end;

procedure TviewLayout.Log(const Msg: string);
var
  Idx: Integer;
begin
  Idx := lstLog.Items.Add(Msg);
  lstLog.TopIndex := Idx;
end;

procedure TviewLayout.trkAnimationDelayChange(Sender: TObject);
begin
  inherited;
  viewMain.SV.AnimationDelay := trkAnimationDelay.Position * 5;
  lblAnimationDelay.Caption := 'Animation Delay (' + IntToStr(viewMain.SV.AnimationDelay) + ')';
end;

procedure TviewLayout.trkAnimationStepChange(Sender: TObject);
begin
  inherited;
  viewMain.SV.AnimationStep := trkAnimationStep.Position * 5;
  lblAnimationStep.Caption := 'Animation Step (' + IntToStr(viewMain.SV.AnimationStep) + ')';
end;

end.
