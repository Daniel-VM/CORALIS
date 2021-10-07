import sqlite3

#DB connect/create
conn = sqlite3.connect('../inst/extdata/CORALIS_db.sqlite') # Change the db name once we implement the other source files
cur = conn.cursor()

#DB Design
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

#Load DB source file
fname = input('Enter file name: ')
if len(fname) < 1:
    fname="../data/db_files/mirtarbase_raid.csv"

with open(fname, 'r') as f_data:
    str_data = f_data.readlines()

#Database population
cc = 0 
for row in str_data:
    # Avoid table's headers (first row in the input file)
    if cc == 0:
        cc+=1
        continue
        
    #Set gene, ncrnas and organism items
    row=row.split(",")
    ncrna=row[0]
    gene=row[1]
    organism=row[2]
    #typ=row[3]
    source=row[3]
    #source=' '.join(row[5:]).rstrip("\n")
    print(gene)
    print(organism)

    #SOURCE
    cur.execute('''
    INSERT OR IGNORE INTO Source (name) VALUES (?)
    ''', (source,))
    cur.execute('''
    SELECT id FROM Source WHERE name = (?)
    ''', (source,)
    )
    source_id=cur.fetchone()[0]

    #ORGANISM
    cur.execute('''
    INSERT OR IGNORE INTO Organism (name) VALUES (?)
    ''', (organism,)
    )
    cur.execute('''
    SELECT id FROM Organism WHERE name = (?)
    ''', (organism,)
    )
    organism_id=cur.fetchone()[0]

    #ncRNA
    cur.execute('''
    INSERT OR IGNORE INTO Ncrnas (name, organism_id, source_id) VALUES (?,?,?)
    ''', (ncrna, organism_id, source_id,)
    )
    cur.execute('''
    SELECT id FROM Ncrnas WHERE name = ?
    ''', (ncrna, )
    )
    ncrna_id=cur.fetchone()[0]

    #GENE
    cur.execute('''
    INSERT OR IGNORE INTO Genes (name) VALUES (?)
    ''', (gene,)
    )
    cur.execute('''
    SELECT id FROM Genes WHERE name = ?
    ''', (gene,)
    )
    gene_id=cur.fetchone()[0]

    #MTI
    cur.execute('''
    INSERT OR IGNORE INTO Mti (ncrna_id, gene_id) VALUES (?,?)
    ''', (ncrna_id, gene_id,)
    )
 
# The lines below were used in earlier versions of CORALIS to remove duplicated interactions directly from the sqlite database.
# Now, these lines have been replaced by the dplyr::distinct() function in the db_preprocess.R to remove duplicated interactions found by different methods.

#cur.executescript('''
#CREATE TABLE temp(
#    ncrna_id    INTEGER,
#    gene_id     INTEGER);
#INSERT INTO temp SELECT DISTINCT * FROM Mti;
#DROP TABLE Mti;
#ALTER TABLE temp RENAME TO Mti
#''')
    

#DONE
print("DONE ;)")
conn.commit()
conn.close()
