# ARTICLE

> [X] Introduction
> [X] Materials and methods 
> [x] Results/Discussion/Conclussion

# R_package
## RNAME PACKAGE
> [ ] miRNode to CORALIS. Source [https://www.njtierney.com/post/2017/10/27/change-pkg-name/]

## DEVELOPMENT
> [] OPTIMIZAR PRERPOCESADO CON NEXTFLOW DESDE VSCODE!!!!!!!!!
	- 1. Cambiar los archivos source a una carpeta externa de miRNODE (bin/ to ../../)
	- 2. Modificar las rutas de los scrpits py y R
	- 3. ubicar el output (bbdd y csvspecies) en la carpeta del paquete data/
	- 4. Crear script para la automatización con nextflow


> VISUALIZATION
  - [X]network
  - [X]num int genes
  - [ ]heatmap

> FUNCTIONS
  - [ ] Risk ratio == SE.RiskRatio?

### Contast health Checks

> [] Here is a typical sequence of calls when using devtools for package development:
  - Edit one or more files below R/.
  - document() (if you’ve made any changes that impact help files or NAMESPACE)
  - load_all()
  - Run some examples interactively.
  - test() (or test_file())
  - check()

#### SPECIFIC  CHECKS
> [ ] the min argument stuff (filter or parameter)
> [X] testing several ncRNAs and species 
> [X] INFO CODE
> [X] argument parsing
> [X] min argument

### TESTS
> RUN PACKAGE TESTS
	- source:[https://r-pkgs.org/tests.html]


## DOCUMENTATION
> [ ] ADD README.MD FILE
> [X] VIGNETTES
> [X] FUNCTIONS HELP PAGE
> DESCRIPTION FILE:
> [X] REVISIOn amanda
> [ ] bugs
> [ ] bug reports
> [ ] SOFTWARE LICENSE <OTRI><------- SO FAR GLP(>=3)
> [x] Correo electronico del desarrollador (NOTA: MI CORREO TIENE CADUCIDAD... PONER EL CORREO DE LA UNIDAD)
> [ ] citation

### CITATION PROCESS
> Citation: 
	- 1: Bioconductor aceptance
	- 2: Paper aceptance
	- 3: modify citation file with the article's detail. YOU MUST RUN ----> usethis::citation()
	     It creates a directory with the new citation sections. 

### VERSIONING
> Check how to modify versions
		- https://r-pkgs.org/release.html
		- Ask bioconductor for guidance. Shall we start in 0.1.0 (default) or 1.0.0.

## SUBMISSION PROCESS:
> automated checking: https://r-pkgs.org/r-cmd-check.html
> submission: https://r-pkgs.org/release.html 
