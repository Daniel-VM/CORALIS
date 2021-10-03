--SUPPORTED SPECIES:Number of annotated interactions by specie. This create the Supported_species.csv file that availablesp() prints in R---
SELECT Organism.name AS Species, COUNT (CASE WHEN Source.name = 'miRNA_mRNA' THEN Source.name END) AS miRNA,
                                     COUNT (CASE WHEN Source.name = 'lncRNA_mRNA' THEN Source.name END) AS lncRNA,
                                     COUNT (CASE WHEN Source.name = 'snoRNA_mRNA' THEN Source.name END) AS snoRNA,
                                     COUNT (CASE WHEN Source.name = 'snRNA_mRNA' THEN Source.name END) AS snRNA
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
GROUP BY Organism.name
ORDER BY miRNA DESC
--- OVERALL ncRNA target interactions
SELECT 'TOTAL',  SUM(miRNA_target), SUM(lncRNA_target),  SUM(snoRNA_target), SUM(snRNA_target)
FROM (
    SELECT Organism.name AS Species, COUNT (CASE WHEN Source.name = 'miRNA_mRNA' THEN Source.name END) AS miRNA_target,
                                     COUNT (CASE WHEN Source.name = 'lncRNA_mRNA' THEN Source.name END) AS lncRNA_target,
                                     COUNT (CASE WHEN Source.name = 'snoRNA_mRNA' THEN Source.name END) AS snoRNA_target,
                                     COUNT (CASE WHEN Source.name = 'snRNA_mRNA' THEN Source.name END) AS snRNA_target
    FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
    ON Ncrnas.source_id = Source.id
    AND Ncrnas.organism_id = Organism.id
    AND Mti.ncrna_id = Ncrnas.id
    AND Mti.gene_id = Genes.id
    GROUP BY Organism.name
    ORDER BY miRNA_target DESC
)

---SUPPORTED NCRNAS:
SELECT Source.name AS ncRNAs, COUNT(Source.id) AS Num_interactions
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
GROUP BY Source.name

---By specie query---
SELECT Ncrnas.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'snRNA_mRNA'


---By specie query x2---
SELECT DISTINCT Ncrnas.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'snoRNA_mRNA' AND Organism.name = 'Mus musculus'



SELECT Ncrnas.name, Genes.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'snoRNA_mRNA' AND Organism.name = 'Mus musculus'
