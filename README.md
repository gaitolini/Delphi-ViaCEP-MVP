# 🚀 Delphi ViaCEP MVP

Este repositório contém um MVP (Minimum Viable Product) desenvolvido em Delphi, que permite realizar consultas de CEP utilizando o web service público do [ViaCEP](https://viacep.com.br/). O objetivo é realizar consultas de CEP e endereços completos, armazenar os resultados em um banco de dados e navegar pelos registros.

## 📑 Especificações Técnicas

### Funcionalidades Principais:
- 🔍 **Consulta de CEP** por meio da API pública do ViaCEP.
- 🏙️ **Consulta por Endereço Completo** (Estado/Cidade/Logradouro).
- 🗂️ **Armazenamento** dos resultados em uma tabela de banco de dados.
- 🔄 **Atualização de dados existentes**: se o CEP ou Endereço já estiver cadastrado, o sistema oferece a opção de atualizar as informações.
- 🧭 **Navegação pelos registros** já cadastrados.
- 🌐 **Formato de resposta**: Permite ao usuário escolher o formato de retorno da API (JSON ou XML).

### Requisitos Técnicos:
1. Armazenar os resultados das consultas em um banco de dados de sua escolha.
2. Consultas podem ser feitas tanto por **CEP** quanto por **Endereço Completo**.
3. Caso um **CEP ou Endereço já exista**, perguntar se o usuário deseja atualizar os dados.
4. Interface flexível e amigável, com opção de escolha de formato de retorno entre **JSON** ou **XML**.
5. Código disponível em repositório público no GitHub com boas práticas.

## 💻 Estrutura do Projeto

A estrutura do projeto segue o padrão MVC em Delphi. Abaixo está a organização das pastas dentro do repositório:

~~~~bash
delphi-viacep-mvp/
├── project/        # Arquivos de configuração do projeto Delphi (.dproj)
├── src/            # Código-fonte principal
│   ├── models/     # Modelos de dados (CEP, Endereço, etc.)
│   ├── controllers/ # Controladores (lógica de negócios)
│   ├── views/      # Interfaces de usuário (Forms)
│   ├── database/   # Scripts de banco de dados e conexões
│   ├── components/ # Componentes para consulta ao ViaCEP
│   ├── services/   # Serviços como serialização JSON/XML, consumo da API
│   ├── utils/      # Funções auxiliares e utilitárias
│   └── tests/      # Testes unitários e de integração
~~~~

## 🧑‍💻 Instruções de Uso

1. Clone o repositório:
   ~~~~bash
   git clone https://github.com/gaitolini/Delphi-ViaCEP-MVP.git
   ~~~~
   
2. Abra o projeto no **Embarcadero RAD Studio**.

3. Compile e execute o projeto para testar a aplicação.

4. A tela principal permitirá a consulta de CEP ou Endereço Completo, com os seguintes campos de pesquisa:
   - **CEP**: Pesquisa direta por CEP.
   - **Endereço Completo**: Pesquisa por Estado, Cidade e Logradouro.

5. Escolha entre os formatos de resposta **JSON** ou **XML** via **Radio Buttons**.

## 🧪 Exemplos de Código

### Consulta de CEP

~~~~delphi
procedure TConsultaCEPController.ConsultarCEP(const CEP: string);
var
  ResponseJSON: TJSONObject;
begin
  ResponseJSON := ViaCEPService.ConsultarCEP(CEP);
  // Lógica para tratar o retorno JSON ou XML
end;
~~~~

### Serialização de JSON

~~~~delphi
function TJSONSerializer.SerializeToJSON(const AObject: TObject): string;
begin
  Result := TJson.ObjectToJsonString(AObject);
end;
~~~~

### Conexão ao Banco de Dados

~~~~delphi
procedure TDatabaseConnection.Connect;
begin
  // Exemplo de conexão com banco de dados
  FDConnection.Params.Database := 'Caminho_para_Banco';
  FDConnection.Connected := True;
end;
~~~~

## 📚 Requisitos Adicionais

### Plus:
- ✔️ **Clean Code**: Implementação utilizando boas práticas de código.
- ✔️ **SOLID Principles**: Aplicação dos princípios SOLID para design de software.
- ✔️ **POO**: Programação Orientada a Objetos aplicada.
- ✔️ **Serialização e Desserialização**: Suporte a JSON e XML.
- ✔️ **Interfaces**: Abstração de componentes e serviços.
- ✔️ **Design Patterns**: Aplicação de padrões de design.

## 🛠️ Tecnologias Utilizadas

- **Delphi** (Embarcadero RAD Studio)
- **FireDAC** (Conexão com banco de dados)
- **ViaCEP API** (Consulta de CEP)
- **JSON/XML** (Retorno das consultas)

## 📦 Instalação e Execução

Para rodar a aplicação localmente:

1. Clone o repositório conforme indicado.
2. Instale os componentes de banco de dados e configure o arquivo de conexão.
3. Compile o projeto no **Delphi**.
4. Execute a aplicação diretamente no RAD Studio.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
🛠️ Desenvolvido por [gaitolini](https://github.com/gaitolini)
