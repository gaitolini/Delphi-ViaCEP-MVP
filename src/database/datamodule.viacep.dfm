object dm: Tdm
  OldCreateOrder = False
  Height = 145
  Width = 287
  object connViacep: TFDConnection
    Params.Strings = (
      
        'Database=D:\Desenvolvimento\Delphi\Projetos\Delphi-ViaCEP-MVP\sr' +
        'c\database\viacep.sdb'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object waitViacep: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 96
    Top = 32
  end
  object driverViacep: TFDPhysSQLiteDriverLink
    Left = 160
    Top = 32
  end
  object scriptViacep: TFDScript
    SQLScripts = <
      item
        Name = 'CreateTable'
        SQL.Strings = (
          'CREATE TABLE ceps ('
          '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
          '  cep VARCHAR NOT NULL,'
          '  logradouro VARCHAR(200),'
          '  complemento VARCHAR(50),'
          '  bairro VARCHAR(200),'
          '  localidade VARCHAR(100),'
          '  uf VARCHAR(2),'
          '  estado VARCHAR(150),'
          '  regiao VARCHAR(150),'
          '  ibge INTEGER,'
          '  gia INTEGER,'
          '  ddd INTEGER,'
          '  siafi INTEGER'
          ');'
          '')
      end>
    Connection = connViacep
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 32
    Top = 88
  end
end
