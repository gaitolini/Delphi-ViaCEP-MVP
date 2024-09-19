{************************************************************************}
{                                                                        }
{                              Form Base                                 }
{                                                                        }
{ Copyright (c) 2024-2024 Anderson Gaitolini.                           }
{                                                                        }
{ Use of this source code is governed by the MIT license that can be     }
{ found in the LICENSE file.                                             }
{                                                                        }
{************************************************************************}
unit view.base;

interface

{$SCOPEDENUMS ON}

uses
  { Delphi }
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.IOUtils,
  System.Generics.Collections,
  System.Math.Vectors,
  System.ImageList,
  System.Actions,
  System.Rtti,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.CategoryButtons,
  Vcl.WinXCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ImgList,
  Vcl.ActnList,
  { Skia }
  System.Skia,
  Vcl.Skia;

type
  { TScrollBox }

  TScrollBox = class(Vcl.Forms.TScrollBox)
  protected
    procedure WMEraseBkgnd(var AMessage: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMHScroll(var AMessage: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var AMessage: TWMVScroll); message WM_VSCROLL;
  end;

  { TfrmBase }

  TviewBase = class(TForm)
    sbxContent: TScrollBox;
    pnlContent: TPanel;
    pnlTitle: TPanel;
    lblTitle: TSkLabel;
    pnlBack: TPanel;
    pnlTip: TPanel;
    svgTipIcon: TSkSvg;
    pnlTipLine: TPanel;
    pnlTipContent: TPanel;
    lblTipDescription: TSkLabel;
    imgCloseFormAction: TSkAnimatedImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pnlContentResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgCloseFormActionClick(Sender: TObject);
    procedure imgCloseFormActionMouseEnter(Sender: TObject);
    procedure imgCloseFormActionMouseLeave(Sender: TObject);
  private
    class var
      FCreatedFormsList: TList<TViewBase>;
      FShowingFormsList: TList<TViewBase>;
      FFormInstances: TDictionary<TClass, TViewBase>;
    class function GetAssetsPath: string; static;
    class function GetOutputPath: string; static;
    procedure CMBiDiModeChanged(var AMessage: TMessage); message CM_BIDIMODECHANGED;
    function CreateForm<T: TForm>: T;
  protected
    class procedure CloseForm(const AForm: TViewBase); static;
    class constructor Create;
    class destructor Destroy;
    class function FormBackgroundColor: TColor; virtual;
    class function FormBorderColor: TColor; static;
    class function GetCurrentForm: TViewBase; static;
    class property AssetsPath: string read GetAssetsPath;
    class property OutputPath: string read GetOutputPath;
  protected
    procedure BeginUpdate;
    function ChildForm<T: TForm>(AllowMultipleInstances: Boolean = False): T;
    procedure DoShow; override;
    procedure EndUpdate;
    procedure ScrollBoxChanged(ASender: TObject); virtual;
    procedure ScrollBoxEraseBackground(ASender: TObject; const ADC: HDC); virtual;
    procedure ShowMessage(const AMessage: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Show; reintroduce;
    function ShowModal: Integer; override;
    procedure FecharForm;
  end;

implementation

{$R *.dfm}

{ TfrmBase }

procedure TviewBase.BeginUpdate;
begin
  SendMessage(Application.MainForm.Handle, WM_SETREDRAW, Integer(False), 0);
  Application.MainForm.DisableAlign;
end;

function TviewBase.ChildForm<T>(AllowMultipleInstances: Boolean): T;
var
  LSelfIndex: Integer;
  ExistingForm, frmCreate: TViewBase;
begin
  Assert(T.InheritsFrom(TViewBase));

  LSelfIndex := FCreatedFormsList.IndexOf(Self);
  if (LSelfIndex >= 0) and (LSelfIndex < FCreatedFormsList.Count - 1) and (FCreatedFormsList[LSelfIndex + 1].ClassType = T) then
    Exit(T(FCreatedFormsList[LSelfIndex + 1]));

  // Verifica se não é permitido múltiplas instâncias e o formulário já está aberto
  if not AllowMultipleInstances then
  begin
    for ExistingForm in FShowingFormsList do
    begin
      if ExistingForm is T then
      begin
        // Formulário já aberto, traz para frente
        ExistingForm.BringToFront;

        // Ajusta visibilidade dos painéis
        if FShowingFormsList.Last <> ExistingForm then
        begin
          FShowingFormsList.Last.pnlContent.Visible := False; // Oculta o formulário anterior
          ExistingForm.pnlContent.Visible := True; // Mostra o formulário desejado
        end;

        // Move o formulário para o final da lista para que ele seja o ativo
        FShowingFormsList.Remove(ExistingForm);
        FShowingFormsList.Add(ExistingForm);
        // Maximiza o formulário se não estiver já maximizado
        ExistingForm.WindowState := wsNormal;
        ExistingForm.pnlContent.Align := alClient;

        Result := T(ExistingForm);
        Exit;
      end;
    end;
  end;

  // Se permitir múltiplas instâncias ou não encontrar um formulário aberto, criar um novo
  Result := CreateForm<T>;
  TViewBase(Result).pnlContent.Align := TAlign.alClient;
  TViewBase(Result).pnlBack.Visible := FShowingFormsList.Count > 0;
  FCreatedFormsList.Add(TViewBase(Result));
end;

class procedure TviewBase.CloseForm(const AForm: TViewBase);
var
  LFormIndex: Integer;
  LAction: TCloseAction;
  I: Integer;
  aFormClosing: TViewBase;
begin
  try

    LFormIndex := FShowingFormsList.IndexOf(AForm);
    if LFormIndex < 0 then
      Exit;

    TViewBase(Application.MainForm).BeginUpdate;

    LAction := TCloseAction.caFree;
    AForm.DoClose(LAction);  // Permite que o formulário execute sua lógica de fechamento

    if LAction = TCloseAction.caNone then
      Exit;

    // Remover o formulário da lista de formulários visíveis
    FShowingFormsList.Remove(AForm);

    // Liberar memória do formulário, se necessário
    if LAction = TCloseAction.caFree then
      AForm.Free;

    // Se ainda houver formulários na lista, trazer o último para a frente
    if FShowingFormsList.Count > 0 then
    begin
      FShowingFormsList.Last.pnlContent.Visible := True;
      FShowingFormsList.Last.BringToFront;
    end;

  finally
    TViewBase(Application.MainForm).EndUpdate;
  end;

end;

procedure TviewBase.CMBiDiModeChanged(var AMessage: TMessage);
begin
  inherited;
  pnlContent.BiDiMode := BiDiMode;
  pnlContent.ParentBiDiMode := False;
end;

class constructor TviewBase.Create;
begin
  FFormInstances    := TDictionary<TClass, TViewBase>.Create;
  FCreatedFormsList := TList<TViewBase>.Create;
  FShowingFormsList := TList<TViewBase>.Create;
end;

constructor TviewBase.Create(AOwner: TComponent);
begin
  if Application.MainForm = nil then
    TStyleManager.TrySetStyle('Windows11 Modern Light', False);
  inherited;
end;

function TviewBase.CreateForm<T>: T;
{$IF CompilerVersion < 34}
var
  LRttiContext: TRttiContext;
begin
  LRttiContext := TRttiContext.Create;
  try
    Result := LRttiContext.GetType(TClass(T)).GetMethod('Create').Invoke(TClass(T), [TValue.From(Application)]).AsType<T>;
  finally
    LRttiContext.Free;
  end;
{$ELSE}
begin
  Result := T.Create(Application);
{$ENDIF}
end;

class destructor TviewBase.Destroy;
var
  FormInstance: TViewBase;
begin
  for FormInstance in FFormInstances.Values do
    FormInstance.Free;

  FFormInstances.Free;
  FShowingFormsList.Free;
  FCreatedFormsList.Free;
end;

procedure TviewBase.DoShow;
var
  LPreventUpdates: Boolean;
begin
  LPreventUpdates := Assigned(Application.MainForm) and Application.MainForm.Active;
  if LPreventUpdates then
    BeginUpdate;

  try
    pnlTip.Visible := not lblTipDescription.Caption.IsEmpty;
    if Self = Application.MainForm then
    begin
      pnlBack.Visible := False;
      FShowingFormsList.Add(Self);
    end
    else
    if FShowingFormsList.Contains(Self) then
    begin
      // Se o formulário já está na lista, apenas o traz à frente
      pnlContent.Visible := True;
    end
    else
    begin
      // Se não estiver na lista, adiciona-o e ajusta a visibilidade
      if FShowingFormsList.Count > 0 then
        FShowingFormsList.Last.pnlContent.Visible := False; // Oculta o formulário anterior

      FShowingFormsList.Add(Self);
      pnlContent.Parent := Application.MainForm;
    end;

    // Ajuste o formulário para ser maximizado e alinhado corretamente
    Self.WindowState := wsNormal;
    Self.pnlContent.Align := alClient; // Garante que o conteúdo se alinha ao cliente
    pnlContentResize(nil); // Ajusta o layout, se necessário
  finally
    if LPreventUpdates then
      EndUpdate;

    // Disparar manualmente o OnShow se existir
    if Assigned(OnShow) then
      OnShow(Self);
  end;
end;

procedure TviewBase.EndUpdate;
begin
  Application.MainForm.EnableAlign;
  SendMessage(Application.MainForm.Handle, WM_SETREDRAW, Integer(True), 0);
  RedrawWindow(Application.MainForm.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
end;

procedure TviewBase.FecharForm;
begin
  {$IF CompilerVersion >= 32}
  TThread.ForceQueue(nil,
    procedure
    begin
      CloseForm(Self);
    end);
  {$ELSE}
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          CloseForm(Self);
        end);
    end).Start;
  {$ENDIF}
end;

class function TviewBase.FormBackgroundColor: TColor;
begin
  Result :=  $00FBFBFB  //$00FBFBFB; // Mica material
end;

class function TviewBase.FormBorderColor: TColor;
begin
  Result := $00FF5C5B; //$00BE6414; //$00F6F3F2; // Mica material
end;

procedure TviewBase.FormCreate(Sender: TObject);
begin
  Color := FormBackgroundColor;
  pnlContent.Color := FormBackgroundColor;
  sbxContent.Color := FormBackgroundColor;
  pnlTitle.Color := FormBorderColor;
  pnlTip.Color := FormBorderColor;
end;

procedure TviewBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  case Key of
//    vkEscape, vkBack, vkHardwareBack:
//      if (GetCurrentForm <> Application.MainForm) and GetCurrentForm.pnlBack.Showing then
//      begin
//        CloseForm(GetCurrentForm);
//        Key := 0;
//      end;
//  else
//  end;
end;

procedure TviewBase.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Self <> GetCurrentForm then
    GetCurrentForm.DoMouseWheel(Shift, WheelDelta, MousePos)
  else
  begin
    sbxContent.VertScrollBar.Position := sbxContent.VertScrollBar.Position - WheelDelta;
    Handled := True;
  end;
end;

procedure TviewBase.FormShow(Sender: TObject);
begin
  if Self <> Application.MainForm then
  begin

    imgCloseFormAction.Animation.Start;
    TThread.CreateAnonymousThread(
    procedure
    begin
      // Simula o carregamento ou realiza tarefas de inicialização
      Sleep(2880); // Substitua por tarefas de inicialização reais

        TThread.Synchronize(nil,
        procedure
        begin
          // Fecha e libera a Splash Screen após a inicialização
          if Assigned(imgCloseFormAction) then
           imgCloseFormAction.Animation.Stop;
        end);
    end).Start;
  end;
end;

class function TviewBase.GetAssetsPath: string;
begin
  Result := TPath.GetFullPath('..\..\..\..\Assets\');
  if (Result <> '') and not Result.EndsWith(PathDelim) then
    Result := Result + PathDelim;
end;

class function TviewBase.GetCurrentForm: TViewBase;
begin
  Result := FShowingFormsList.Last;
end;

class function TviewBase.GetOutputPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
  if (Result <> '') and not Result.EndsWith(PathDelim) then
    Result := Result + PathDelim;
end;

procedure TviewBase.imgCloseFormActionClick(Sender: TObject);
begin
  imgCloseFormAction.Animation.Stop;
  FecharForm;
end;

procedure TviewBase.imgCloseFormActionMouseEnter(Sender: TObject);
begin
  imgCloseFormAction.Animation.Start;
end;

procedure TviewBase.imgCloseFormActionMouseLeave(Sender: TObject);
begin
  imgCloseFormAction.Animation.Stop;
end;

procedure TviewBase.pnlContentResize(Sender: TObject);
begin
  if pnlTip.Visible then
    pnlTip.Height := lblTipDescription.Height + 16;
end;

procedure TviewBase.ScrollBoxChanged(ASender: TObject);
begin
  TScrollBox(ASender).Repaint;
end;

procedure TviewBase.ScrollBoxEraseBackground(ASender: TObject; const ADC: HDC);
begin
end;

procedure TviewBase.Show;
begin
  DoShow;
end;

procedure TviewBase.ShowMessage(const AMessage: string);
begin
  MessageDlg(AMessage, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
end;

function TviewBase.ShowModal: Integer;
begin
  Show;
  Result := 0;
end;

{ TScrollBox }

procedure TScrollBox.WMEraseBkgnd(var AMessage: TWMEraseBkgnd);
begin
  inherited;
  if Owner is TViewBase then
    TViewBase(Owner).ScrollBoxEraseBackground(Self, AMessage.DC);
end;

procedure TScrollBox.WMHScroll(var AMessage: TWMHScroll);
begin
  inherited;
  if Owner is TViewBase then
    TViewBase(Owner).ScrollBoxChanged(Self);
end;

procedure TScrollBox.WMVScroll(var AMessage: TWMVScroll);
begin
  inherited;
  if Owner is TViewBase then
    TViewBase(Owner).ScrollBoxChanged(Self);
end;

end.
