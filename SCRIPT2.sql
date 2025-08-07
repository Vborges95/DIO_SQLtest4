-- Criação das tabelas com base no diagrama de oficina mecânica

DROP DATABASE Oficina;
CREATE DATABASE Oficina;
USE Oficina;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Celular VARCHAR(45),
    Endereco VARCHAR(45)
);

-- Tabela Veículo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Modelo VARCHAR(45),
    Placa VARCHAR(45),
    Marca VARCHAR(45),
    Ano INT,
    Cliente_idCliente INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela OrdemDeServico
CREATE TABLE OrdemDeServico (
    idOrdemDeServico INT AUTO_INCREMENT PRIMARY KEY,
    DataEmissao DATE,
    DataConclusao DATE,
    Status VARCHAR(45),
    ValorTotal DECIMAL(10,2),
    Veiculo_idVeiculo INT,
    Veiculo_Cliente_idCliente INT,
    Equipe_idEquipe INT,
	FOREIGN KEY (Equipe_idEquipe) REFERENCES Equipe(idEquipe),
    FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo(idVeiculo),
    FOREIGN KEY (Veiculo_Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Equipe
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    NomeEquipe VARCHAR(45),
    OrdemDeServico_idOrdemDeServico INT,
    FOREIGN KEY (OrdemDeServico_idOrdemDeServico) REFERENCES OrdemDeServico(idOrdemDeServico)
);

-- Tabela Mecanicos
CREATE TABLE Mecanicos (
    idMecanicos INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Endereco VARCHAR(45),
    Especialidade VARCHAR(45),
    Equipe_idEquipe INT,
    FOREIGN KEY (Equipe_idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela Peças
CREATE TABLE Pecas (
    idPecas INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45),
    Valor DECIMAL(10,2),
    OrdemDeServico_idOrdemDeServico INT,
    FOREIGN KEY (OrdemDeServico_idOrdemDeServico) REFERENCES OrdemDeServico(idOrdemDeServico)
);

-- Tabela Serviços
CREATE TABLE Servicos (
    idServicos INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45),
    Valor DECIMAL(10,2),
    OrdemDeServico_idOrdemDeServico INT,
    FOREIGN KEY (OrdemDeServico_idOrdemDeServico) REFERENCES OrdemDeServico(idOrdemDeServico)
);

-- DADOS FICTICIOS GERADOS PELO PEDIDO FEITO AO CHATGPT

-- CLIENTE
INSERT INTO Cliente (idCliente, Nome, Celular, Endereco) VALUES
(1, 'João da Silva', '21999999999', 'Rua A, 123'),
(2, 'Maria Oliveira', '21988888888', 'Av. Central, 456'),
(3, 'Carlos Souza', '21977777777', 'Travessa B, 789');

-- VEÍCULO
INSERT INTO Veiculo (idVeiculo, Modelo, Placa, Marca, Ano, Cliente_idCliente) VALUES
(1, 'Civic', 'ABC1234', 'Honda', 2018, 1),
(2, 'Corolla', 'XYZ5678', 'Toyota', 2020, 2),
(3, 'Gol', 'JKL9101', 'Volkswagen', 2015, 3);

-- EQUIPE
INSERT INTO Equipe (idEquipe, NomeEquipe) VALUES
(1, 'Equipe Alfa'),
(2, 'Equipe Beta'),
(3, 'Equipe Gama');

-- MECÂNICOS
INSERT INTO Mecanicos (idMecanicos, Nome, Endereco, Especialidade, Equipe_idEquipe) VALUES
(1, 'Pedro Lima', 'Rua Mecânico 1', 'Freios', 1),
(2, 'Ana Souza', 'Rua Mecânico 2', 'Suspensão', 2),
(3, 'Carlos Mendes', 'Rua Mecânico 3', 'Motor', 3);

-- ORDEM DE SERVIÇO
INSERT INTO OrdemDeServico (idOrdemDeServico, DataEmissao, DataConclusao, Status, ValorTotal, Veiculo_idVeiculo, Veiculo_Cliente_idCliente, Equipe_idEquipe) VALUES
(1, '2025-08-01', '2025-08-03', 'Finalizado', '1500.00', 1, 1, 1),
(2, '2025-08-02', NULL, 'Em andamento', '900.00', 2, 2, 2),
(3, '2025-08-03', NULL, 'Aberto', '0.00', 3, 3, 3);

-- PEÇAS
INSERT INTO Pecas (idPecas, Descricao, Valor, OrdemDeServico_idOrdemDeServico) VALUES
(1, 'Pastilha de freio', 300.00, 1),
(2, 'Amortecedor', 400.00, 2),
(3, 'Correia dentada', 250.00, 1);

-- SERVIÇOS
INSERT INTO Servicos (idServicos, Descricao, Valor, OrdemDeServico_idOrdemDeServico) VALUES
(1, 'Troca de óleo', 150.00, 1),
(2, 'Alinhamento e balanceamento', 200.00, 2),
(3, 'Revisão completa', 500.00, 3);


-- 1. SELECTs Simples
SELECT * FROM Cliente;
SELECT Nome, Celular FROM Cliente;

SELECT * FROM Veiculo;
SELECT Modelo, Placa FROM Veiculo;

SELECT * FROM Mecanicos;
SELECT Nome, Especialidade FROM Mecanicos;

-- 2. WHERE – Filtros
SELECT * FROM OrdemDeServico WHERE Status = 'Finalizado';
SELECT * FROM Veiculo WHERE Ano >= 2018;
SELECT * FROM Cliente WHERE Nome LIKE 'Maria%';

-- 3. Expressões – Atributos Derivados
SELECT 
    idOrdemDeServico,
    ValorTotal,
    CAST(ValorTotal AS DECIMAL(10,2)) * 0.9 AS ValorComDesconto
FROM OrdemDeServico;

-- 4. ORDER BY – Ordenações
SELECT * FROM OrdemDeServico ORDER BY DataEmissao DESC;
SELECT * FROM Mecanicos ORDER BY Nome ASC;

-- 5. GROUP BY + HAVING
SELECT Cliente_idCliente, COUNT(*) AS QtdeVeiculos
FROM Veiculo
GROUP BY Cliente_idCliente
HAVING COUNT(*) > 1;

SELECT Status, COUNT(*) AS Total
FROM OrdemDeServico
GROUP BY Status
HAVING COUNT(*) >= 1;

-- 6. JOINs – Junções entre tabelas
SELECT c.Nome AS Cliente, v.Modelo, v.Placa
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.Cliente_idCliente;

SELECT o.idOrdemDeServico, c.Nome AS Cliente, o.Status
FROM OrdemDeServico o
JOIN Cliente c ON o.Veiculo_Cliente_idCliente = c.idCliente;

SELECT m.Nome AS Mecanico, e.NomeEquipe
FROM Mecanicos m
JOIN Equipe e ON m.Equipe_idEquipe = e.idEquipe;



