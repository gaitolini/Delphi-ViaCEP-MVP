unit view.utils;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.JSON,
  System.Skia,
  Vcl.Clipbrd,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Skia,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.ImgList,
  Vcl.StdCtrls,
  Vcl.WinXCtrls,
  Vcl.DBCtrls,
  JSONTreeView;

type
  TSkAnimatedImageHelper = class helper for TSkAnimatedImage
  public
    procedure AnimeOneMoretime;
  end;

  TBalloonHintHelper = class helper for TBalloonHint
  public
    procedure ShowMessage(const aControl: TControl; const AMessage: string; const DlgType: TMsgDlgType);
  end;

  TJSONTreeViewHelper = class helper for TJSONTreeView
  public
    procedure CopySelectedNodes;
    procedure SelectAllNodes;
  end;

 TStatusBarHelper = class helper for TStatusBar
 public
    procedure AtualizaStatusBar(const aStatus, aMsg: string);

 end;
implementation


procedure TJSONTreeViewHelper.CopySelectedNodes;
var
  Node: TTreeNode;
  ClipboardText: string;
  I: Integer;
begin
  ClipboardText := '';

  // Percorre n�s selecionados e copia o conte�do
    for I := 0 to Self.SelectionCount-1 do
    begin
       Node := Self.Selections[I];
       if Node <> nil then
       begin
         ClipboardText := ClipboardText + Node.Text + sLineBreak;
       end;

    end;

//    while Node <> nil do
//    begin
//      ClipboardText := ClipboardText + Node.Text + sLineBreak;
//      Node := Self.Selected.getNextSibling;
//
//    end;

    // Coloca o texto copiado na �rea de transfer�ncia
    Clipboard.AsText := ClipboardText;
end;

procedure TJSONTreeViewHelper.SelectAllNodes;
var
  Node: TTreeNode;
begin
  // Habilite a sele��o m�ltipla
  Self.MultiSelect := True;

  // Pega o primeiro n�
  Node := Self.Items.GetFirstNode;

  // Seleciona todos os n�s
  while Node <> nil do
  begin
    Node.Selected := True;
    Node := Node.GetNext;
  end;
end;

//var
//  Node: TTreeNode;
//begin
//   Self.MultiSelect := True;
//  for node in Self.Items do
//  begin
//    node.Selected := True;
//  end;
//end;

{ TStatusBarHelper }

procedure TStatusBarHelper.AtualizaStatusBar(const aStatus, aMsg: string);
begin
  if Self.Panels.Count > 3 then
  begin
    Self.Panels[1].Text := aStatus;
    Self.Panels[3].Text := aMsg;
  end;
//  else
//    raise Exception.Create('StatusBar does not have enough panels.');
end;

{ TBalloonHintHelper }

procedure TBalloonHintHelper.ShowMessage(const aControl: TControl; const AMessage: string; const DlgType: TMsgDlgType);
var
  ImageIndex: Integer;
begin
  // Determina o �ndice da imagem com base no tipo de mensagem (TMsgDlgType)
  case DlgType of
    mtWarning:   ImageIndex := 0;  // Exemplo: �ndice 0 para "Warning"
    mtError:     ImageIndex := 1;  // Exemplo: �ndice 1 para "Error"
    mtInformation: ImageIndex := 2;  // Exemplo: �ndice 2 para "Information"
    mtConfirmation: ImageIndex := 3;  // Exemplo: �ndice 3 para "Confirmation"
  else
    ImageIndex := -1;  // Sem imagem para outros tipos
  end;

  // Configura o t�tulo do bal�o com base no tipo de mensagem
  case DlgType of
    mtWarning:       Self.Title := 'Warning';
    mtError:         Self.Title := 'Error';
    mtInformation:   Self.Title := 'Information';
    mtConfirmation:  Self.Title := 'Confirmation';
  else
    Self.Title := 'Message';
  end;

  // Define a descri��o (a mensagem em si)
  Self.Description := AMessage;

  // Associa a imagem de acordo com o tipo da mensagem
  Self.ImageIndex := ImageIndex;
  Self.Delay := 800;
  Self.HideAfter := 800;
  // Exibe o bal�o de dica associado ao controle passado
  Self.ShowHint(aControl);
end;

{ TSkAnimatedImageHelper }

procedure TSkAnimatedImageHelper.AnimeOneMoretime;
begin
    Self.Animation.Start;

    TThread.CreateAnonymousThread(
    procedure
    begin
      // Simula o carregamento ou realiza tarefas de inicializa��o
      Sleep(Round(Self.Animation.Duration)*1000); // Substitua por tarefas de inicializa��o reais

        TThread.Synchronize(nil,
        procedure
        begin
          // Fecha e libera a Splash Screen ap�s a inicializa��o
           Self.Animation.Stop;
        end);
    end).Start;
end;

end.

