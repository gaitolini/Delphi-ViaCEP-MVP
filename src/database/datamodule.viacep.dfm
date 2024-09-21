object dm: Tdm
  OldCreateOrder = False
  Height = 145
  Width = 373
  object conViacep: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 5432
    Database = 'viacepdb'
    Username = 'postgres'
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 16
    EncryptedPassword = 'CFFFCBFFCFFFC9FFCFFFC7FFCEFFCEFF'
  end
  object transcViacep: TUniTransaction
    DefaultConnection = conViacep
    Left = 216
    Top = 16
  end
  object driverPGViacep: TPostgreSQLUniProvider
    Left = 128
    Top = 16
  end
  object dmpViacep: TUniDump
    Connection = conViacep
    Left = 120
    Top = 80
  end
  object scrptDDL: TUniScript
    SQL.Strings = (
      '-- Verifica se a extens'#227'o dblink est'#225' instalada'
      'DO'
      '$$'
      'BEGIN'
      
        '   IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = '#39'db' +
        'link'#39') THEN'
      '      CREATE EXTENSION dblink;'
      '   END IF;'
      'END'
      '$$;'
      ''
      '-- Cria a tabela "ceps" no banco de dados "viacepdb"'
      'SELECT dblink_exec('
      
        '  '#39'dbname=viacepdb user=postgres password=04060811'#39',  -- Conex'#227'o' +
        ' com o banco viacepdb'
      '  '#39'CREATE TABLE IF NOT EXISTS public.ceps ( '#39' ||'
      '  '#39'  id SERIAL PRIMARY KEY, '#39' ||'
      '  '#39'  cep VARCHAR(9) NOT NULL, '#39' ||'
      '  '#39'  logradouro VARCHAR(200), '#39' ||'
      '  '#39'  complemento VARCHAR(50), '#39' ||'
      '  '#39'  bairro VARCHAR(200), '#39' ||'
      '  '#39'  localidade VARCHAR(100), '#39' ||'
      '  '#39'  uf VARCHAR(2), '#39' ||'
      '  '#39'  estado VARCHAR(150), '#39' ||'
      '  '#39'  regiao VARCHAR(150), '#39' ||'
      '  '#39'  ibge INTEGER, '#39' ||'
      '  '#39'  gia INTEGER, '#39' ||'
      '  '#39'  ddd INTEGER, '#39' ||'
      '  '#39'  siafi INTEGER '#39' ||'
      '  '#39');'#39
      ');')
    Connection = conViacep
    Left = 184
    Top = 80
  end
  object scrptDML: TUniScript
    SQL.Strings = (
      'DO'
      '$$'
      'BEGIN'
      
        '   -- Verifica se a extens'#227'o "dblink" j'#225' est'#225' instalada no banco' +
        ' de dados atual (postgres)'
      
        '   IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = '#39'db' +
        'link'#39') THEN'
      '      -- Se n'#227'o estiver, instala a extens'#227'o dblink'
      '      CREATE EXTENSION dblink;'
      '   END IF;'
      ''
      '   -- Verifica se o banco de dados "viacepdb" j'#225' existe'
      
        '   IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = '#39'via' +
        'cepdb'#39') THEN'
      '      -- Se n'#227'o existir, cria o banco de dados usando dblink'
      '      PERFORM dblink_exec('
      
        '        '#39'dbname=postgres user=postgres password=04060811'#39',  -- A' +
        'juste suas credenciais'
      '        '#39'CREATE DATABASE viacepdb'
      '         WITH OWNER = postgres'
      '         ENCODING = '#39#39'UTF8'#39#39
      '         LC_COLLATE = '#39#39'Portuguese_Brazil.1252'#39#39
      '         LC_CTYPE = '#39#39'Portuguese_Brazil.1252'#39#39
      '         TABLESPACE = pg_default'
      '         CONNECTION LIMIT = -1;'#39
      '      );'
      '   END IF;'
      ''
      'END'
      '$$;')
    Connection = conViacep
    Left = 248
    Top = 80
  end
end
