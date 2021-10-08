##
##     DB_building.py
##
##   
##   The DB_building.py script imports sqlite3 to build a noncodingRNA-target interaction database following a relational design.
##   This will improve the performancy of CORALIS by searching interactions throught SQL queries. 
##
import sqlite3

## DB connection/creating
conn = sqlite3.connect('../inst/extdata/CORALIS_db.sqlite')
cur = conn.cursor()

## Set up design
cur.executescript('''
DROP TABLE IF EXISTS Genes;
DROP TABLE IF EXISTS Ncrnas;
DROP TABLE IF EXISTS Organism;
DROP TABLE IF EXISTS Source;
DROP TABLE IF EXISTS Mti;

CREATE TABLE Ncrnas(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name TEXT UNIQUE,
    organism_id INTEGER,
    source_id INTEGER
);
CREATE TABLE Genes(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name TEXT UNIQUE
);
CREATE TABLE Organism(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name TEXT UNIQUE
);
CREATE TABLE Source(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name TEXT UNIQUE
);
CREATE TABLE Mti(
    ncrna_id INTEGER,
    gene_id INTEGER
)
''')

## LOAD SOURCE FILE/S
fname = input('Enter file name: ')
if len(fname) < 1:
    fname="../data/basic_data/db_files/mirtarbase_raid.csv"

with open(fname, 'r') as f_data:
    str_data = f_data.readlines()

## POPULATE DB
print("Building DataBase...")
cc = 0 
for row in str_data:
    # Avoid table's headers
    if cc == 0:
        cc+=1
        continue
        
    # Set gene, ncrnas and organism items
    row=row.split(",")
    ncrna=row[0]
    gene=row[1]
    organism=row[2]
    source=row[3]
    
    # SOURCE
    cur.execute('''
    INSERT OR IGNORE INTO Source (name) VALUES (?)
    ''', (source,))
    cur.execute('''
    SELECT id FROM Source WHERE name = (?)
    ''', (source,)
    )
    source_id=cur.fetchone()[0]

    # ORGANISM
    cur.execute('''
    INSERT OR IGNORE INTO Organism (name) VALUES (?)
    ''', (organism,)
    )
    cur.execute('''
    SELECT id FROM Organism WHERE name = (?)
    ''', (organism,)
    )
    organism_id=cur.fetchone()[0]

    # ncRNA
    cur.execute('''
    INSERT OR IGNORE INTO Ncrnas (name, organism_id, source_id) VALUES (?,?,?)
    ''', (ncrna, organism_id, source_id,)
    )
    cur.execute('''
    SELECT id FROM Ncrnas WHERE name = ?
    ''', (ncrna, )
    )
    ncrna_id=cur.fetchone()[0]

    # GENE
    cur.execute('''
    INSERT OR IGNORE INTO Genes (name) VALUES (?)
    ''', (gene,)
    )
    cur.execute('''
    SELECT id FROM Genes WHERE name = ?
    ''', (gene,)
    )
    gene_id=cur.fetchone()[0]

    # MTI
    cur.execute('''
    INSERT OR IGNORE INTO Mti (ncrna_id, gene_id) VALUES (?,?)
    ''', (ncrna_id, gene_id,)
    )

## DONE
print("CORALIS's database has been created. \nBye\n")
conn.commit()
conn.close()
