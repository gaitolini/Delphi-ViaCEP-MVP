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
    object edtCEP: TEdit
      Left = 4
      Top = 57
      Width = 89
      Height = 21
      TabOrder = 0
      Text = '88395000'
    end
    object rgTipo: TRadioGroup
      Left = 4
      Top = 3
      Width = 170
      Height = 49
      Caption = 'Tipo de sa'#237'da'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'json'
        'xml')
      TabOrder = 1
    end
    object btnConsultar: TButton
      Left = 99
      Top = 55
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 2
      OnClick = btnConsultarClick
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
    ExplicitLeft = 224
    ExplicitTop = 144
    ExplicitWidth = 185
    ExplicitHeight = 41
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
      ExplicitTop = 225
    end
    object mmoResultado: TMemo
      Left = 0
      Top = 0
      Width = 475
      Height = 219
      Align = alClient
      TabOrder = 1
      ExplicitTop = 6
      ExplicitWidth = 473
      ExplicitHeight = 213
    end
  end
  object ViaCEPClient1: TViaCEPClient
    CEP = '88395000'
    OnRequest = ViaCEPClient1Request
    OnResponse = ViaCEPClient1Response
    Left = 360
    Top = 16
  end
end
