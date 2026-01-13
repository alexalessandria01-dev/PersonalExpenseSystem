# PROGETTO FINALE DI PROGRAMMAZIONE
## SISTEMA DI GESTIONE DELLE SPESE PERSONALI E DEL BUDGET

---

**Studente:** Alex Alessandria
**Corso:** Programmazione - Area L8
**Anno Accademico:** 2025/2026

---

## 1. SCRIPT SQL

### Script di Creazione del Database

```sql
-- Creazione del database
DROP DATABASE IF EXISTS gestione_spese;
CREATE DATABASE gestione_spese;
USE gestione_spese;

-- Tabella: categorie
CREATE TABLE categorie (
    id INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,

    -- Vincoli di integrità
    PRIMARY KEY (id),
    UNIQUE (nome),
    CHECK (nome <> '')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabella: spese
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

-- Tabella: budget
CREATE TABLE budget (
    id INT AUTO_INCREMENT,
    mese VARCHAR(7) NOT NULL,
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
```

### Script di Inserimento Dati di Esempio

```sql
-- Inserimento categorie
INSERT INTO categorie (nome) VALUES
    ('Alimentari'),
    ('Trasporti'),
    ('Intrattenimento'),
    ('Salute'),
    ('Abbigliamento');

-- Inserimento spese
INSERT INTO spese (data, importo, categoria_id, descrizione) VALUES
    ('2025-01-05', 45.80, 1, 'Spesa settimanale'),
    ('2025-01-10', 25.00, 1, 'Pranzo ristorante'),
    ('2025-01-15', 82.50, 1, 'Supermercato'),
    ('2025-01-20', 15.30, 1, 'Colazione bar'),
    ('2025-01-25', 98.40, 1, 'Spesa mensile'),
    ('2025-01-03', 35.00, 2, 'Abbonamento autobus'),
    ('2025-01-12', 50.00, 2, 'Benzina'),
    ('2025-01-22', 25.00, 2, 'Taxi'),
    ('2025-01-08', 15.00, 3, 'Cinema'),
    ('2025-01-18', 40.00, 3, 'Cena con amici'),
    ('2025-01-28', 12.99, 3, 'Abbonamento streaming'),
    ('2025-01-14', 28.50, 4, 'Farmacia'),
    ('2025-01-21', 80.00, 4, 'Visita medica'),
    ('2025-02-01', 120.00, 5, 'Scarpe nuove'),
    ('2025-02-03', 55.20, 1, 'Spesa settimanale'),
    ('2025-02-05', 30.00, 2, 'Benzina'),
    ('2025-02-08', 20.00, 3, 'Teatro'),
    ('2025-02-10', 45.00, 1, 'Ristorante');

-- Inserimento budget
INSERT INTO budget (mese, categoria_id, importo_budget) VALUES
    ('2025-01', 1, 300.00),
    ('2025-01', 2, 150.00),
    ('2025-01', 3, 100.00),
    ('2025-01', 4, 150.00),
    ('2025-01', 5, 200.00),
    ('2025-02', 1, 350.00),
    ('2025-02', 2, 120.00),
    ('2025-02', 3, 80.00),
    ('2025-02', 4, 100.00),
    ('2025-02', 5, 150.00);
```

---

## 2. SCHEMA LOGICO DEL DATABASE

### Tabella: CATEGORIE
```
┌─────────────────────┐
│    CATEGORIE        │
├─────────────────────┤
│ PK: id (INT)        │
│     nome (VARCHAR)  │
└─────────────────────┘
```

**Vincoli:**
- PRIMARY KEY (id)
- UNIQUE (nome)
- NOT NULL (nome)
- CHECK (nome <> '')

---

### Tabella: SPESE
```
┌──────────────────────────┐
│       SPESE              │
├──────────────────────────┤
│ PK: id (INT)             │
│     data (DATE)          │
│     importo (DECIMAL)    │
│ FK: categoria_id (INT)   │
│     descrizione (VARCHAR)│
└──────────────────────────┘
```

**Vincoli:**
- PRIMARY KEY (id)
- NOT NULL (data, importo, categoria_id)
- FOREIGN KEY (categoria_id) REFERENCES categorie(id)
  - ON DELETE RESTRICT
  - ON UPDATE CASCADE
- CHECK (importo > 0)

---

### Tabella: BUDGET
```
┌─────────────────────────────┐
│        BUDGET               │
├─────────────────────────────┤
│ PK: id (INT)                │
│     mese (VARCHAR)          │
│ FK: categoria_id (INT)      │
│     importo_budget (DECIMAL)│
└─────────────────────────────┘
```

**Vincoli:**
- PRIMARY KEY (id)
- NOT NULL (mese, categoria_id, importo_budget)
- FOREIGN KEY (categoria_id) REFERENCES categorie(id)
  - ON DELETE RESTRICT
  - ON UPDATE CASCADE
- UNIQUE (mese, categoria_id)
- CHECK (importo_budget > 0)
- CHECK (mese REGEXP '^[0-9]{4}-[0-9]{2}$')

---

### Relazioni tra Tabelle

```
    CATEGORIE (1)
         │
         │ 1:N
         ├──────────> SPESE (N)
         │
         │ 1:N
         └──────────> BUDGET (N)
```

**Cardinalità:**
- Una CATEGORIA può avere zero o molte SPESE (1:N)
- Una CATEGORIA può avere zero o molti BUDGET (1:N)
- Una SPESA appartiene a una sola CATEGORIA
- Un BUDGET appartiene a una sola CATEGORIA

---

## 3. DIMOSTRAZIONE VINCOLI DI INTEGRITÀ

### PRIMARY KEY

Ogni tabella ha una chiave primaria:

```sql
-- Tabella categorie
PRIMARY KEY (id)

-- Tabella spese
PRIMARY KEY (id)

-- Tabella budget
PRIMARY KEY (id)
```

**Funzione:** Identifica univocamente ogni record.

---

### FOREIGN KEY

Le tabelle spese e budget referenziano categorie:

```sql
-- In tabella spese
FOREIGN KEY (categoria_id) REFERENCES categorie(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE

-- In tabella budget
FOREIGN KEY (categoria_id) REFERENCES categorie(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
```

**Funzione:**
- Garantisce integrità referenziale
- ON DELETE RESTRICT: impedisce eliminazione categoria con spese/budget associati
- ON UPDATE CASCADE: aggiorna automaticamente categoria_id se cambia l'id della categoria

---

### CHECK

Vincoli di validazione dei dati:

```sql
-- Tabella categorie
CHECK (nome <> '')

-- Tabella spese
CHECK (importo > 0)

-- Tabella budget
CHECK (importo_budget > 0)
CHECK (mese REGEXP '^[0-9]{4}-[0-9]{2}$')
```

**Funzione:**
- Nome categoria non vuoto
- Importi sempre positivi
- Formato mese corretto (YYYY-MM)

---

### UNIQUE

Vincoli di unicità:

```sql
-- Tabella categorie
UNIQUE (nome)

-- Tabella budget
UNIQUE (mese, categoria_id)
```

**Funzione:**
- Non si possono avere due categorie con lo stesso nome
- Non si possono avere due budget per la stessa categoria nello stesso mese

---

### NOT NULL

Campi obbligatori:

```sql
-- Tabella categorie
nome VARCHAR(100) NOT NULL

-- Tabella spese
data DATE NOT NULL
importo DECIMAL(10, 2) NOT NULL
categoria_id INT NOT NULL

-- Tabella budget
mese VARCHAR(7) NOT NULL
categoria_id INT NOT NULL
importo_budget DECIMAL(10, 2) NOT NULL
```

**Funzione:** Garantisce che i campi critici abbiano sempre un valore.

---

## 4. LINK REPOSITORY GITHUB

**Repository GitHub del progetto:**

https://github.com/alexalessandria01-dev/PersonalExpenseSystem

---

**Data:** 11 Gennaio 2026
