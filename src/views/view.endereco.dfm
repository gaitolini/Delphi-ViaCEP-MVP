inherited ViewEndereco: TViewEndereco
  Caption = 'ViewEndereco'
  PixelsPerInch = 96
  TextHeight = 15
  inherited pnlContent: TPanel
    inherited sbxContent: TScrollBox
      ExplicitTop = 30
      object lbl: TLabel
        Left = 24
        Top = 32
        Width = 19
        Height = 15
        Caption = 'cep'
        FocusControl = edtcep
      end
      object lbl1: TLabel
        Left = 24
        Top = 80
        Width = 59
        Height = 15
        Caption = 'logradouro'
        FocusControl = edtlogradouro
      end
      object lbl2: TLabel
        Left = 330
        Top = 80
        Width = 75
        Height = 15
        Caption = 'complemento'
        FocusControl = edtcomplemento
      end
      object lbl3: TLabel
        Left = 519
        Top = 80
        Width = 31
        Height = 15
        Caption = 'bairro'
        FocusControl = edtbairro
      end
      object lbl4: TLabel
        Left = 24
        Top = 123
        Width = 35
        Height = 15
        Caption = 'estado'
        FocusControl = edtestado
      end
      object lbl5: TLabel
        Left = 338
        Top = 123
        Width = 11
        Height = 15
        Caption = 'uf'
        FocusControl = edtuf
      end
      object lbl6: TLabel
        Left = 378
        Top = 123
        Width = 33
        Height = 15
        Caption = 'regiao'
        FocusControl = edtregiao
      end
      object lbl7: TLabel
        Left = 23
        Top = 165
        Width = 23
        Height = 15
        Caption = 'ibge'
        FocusControl = edtibge
      end
      object lbl8: TLabel
        Left = 23
        Top = 213
        Width = 16
        Height = 15
        Caption = 'gia'
        FocusControl = edtgia
      end
      object lbl9: TLabel
        Left = 195
        Top = 165
        Width = 21
        Height = 15
        Caption = 'ddd'
        FocusControl = edtddd
      end
      object lbl10: TLabel
        Left = 195
        Top = 213
        Width = 21
        Height = 15
        Caption = 'siafi'
        FocusControl = edtsiafi
      end
      object edtcep: TDBEdit
        Left = 24
        Top = 48
        Width = 139
        Height = 23
        DataField = 'cep'
        DataSource = dsViacep
        TabOrder = 0
      end
      object edtlogradouro: TDBEdit
        Left = 24
        Top = 96
        Width = 300
        Height = 23
        DataField = 'logradouro'
        DataSource = dsViacep
        TabOrder = 1
      end
      object edtcomplemento: TDBEdit
        Left = 330
        Top = 96
        Width = 183
        Height = 23
        DataField = 'complemento'
        DataSource = dsViacep
        TabOrder = 2
      end
      object edtbairro: TDBEdit
        Left = 519
        Top = 96
        Width = 300
        Height = 23
        DataField = 'bairro'
        DataSource = dsViacep
        TabOrder = 3
      end
      object edtestado: TDBEdit
        Left = 24
        Top = 139
        Width = 300
        Height = 23
        DataField = 'estado'
        DataSource = dsViacep
        TabOrder = 4
      end
      object edtuf: TDBEdit
        Left = 338
        Top = 139
        Width = 34
        Height = 23
        DataField = 'uf'
        DataSource = dsViacep
        TabOrder = 5
      end
      object edtregiao: TDBEdit
        Left = 378
        Top = 139
        Width = 200
        Height = 23
        DataField = 'regiao'
        DataSource = dsViacep
        TabOrder = 6
      end
      object edtibge: TDBEdit
        Left = 23
        Top = 181
        Width = 154
        Height = 23
        DataField = 'ibge'
        DataSource = dsViacep
        TabOrder = 7
      end
      object edtgia: TDBEdit
        Left = 23
        Top = 229
        Width = 154
        Height = 23
        DataField = 'gia'
        DataSource = dsViacep
        TabOrder = 8
      end
      object edtddd: TDBEdit
        Left = 195
        Top = 181
        Width = 154
        Height = 23
        DataField = 'ddd'
        DataSource = dsViacep
        TabOrder = 9
      end
      object edtsiafi: TDBEdit
        Left = 195
        Top = 229
        Width = 154
        Height = 23
        DataField = 'siafi'
        DataSource = dsViacep
        TabOrder = 10
      end
    end
    inherited pnlTitle: TPanel
      inherited lblTitle: TSkLabel
        Words = <
          item
            Caption = 'Endere'#231'o'
            FontColor = claAliceblue
            StyledSettings = [Family, Size, Style]
          end>
      end
    end
  end
  object qryViacep: TUniQuery
    SQLInsert.Strings = (
      'INSERT INTO ceps'
      
        '  (id, cep, logradouro, complemento, bairro, localidade, uf, est' +
        'ado, regiao, ibge, gia, ddd, siafi)'
      'VALUES'
      
        '  (:id, :cep, :logradouro, :complemento, :bairro, :localidade, :' +
        'uf, :estado, :regiao, :ibge, :gia, :ddd, :siafi)')
    SQLDelete.Strings = (
      'DELETE FROM ceps'
      'WHERE'
      '  id = :Old_id')
    SQLUpdate.Strings = (
      'UPDATE ceps'
      'SET'
      
        '  id = :id, cep = :cep, logradouro = :logradouro, complemento = ' +
        ':complemento, bairro = :bairro, localidade = :localidade, uf = :' +
        'uf, estado = :estado, regiao = :regiao, ibge = :ibge, gia = :gia' +
        ', ddd = :ddd, siafi = :siafi'
      'WHERE'
      '  id = :Old_id')
    SQLLock.Strings = (
      'SELECT * FROM ceps'
      'WHERE'
      '  id = :Old_id'
      'FOR UPDATE NOWAIT')
    SQLRefresh.Strings = (
      
        'SELECT id, cep, logradouro, complemento, bairro, localidade, uf,' +
        ' estado, regiao, ibge, gia, ddd, siafi FROM ceps'
      'WHERE'
      '  id = :id')
    SQLRecCount.Strings = (
      'SELECT count(*) FROM ('
      'SELECT * FROM ceps'
      ''
      ') t')
    Connection = dm.conViacep
    SQL.Strings = (
      'SELECT * FROM ceps order by cep asc')
    Left = 784
    Top = 72
    object qryViacepid: TIntegerField
      FieldName = 'id'
    end
    object strngfldViacepcep: TStringField
      FieldName = 'cep'
      Required = True
      Size = 9
    end
    object strngfldViaceplogradouro: TStringField
      FieldName = 'logradouro'
      Size = 200
    end
    object strngfldViacepcomplemento: TStringField
      FieldName = 'complemento'
      Size = 50
    end
    object strngfldViacepbairro: TStringField
      FieldName = 'bairro'
      Size = 200
    end
    object strngfldViaceplocalidade: TStringField
      FieldName = 'localidade'
      Size = 100
    end
    object strngfldViacepuf: TStringField
      FieldName = 'uf'
      Size = 2
    end
    object strngfldViacepestado: TStringField
      FieldName = 'estado'
      Size = 150
    end
    object strngfldViacepregiao: TStringField
      FieldName = 'regiao'
      Size = 150
    end
    object qryViacepibge: TIntegerField
      FieldName = 'ibge'
    end
    object qryViacepgia: TIntegerField
      FieldName = 'gia'
    end
    object qryViacepddd: TIntegerField
      FieldName = 'ddd'
    end
    object qryViacepsiafi: TIntegerField
      FieldName = 'siafi'
    end
  end
  object dsViacep: TUniDataSource
    DataSet = qryViacep
    Left = 736
    Top = 80
  end
end
