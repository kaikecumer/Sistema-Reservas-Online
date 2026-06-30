-- =====================================================
-- SISTEMA DE RESERVAS ONLINE
-- Script de Criação do Banco de Dados
-- Compatível com MySQL 8.0
-- =====================================================

CREATE DATABASE IF NOT EXISTS sistema_reservas_online
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sistema_reservas_online;

-- =====================================================
-- TABELA USUARIO
-- =====================================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    senha VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================================
-- TABELA HOTEL
-- =====================================================

CREATE TABLE hotel (
    id_hotel INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    logradouro VARCHAR(150),
    numero VARCHAR(10),
    bairro VARCHAR(80),
    cidade VARCHAR(80),
    estado CHAR(2),
    cep VARCHAR(9)
) ENGINE=InnoDB;

-- =====================================================
-- TABELA CATEGORIA_QUARTO
-- =====================================================

CREATE TABLE categoria_quarto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(60) NOT NULL,
    quantidade_pessoas INT NOT NULL
) ENGINE=InnoDB;

-- =====================================================
-- TABELA QUARTO
-- =====================================================

CREATE TABLE quarto (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL,
    andar INT,
    descricao VARCHAR(150),
    valor_diaria DECIMAL(10,2) NOT NULL,
    status ENUM('DISPONIVEL','OCUPADO','MANUTENCAO') DEFAULT 'DISPONIVEL',

    id_categoria INT NOT NULL,
    id_hotel INT NOT NULL,

    CONSTRAINT fk_quarto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria_quarto(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_quarto_hotel
        FOREIGN KEY (id_hotel)
        REFERENCES hotel(id_hotel)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =====================================================
-- TABELA RESERVA
-- =====================================================

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,

    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    data_reserva DATETIME DEFAULT CURRENT_TIMESTAMP,

    valor_total DECIMAL(10,2) NOT NULL,

    status ENUM('PENDENTE','CONFIRMADA','CANCELADA','FINALIZADA')
           DEFAULT 'PENDENTE',

    id_usuario INT NOT NULL,
    id_quarto INT NOT NULL,

    CONSTRAINT fk_reserva_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reserva_quarto
        FOREIGN KEY (id_quarto)
        REFERENCES quarto(id_quarto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =====================================================
-- TABELA PAGAMENTO
-- =====================================================

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,

    forma_pagamento ENUM(
        'PIX',
        'CARTAO_CREDITO',
        'CARTAO_DEBITO',
        'BOLETO'
    ) NOT NULL,

    valor DECIMAL(10,2) NOT NULL,

    status ENUM(
        'PENDENTE',
        'PAGO',
        'CANCELADO'
    ) DEFAULT 'PENDENTE',

    data_pagamento DATETIME,

    id_reserva INT NOT NULL UNIQUE,

    CONSTRAINT fk_pagamento_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reserva(id_reserva)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =====================================================
-- TABELA AVALIACAO
-- =====================================================

CREATE TABLE avaliacao (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,

    nota TINYINT NOT NULL,

    comentario TEXT,

    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,

    id_reserva INT NOT NULL UNIQUE,

    CONSTRAINT chk_nota
        CHECK (nota BETWEEN 1 AND 5),

    CONSTRAINT fk_avaliacao_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reserva(id_reserva)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;
