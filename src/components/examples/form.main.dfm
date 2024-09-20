object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Exemplo consulta CEP'
  ClientHeight = 329
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 91
    Align = alTop
    BevelOuter = bvSpace
    Caption = 'pnlTop'
    ShowCaption = False
    TabOrder = 0
    object rgTipo: TRadioGroup
      Left = 0
      Top = 39
      Width = 170
      Height = 49
      Caption = 'Tipo de sa'#237'da'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'json'
        'xml')
      TabOrder = 0
    end
    object btnConsultar: TButton
      Left = 178
      Top = 52
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 1
      OnClick = btnConsultarClick
    end
    object edtLocation: TButtonedEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 467
      Height = 31
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TextHint = 'UF, Cidade, Logradouro ou 88395000 '
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 91
    Width = 475
    Height = 238
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlMain'
    ShowCaption = False
    TabOrder = 1
    object statConsultaCEP: TStatusBar
      Left = 0
      Top = 219
      Width = 475
      Height = 19
      Panels = <
        item
          Text = 'Status code'
          Width = 80
        end
        item
          Alignment = taCenter
          Width = 40
        end
        item
          Width = 50
        end>
    end
    object mmoResultado: TMemo
      Left = 0
      Top = 0
      Width = 475
      Height = 219
      Align = alClient
      TabOrder = 1
      ExplicitTop = 3
    end
  end
  object ViaCEPClient1: TViaCEPClient
    OnRequest = ViaCEPClient1Request
    OnResponse = ViaCEPClient1Response
    Left = 360
    Top = 16
  end
end
