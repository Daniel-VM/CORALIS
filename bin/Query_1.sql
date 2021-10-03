-- SQLite
SELECT Genes.name, Mirnas.name, Genes.id, Mirnas.id
FROM Genes JOIN Mirnas JOIN Mti 
ON MTI.gene_id = Genes.id AND MTI.mirna_id = Mirnas.id
WHERE Mirnas.name = 'hsa-miR-125b-5p'

SELECT COUNT(*) FROM Mirnas
