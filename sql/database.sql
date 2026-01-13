-- =====================================================
-- SISTEMA DI GESTIONE DELLE SPESE PERSONALI E DEL BUDGET
-- Database MySQL - Script Completo
-- =====================================================

-- Creazione del database
DROP DATABASE IF EXISTS gestione_spese;
CREATE DATABASE gestione_spese;
USE gestione_spese;

-- =====================================================
-- TABELLA: categorie
-- Memorizza le categorie di spesa definite dall'utente
-- =====================================================
CREATE TABLE categorie (
    id INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,

    -- Vincoli di integrità
    PRIMARY KEY (id),
    UNIQUE (nome),
    CHECK (nome <> '')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELLA: spese
-- Registra tutte le spese giornaliere dell'utente
-- =====================================================
CREATE TABLE spese (
    id INT AUTO_INCREMENT,
    data DATE NOT NULL,
    importo DECIMAL(10, 2) NOT NULL,
    categoria_id INT NOT NULL,
    descrizione VARCHAR(255),

    -- Vincoli di integrità
    PRIMARY KEY (id),
    FOREIGN KEY (categoria_id) REFERENCES categorie(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (importo > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELLA: budget
-- Definisce i limiti di spesa mensili per categoria
-- =====================================================
CREATE TABLE budget (
    id INT AUTO_INCREMENT,
    mese VARCHAR(7) NOT NULL,  -- Formato: YYYY-MM
    categoria_id INT NOT NULL,
    importo_budget DECIMAL(10, 2) NOT NULL,

    -- Vincoli di integrità
    PRIMARY KEY (id),
    FOREIGN KEY (categoria_id) REFERENCES categorie(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    UNIQUE (mese, categoria_id),
    CHECK (importo_budget > 0),
    CHECK (mese REGEXP '^[0-9]{4}-[0-9]{2}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- INSERIMENTO DATI DI ESEMPIO
-- =====================================================

-- Inserimento categorie
INSERT INTO categorie (nome) VALUES
    ('Alimentari'),
    ('Trasporti'),
    ('Intrattenimento'),
    ('Salute'),
    ('Abbigliamento');

-- Inserimento spese
INSERT INTO spese (data, importo, categoria_id, descrizione) VALUES
    -- Gennaio 2025 - Alimentari
    ('2025-01-05', 45.80, 1, 'Spesa settimanale'),
    ('2025-01-10', 25.00, 1, 'Pranzo ristorante'),
    ('2025-01-15', 82.50, 1, 'Supermercato'),
    ('2025-01-20', 15.30, 1, 'Colazione bar'),
    ('2025-01-25', 98.40, 1, 'Spesa mensile'),

    -- Gennaio 2025 - Trasporti
    ('2025-01-03', 35.00, 2, 'Abbonamento autobus'),
    ('2025-01-12', 50.00, 2, 'Benzina'),
    ('2025-01-22', 25.00, 2, 'Taxi'),

    -- Gennaio 2025 - Intrattenimento
    ('2025-01-08', 15.00, 3, 'Cinema'),
    ('2025-01-18', 40.00, 3, 'Cena con amici'),
    ('2025-01-28', 12.99, 3, 'Abbonamento streaming'),

    -- Gennaio 2025 - Salute
    ('2025-01-14', 28.50, 4, 'Farmacia'),
    ('2025-01-21', 80.00, 4, 'Visita medica'),

    -- Febbraio 2025 - Varie categorie
    ('2025-02-01', 120.00, 5, 'Scarpe nuove'),
    ('2025-02-03', 55.20, 1, 'Spesa settimanale'),
    ('2025-02-05', 30.00, 2, 'Benzina'),
    ('2025-02-08', 20.00, 3, 'Teatro'),
    ('2025-02-10', 45.00, 1, 'Ristorante');

-- Inserimento budget mensili
INSERT INTO budget (mese, categoria_id, importo_budget) VALUES
    -- Budget Gennaio 2025
    ('2025-01', 1, 300.00),  -- Alimentari: budget 300
    ('2025-01', 2, 150.00),  -- Trasporti: budget 150
    ('2025-01', 3, 100.00),  -- Intrattenimento: budget 100
    ('2025-01', 4, 150.00),  -- Salute: budget 150
    ('2025-01', 5, 200.00),  -- Abbigliamento: budget 200

    -- Budget Febbraio 2025
    ('2025-02', 1, 350.00),  -- Alimentari: budget aumentato
    ('2025-02', 2, 120.00),  -- Trasporti: budget ridotto
    ('2025-02', 3, 80.00),   -- Intrattenimento: budget ridotto
    ('2025-02', 4, 100.00),  -- Salute: budget ridotto
    ('2025-02', 5, 150.00);  -- Abbigliamento: budget ridotto

-- =====================================================
-- QUERY DI VERIFICA
-- =====================================================

-- Verifica categorie inserite
SELECT * FROM categorie;

-- Verifica spese inserite
SELECT s.id, s.data, c.nome AS categoria, s.importo, s.descrizione
FROM spese s
JOIN categorie c ON s.categoria_id = c.id
ORDER BY s.data DESC;

-- Verifica budget inseriti
SELECT b.mese, c.nome AS categoria, b.importo_budget
FROM budget b
JOIN categorie c ON b.categoria_id = c.id
ORDER BY b.mese, c.nome;

-- =====================================================
-- FINE SCRIPT
-- =====================================================
