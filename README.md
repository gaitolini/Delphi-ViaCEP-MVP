# 🚀 Delphi ViaCEP MVP 💡

Este repositório contém um MVP (Minimum Viable Product) desenvolvido em **Delphi**, que permite realizar consultas de CEP utilizando o web service público do [ViaCEP](https://viacep.com.br/). O sistema possibilita consultas tanto por CEP quanto por endereço completo, além de armazenar e gerenciar os resultados em um banco de dados PostgreSQL.

## 📑 Especificações Técnicas

### Funcionalidades Principais:
- 🔍 **Consulta de CEP** via API pública do ViaCEP.
- 🏙️ **Consulta por Endereço Completo**: Pesquisa por UF, Cidade e Logradouro.
- 🗂️ **Armazenamento de dados**: Salva os resultados em um banco de dados PostgreSQL.
- 🔄 **Atualização de dados existentes**: Se o CEP ou Endereço já estiver cadastrado, o sistema oferece a opção de atualizar as informações.
- 🌐 **Formatos de Resposta**: Escolha entre **JSON** ou **XML** para o retorno da API.
- 📂 **Leitura de Configuração**: Configurações do banco de dados e conexão são lidas de um arquivo `config.ini`.

## 💻 Estrutura do Projeto

A estrutura do projeto segue o padrão **MVC** em Delphi:

~~~~bash
delphi-viacep-mvp/
├── project/        # Arquivos de configuração do projeto Delphi (.dproj)
├── assets/         # Arquivos json estilo lottie e imagens .svg
├── src/            # Código-fonte principal
│   ├── models/     # Modelos de dados (CEP, Endereço, etc.)
│   ├── controllers/ # Controladores (lógica de negócios)
│   ├── views/      # Interfaces de usuário (Forms)
│   ├── database/   # Scripts de banco de dados e conexões
│   ├── components/ # Componentes para consulta ao ViaCEP
│   ├── services/   # Serviços como serialização JSON/XML, consumo da API
│   ├── utils/      # Funções auxiliares e utilitárias
│   └── lib/        # dll do skia
~~~~

## 🧑‍💻 Como Usar a Aplicação

A aplicação apresenta um menu lateral com três opções principais: **Consulta CEP**, **Layout** e **Wallpaper**. Cada uma das telas é acessível pelo menu lateral que pode ser expandido no botão de estilo "hamburger".

### Consulta de CEP

1. **Escolha o formato**: Selecione entre **JSON** ou **XML** para o retorno da consulta.
2. **Digite o CEP ou Endereço Completo**: No campo de texto, digite:
   - **CEP** (exemplo: `88395000`) para uma consulta direta.
   - **Endereço Completo** no formato: `UF, Cidade, Logradouro`. Exemplo: `SC, São João do Itaperiú, Rua José Evilásio`.
   - O campo de pesquisa aceita filtros parciais. Por exemplo: `SC, São João do I, Rua`.
3. **Realize a consulta**: Clique no botão **Consulta CEP**. O sistema verifica o banco de dados e, caso não encontre, faz a consulta no WS da ViaCEP e armazena os dados.

### Capturas de Tela

#### Tela Inicial (Menu Lateral Fechado)
![image](https://github.com/user-attachments/assets/0e5e2dda-8222-444e-8fab-16d7ad27dccb)

#### Tela Inicial (Menu Lateral Aberto)
![image](https://github.com/user-attachments/assets/a66afa5a-b4f6-463a-b62f-ddb9181c56ce)

#### Tela de Consulta de CEP
![image](https://github.com/user-attachments/assets/ae79130c-2c92-4cf9-a23b-15de29265975)

#### Tela de ajuste d layout 
![image](https://github.com/user-attachments/assets/682c2b82-9ff6-4029-99b3-55c2b86d5a4d)
- Esse tela vem como base do meu template que uso com Skia + o panel TAplitview 

#### Funcionalidade adicional
- Se o CEP/Endereço já estiver no banco, o sistema pergunta se o usuário deseja atualizar as informações.

### Banco de Dados e Arquivo de Configuração

As credenciais de conexão com o banco de dados PostgreSQL estão no arquivo `config.ini`, localizado na raiz do projeto. Exemplo:

~~~~ini
[database]
server=localhost
port=5432
database=viacepdb
username=postgres
password=minhasenha
~~~~

### 🛠 Dependência de sk4d.dll
Este projeto utiliza a biblioteca Skia4Delphi para implementar gráficos e animações modernas. Para garantir que o sistema funcione corretamente, é necessário incluir a DLL de suporte do Skia, chamada sk4d.dll, no mesmo diretório do executável.

#### Como Usar a sk4d.dll
- Copiar da pasta src/lib/sk4d.dll
- Baixar a DLL: Certifique-se de baixar a versão correta da sk4d.dll compatível com seu sistema operacional. Ela pode ser encontrada no repositório oficial do Skia4Delphi.
- Colocar a DLL no Diretório do Executável: Após baixar a DLL, coloque o arquivo sk4d.dll na mesma pasta onde está o executável (.exe) do seu projeto Delphi.

~~~~bash
├── anydir/
│   ├── ProjetoViaCEP.exe
│   ├──Config.ini
│   └── sk4d.dll
~~~~

#### Importância da DLL: A sk4d.dll é necessária para que as animações e gráficos renderizados pelo Skia4Delphi funcionem corretamente. Sem ela, a aplicação pode gerar erros em tempo de execução, como o erro "Runtime Error 217".

Certifique-se de Incluir a DLL nas Distribuições: Sempre inclua a sk4d.dll ao distribuir ou mover o executável para outros ambientes, como máquinas de usuários ou servidores, para evitar erros inesperados.


## 🎨 Animações Lottie
O projeto utiliza animações Lottie para melhorar a interface gráfica, proporcionando uma experiência visual moderna e dinâmica. As animações são carregadas a partir de arquivos .json, que podem ser baixados de repositórios de animações, como Lordicon.

![image](https://github.com/user-attachments/assets/e94962b5-f758-42a8-b3d4-ed5fc6830475)

#### Detalhe
![image](https://github.com/user-attachments/assets/02bdde19-da7c-43e1-9b50-2542e7609719)
- Detalhe uso menu de contexto para ajustar o lottie

Como Utilizar Animações Lottie no Projeto
Baixar Arquivos Lottie (.json): Vá até o site [Lordicon](https://lordicon.com/icons/wired/outline) para explorar e baixar animações em formato .json.

~~~~bash
// Exemplo de estrutura de pastas
├── assets/
│   ├── rocket.json    # Animação de foguete
│   └── search.json    # Animação de busca
├── bin/
│   ├── ProjetoViaCEP.exe
│   └── sk4d.dll
~~~~

## Carregar Animações no Delphi: O arquivo .json da animação pode ser carregado no projeto utilizando o componente Skia4Delphi ou outras bibliotecas compatíveis com Lottie.

### Exemplo de código para carregar uma animação:

~~~delphi

var
  LottieAnimation: ISkottieAnimation;
begin
  LottieAnimation := TSkottieAnimation.MakeFromFile('animations/rocket.json');
  // Código para exibir a animação no componente gráfico
end;
~~~~
## Adicionando Animações à Interface: As animações são usadas em diversas telas, como a tela de carregamento e notificações de sucesso ou erro, tornando o sistema mais interativo e agradável.

### Benefícios do Uso de Animações Lottie:

- Leve: As animações Lottie são muito mais leves que GIFs e outros formatos de animação.
- Escalável: Por serem baseadas em vetores, as animações .json são escaláveis e não perdem qualidade ao mudar de tamanho.
- Personalizável: Muitas animações em Lordicon são editáveis, permitindo ajustar cores, velocidade e outros parâmetros antes de baixar.

### Requisitos Técnicos

- **Delphi** (Embarcadero RAD Studio)
- **UniDAC** para conexão ao banco PostgreSQL
- **Skia4Delphi** para modernização da interface gráfica
- **ViaCEP API** para consultas de CEP

## 📄 Banco de Dados

#### Script de Criação (DDL)

~~~~sql
CREATE DATABASE viacepdb
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE TABLE ceps (
  id SERIAL PRIMARY KEY,
  cep VARCHAR NOT NULL,
  logradouro VARCHAR(200),
  complemento VARCHAR(50),
  bairro VARCHAR(200),
  localidade VARCHAR(100),
  uf VARCHAR(2),
  estado VARCHAR(150),
  regiao VARCHAR(150),
  ibge INTEGER,
  gia INTEGER,
  ddd INTEGER,
  siafi INTEGER
);
~~~~

## 🛠️ Tecnologias Utilizadas

- **[Delphi RIO](https://www.embarcadero.com/br/products/rad-studio/whats-new-in-10-3-rio)** (Embarcadero RAD Studio)
- **[PostgreSQL](https://www.postgresql.org/)** (Banco de dados) [instaladores](https://www.enterprisedb.com/download-postgresql-binaries) 
- **[UniDAC](https://www.devart.com/unidac/download.html)** (Biblioteca de acesso a dados)
- **[ViaCEP API](https://viacep.com.br/)** (Consulta de CEP)
- **[Skia4Delphi](https://github.com/skia4delphi/skia4delphi)** (Melhorias visuais e animações)

## 📦 Link para Download do Executável

Aqui você pode disponibilizei o link para download do pacote de executável zipado.

[Download Executável](https://drive.google.com/drive/folders/1XWcfCy4fn6uf-lUSa3wXhj0orBKw9rxx?usp=sharing)

## 📚 Requisitos Adicionais

### Plus:
- ✔️ **Clean Code**: Implementação utilizando boas práticas de código.
- ✔️ **SOLID Principles**: Aplicação dos princípios SOLID para design de software.
- ✔️ **POO**: Programação Orientada a Objetos aplicada.
- ✔️ **Serialização e Desserialização**: Suporte a JSON e XML.
- ✔️ **Interfaces**: Abstração de componentes e serviços.
- ✔️ **Design Patterns**: Aplicação de padrões de design.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
- 🛠️ Desenvolvido por [gaitolini](https://github.com/gaitolini)
- 📲Whatsapp [Me chame para conversar](https://wa.me/qr/CFND4RGOJHHUN1)
