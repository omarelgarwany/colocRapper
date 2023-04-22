# colocRapper

ColocRapper is an R package for fast and flexible extraction of summary statistics and colocalisation analysis. This package has been used to perform colocalisation between millions of traits (developed originally to perform colocalisation between GWAS loci and molecular QTLs) as part of the MacroMap sQTL project. 

It only requires tabix-ed summary statistics files. It allows flexible file formats, column naming and doesn't have any storage requirements. It stores only the required summary statistics for the region being tested in memory. 

Three files are required: a config file, and a yaml file, and a sample size file (see below)

## Installation

```
devtools::install_github('omarelgarwany/colocRapper')
```

## Input

### Config file (regions to be tested): 
  Each line consists of 5 columns:
  1. Region (e.g. chr1:1234-1422)
  2. Name of phenotype 1 (e.g. PTPN2)
  3. File containing phenotype 1 summary statistics (e.g. /path/to/eQTLs/chr18.gz)
  4. Name of phenotype 2 (e.g. height)
  5. File that contains phenotype 2 summary statistics (e.g. /path/to/GWAS/height.gz)

*Example*:
| chr1:123-456 | ENSG0001 | /path/to/eQTLs/chr1.gz | height | /path/to/GWAS/height.gz |

### YAML file (summary stat files info):
  Has information about the files:
  1. tr_id_cols: columns containing names of phenotypes (could be just a placeholder if it's a cc phenotype)
  2. tr_val_cols: column names for: variant chromosome, variant position, effect size, standard error, p-value [, MAF if it's a quant trait]
  3. Types of traits (i.e. cc or quant)

### Sample size file:
  Tab-separated file containing file name and sample size
