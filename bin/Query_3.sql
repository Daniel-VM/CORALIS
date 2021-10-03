---SQLQuery----
SELECT Ncrnas.name, Source.name, Organism.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Ncrnas.name = 'piR-39980'


---Number of annotated interactions by specie. This create the Supported_species.csv file that availablesp() prints in R---
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


SELECT COUNT(*)
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'lncRNA_mRNA'


---By specie query---
SELECT Ncrnas.id, Ncrnas.name, Genes.id, Genes.name, Mti.ncrna_id, Mti.gene_id
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'miRNA_mRNA' AND Organism.name = 'Homo sapiens' AND Genes.name = 'KLC2' AND Ncrnas.name IN ('hsa-miR-125b-5p', 'hsa-miR-155-3p', 'hsa-miR-16-5p', 'hsa-miR-17-5p')

--- miRNode_db vs RAID_API test---
--API:
http://www.rna-society.org/rnainter/php_mysql/api.php?keyword=Neat1&category=lncRNA&species=Mus musculus&type=1&method=*
--SQLITE:
SELECT Ncrnas.id, Ncrnas.name, Genes.id, Genes.name, Mti.ncrna_id, Mti.gene_id
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Ncrnas.name = 'Neat1' AND Source.name = 'lncRNA_mRNA' AND Organism.name = 'Mus musculus'


--- test 2:
SELECT Ncrnas.name, Genes.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'lncRNA_mRNA' AND Organism.name = 'Homo sapiens'
GROUP BY Ncrnas.name


SELECT COUNT(*)
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
WHERE Source.name = 'miRNA_mRNA' AND Organism.name = 'Homo sapiens'

--- test 2:
SELECT Ncrnas.name, Organism.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Source.name = 'lncRNA_mRNA' AND Organism.name = 'Mus musculus'
GROUP BY Ncrnas.name


---MTI_ENRICHMENTv3 EVALUATION:

SELECT Ncrnas.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE genes.name= 'CSNK2A1' 
AND Source.name = 'miRNA_mRNA' 
AND Organism.name = 'Homo sapiens'


SELECT Ncrnas.name
FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
ON Ncrnas.source_id = Source.id
AND Ncrnas.organism_id = Organism.id
AND Mti.ncrna_id = Ncrnas.id
AND Mti.gene_id = Genes.id
WHERE Ncrnas.name= 'hsa-miR-12135' 
AND Source.name = 'miRNA_mRNA' 
AND Organism.name = 'Homo sapiens'