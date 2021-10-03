---SQLQuery----
SELECT Mirnas.name, Mirnas.id, Genes.name, Genes.id
FROM Organism JOIN Genes JOIN Mirnas JOIN Mti
ON Mirnas.organism_id = Organism.id AND Mti.gene_id = Genes.id AND Mti.mirna_id = Mirnas.id
WHERE Mirnas.name = 'hsa-miR-20a-5p' AND Organism.name = 'Homo sapiens' AND Genes.name = 'CCND1'

---TEST WHETHER ROWS IN THE Mti TABLE ARE DUPLICATED OR NO-----
SELECT Mirnas.id, Genes.id
FROM Organism JOIN Genes JOIN Mirnas JOIN Mti
ON Mirnas.organism_id = Organism.id AND Mti.gene_id = Genes.id AND Mti.mirna_id = Mirnas.id
WHERE Mirnas.name = 'hsa-miR-20a-5p' AND Organism.name = 'Homo sapiens' AND Genes.name = 'CCND1'

---HUMAN MIRNAS LISTED IN MIRTARBASE------
SELECT COUNT(*) FROM Mirnas JOIN Organism 
ON Mirnas.organism_id = Organism.id
WHERE Organism.name = 'Homo sapiens'

---Check whether human miRNAs involved in MTI still == 2599 [done]---
SELECT Mirnas.name, Organism.id
FROM Mirnas JOIN Organism
ON Mirnas.organism_id = Organism.id
WHERE Organism.name ='Homo sapiens'


---Number of annotated interactions by specie---
SELECT Organism.name, COUNT(*) 
FROM Organism JOIN Genes JOIN Mirnas JOIN Mti
ON Mirnas.organism_id = Organism.id AND Mti.gene_id = Genes.id AND Mti.mirna_id = Mirnas.id
GROUP BY Organism.name



