--- checking ncRNAs population by specie ----

SELECT DISTINCT Ncrnas.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name == 'miRNA_mRNA' and Organism.name == 'Sus scrofa'




SELECT Ncrnas.name, Ncrnas.id FROM Ncrnas
