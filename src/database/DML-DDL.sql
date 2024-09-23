SELECT 1 
FROM pg_database 
WHERE datname = 'viacepdb';

CREATE DATABASE viacepdb
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
    
   
CREATE TABLE ceps (
  id INTEGER PRIMARY KEY,
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
   