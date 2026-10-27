<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white">  <img src="https://img.shields.io/badge/Seurat-v5.3.0-1F3B5E?style=for-the-badge">  <img src="https://img.shields.io/badge/CellChat-v1.6.1-F2A541?style=for-the-badge">  <img src="https://img.shields.io/badge/Bioconductor-Slingshot-4FD1A5?style=for-the-badge">

![Project banner](Readme_illustration/banner.png)

<p align="justify">

Welcome to the GitHub repository related to our publication ***Cajal-Retzius cells shape postnatal forebrain germinal activity through BMPR1A signaling*** 
</p>
Timothy Capeliez<sup>1,2</sup>, Guillaume Marcy<sup>3</sup>, Louis Foucault<sup>4,5</sup>, Amele Ahraoui<sup>1,2</sup>, [First name] Gelin<sup>9</sup>, France Pietri-Rouxel<sup>9</sup>, Sestina Falcone<sup>9</sup>, Frédéric Causeret<sup>7,8</sup>, <ins>Olivier Raineteau</ins><sup>1,2</sup>, STEM CELL REPORTS, 2026

</p>

<p>
<sup>1</sup> Univ Lyon, Université Claude Bernard Lyon 1, Inserm, Stem Cell and Brain Research Institute U1208, 69500 Bron, France <br>
<sup>2</sup> BrainGuard Team, Lyon Neurosciences Research Center, INSERM U1028, CNRS UMR5292, Lyon University, 69500 Bron, France <br>
<sup>3</sup> Univ Lyon, Université Claude Bernard Lyon 1, Labex CORTEX, bioinformatics platform, 69000 Lyon, France <br>
<sup>4</sup> VIB-KU Leuven Center for Brain & Disease Research, 3000 Leuven, Belgium <br>
<sup>5</sup> KU Leuven, Department of Neurosciences, Leuven Brain Institute, 3000 Leuven, Belgium <br>
<sup>6</sup> KU Leuven Institute for Single Cell Omics, 3000 Leuven, Belgium <br>
<sup>7</sup> Université Paris Cité, Institute of Psychiatry and Neuroscience of Paris, INSERM U1266, F-75014 Paris, France <br>
<sup>8</sup> Université Paris Cité, Imagine Institute, Team Genetics and Development of the Cerebral Cortex, F-75015 Paris, France <br>
<sup>9</sup> Sorbonne Université, UMRS974, Inserm, Institut de Myologie, Center of Research in Myology, F-75013 Paris, France
</p>

<div align="center">

<h1 align="center"> Cajal-Retzius cells shape postnatal forebrain germinal activity through BMPR1A signaling </h1>

  <p align="center">
    This repository provides the documentation and scripts needed to reproduce the single-cell RNA-sequencing analyses presented in the study.
    <br />
    <a href="[LINK_TO_PAPER]"><strong>Explore the paper »</strong></a>
    <br />
    <br />
    <a href="https://github.com/OlivierRaineteauSBRI/Project_CRsignal/issues">Report Bug</a>
    ·
    <a href="https://github.com/OlivierRaineteauSBRI/Project_CRsignal/issues">Request Feature</a>
  </p>
</div>

## Abstract

<p align="justify">
Neural stem cells (NSCs) persist in the postnatal ventricular-subventricular zone (V-SVZ) but undergo tightly regulated
transitions between quiescence and activation to produce specific neuron subtypes in a spatially and temporally regulated
manner. The mechanisms governing these dynamics, and the potential to reactivate NSCs following birth, remain unclear.
Here, we investigated whether manipulating BMP signalling through BMPR1A influences postnatal NSC behavior. Using targeted
electroporation of dominant-negative or constitutively active <i>Bmpr1a</i> constructs in the early postnatal dorsal and
lateral SVZ, we show that BMPR1A activity is a central determinant of NSC state. Inhibiting BMPR1A signaling reactivates
NSCs entering quiescence, enhancing proliferation and expanding intermediate progenitors, whereas BMPR1A activation
suppresses proliferation and reduces olfactory bulb neurogenesis. Single-cell transcriptomics identify Cajal-Retzius (CR)
cells as a major early postnatal source of BMPR1A ligands, and CR-cell depletion in ΔNp73 mutant mice favors dorsal NSC
proliferation and neurogenesis.
These findings reveal CR-derived BMPs as a transient, non-local regulatory cue that silences dorsal NSCs, redefining how
stem-cell behavior is coordinated within the postnatal forebrain.
</p>

## Highlights

- BMPR1A inhibition reactivates quiescent NSCs within the postnatal dorsal V-SVZ
- BMPR1A gain-of-function inversely promotes NSC quiescence and impairs olfactory bulb neurogenesis
- Cajal-Retzius cells are a source of BMPR1A ligands within the postnatal dorsal V-SVZ
- Cajal-Retzius cell depletion leads to enhanced NSC activation and neurogenic output within the dorsal V-SVZ
- Regional differences in the persistence of NSC radial processes spatially shape BMP signaling in postnatal NSCs


## Files in [scripts](https://github.com/OlivierRaineteauSBRI/Project_CRsignal/tree/main/scripts)

The analysis is split into two steps: the first script builds all the objects, the second one draws the figures from them.

- ``1_script_object.R`` : data processing and integration. Subsets and downsamples the three datasets, builds the unintegrated and SCT-integrated objects, clusters and annotates cells, isolates Cajal-Retzius cells and infers their pseudotime (Slingshot), then runs the CellChat analysis. All objects are saved in ``Data/data_processed/``.
- ``2_figures.Rmd`` : loads the processed objects and reproduces every single-cell panel of the paper.

| Figure in the paper | Content | Section in ``2_figures.Rmd`` |
|---|---|---|
| **Figure 3B** | Contribution of each dataset to the integrated UMAP | Figure 3 · Panel B |
| **Figure 3C** | Integrated UMAP with harmonized annotations | Figure 3 · Panel C |
| **Figure 3D** | Stacked violin plots of cell-type markers | Figure 3 · Panel D |
| **Figure 3E** | CellChat heatmap of BMP signaling | Figure 4 · Panel A |
| **Figure 3F** | Circos plots of the main BMP ligand–receptor pairs | Figure 4 · Panel B |
| **Figure 4A** | KDE score of Cajal-Retzius markers | Figure 3 · Panel E |
| **Figure 4B** | Slingshot pseudotime of Cajal-Retzius cells | Figure 3 · Panel F |
| **Figure 4C** | *Reln*, *Trp73* and *Gdf5* expression along pseudotime | Figure 3 · Panel G |
| **Supp. Figure 2** | Unintegrated UMAP, dataset composition, quality control, clusters | Supplementary · Figure 3 |
| **Supp. Figure 3** | Feature plots of the markers used to define cell types | Supplementary · Figure 4 |
| **Supp. Figure 4** | Cajal-Retzius subset, *Reln* density, BMP pair contributions, pseudotime expression | Supplementary · Figure 5 |


## Prerequisites

**Bioinformatics**
* [R](https://www.r-project.org) (≥ 4.4) and [RStudio](https://posit.co/products/open-source/rstudio/)
* [Seurat](https://satijalab.org/seurat/) (v5.3.0), [SeuratObject](https://github.com/satijalab/seurat-object) and [sctransform](https://github.com/satijalab/sctransform)
* [CellChat](https://github.com/sqjin/CellChat) (v1.6.1)
* [Slingshot](https://bioconductor.org/packages/slingshot/) (v2.14.0)
* [SCpubr](https://github.com/enblacar/SCpubr) and [Nebulosa](https://bioconductor.org/packages/Nebulosa/) (UMAP and kernel density plots)
* [ComplexHeatmap](https://bioconductor.org/packages/ComplexHeatmap/), [pheatmap](https://cran.r-project.org/package=pheatmap) and [circlize](https://cran.r-project.org/package=circlize) (heatmaps and circos plots)
* [tidyverse](https://www.tidyverse.org/), [data.table](https://cran.r-project.org/package=data.table), [patchwork](https://patchwork.data-imaginist.com/), [cowplot](https://cran.r-project.org/package=cowplot), [viridis](https://cran.r-project.org/package=viridis) and [DT](https://rstudio.github.io/DT/)

**Histology and statistics**
* [Fiji / ImageJ](https://imagej.net/software/fiji/) (v1.51, cell quantifications and optical density measurements)
* [GraphPad Prism 8](https://www.graphpad.com/features) (statistical analyses and graphs)
* [Inkscape](https://inkscape.org/) (v1.2.1, figure assembly)

## To get started

1. **Clone** this repository via RStudio (``File`` › ``New Project`` › ``Version Control`` › ``Git``).
2. **Restore the environment** with the ``renv`` package: ``renv::restore()``.
3. **Place the input objects** in ``Data/`` (see *Data availability*): ``Loo_E14.rds``, ``Loo_P0.rds``, ``di_bella_full.rds`` and ``same_umap_P2_P12_P22.rds``.
4. **Run** ``scripts/1_script_object.R`` to generate the processed objects in ``Data/data_processed/``. Integration and CellChat are memory-intensive; we recommend at least [XX] GB of RAM.
5. **Knit** ``scripts/2_figures.Rmd`` to reproduce the figure panels. Uncomment the ``ggsave()`` lines to export each panel as a PDF in ``Results/``.

## Data availability

This study re-analyses three publicly available single-cell RNA-sequencing datasets:

| Dataset | Accession | Content | 
|---|---|---|
| Loo et al. | [GSE123335](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE123335) | E14.5 and P0 pallium and overlying cortex |
| Di Bella et al. | [GSE153164](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE153164) | Prospective somatosensory cortex, E10.5 to P4 |
| Marcy et al. | [GSE186003](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE186003) | Dorsal V-SVZ at P2, P12 and P22 |

All other data supporting the findings of this study are available from the corresponding author upon reasonable request.

## Funding

This research was supported by ANR ProgenID (ANR-18-CE16-0014), ANR NeoRepair (ANR-17-CE16-0009), the Fondation pour la Recherche Médicale (EQU202203014658) and the LABEX CORTEX (ANR-11-LABX-0042) of Université de Lyon, within the program "Investissements d'Avenir" (decision no. 2019-ANR-LABX-02) operated by the French National Research Agency (ANR). This work is part of the "Investissements d'Avenir ExcellencES" program from France 2030 (SHAPE-Med@Lyon; ANR-22-EXES-0012).

## Authors

**Olivier Raineteau** _corresponding author_
- [Profile](https://github.com/OlivierRaineteauSBRI "Olivier Raineteau")
- [Email](mailto:olivier.raineteau@inserm.fr?subject=Hi% "Hi!")

**Timothy Capeliez** _first author_
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

**Guillaume Marcy**
- [Email](mailto:guillaume.marcy@univ-lyon1.fr?subject=Hi% "Hi!")

**Louis Foucault**
- [Profile](https://github.com/LouisFoucault "Louis Foucault")
- [Email](mailto:louis.foucault@kuleuven.be?subject=Hi% "Hi!")

**Amele Ahraoui**
- [Profile](https://github.com/amelahra "Amel Ahraoui")
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

**[First name] Gelin**
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

**France Pietri-Rouxel**
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

**Sestina Falcone**
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

**Frédéric Causeret**
- [Email](mailto:[EMAIL]?subject=Hi% "Hi!")

## How to cite

```bibtex
@article{Capeliez2026CRsignal,
  title   = {Cajal-Retzius cells shape postnatal forebrain germinal activity through BMPR1A signaling},
  author  = {Capeliez, T. and Marcy, G. and Foucault, L. and Ahraoui, A. and Gelin, M. and
             Pietri-Rouxel, F. and Falcone, S. and Causeret, F. and Raineteau, O.},
  journal = {[Journal]},
  year    = {2026},
  doi     = {[DOI]}
}
```

## Questions
For any question or issue, please contact <a href="mailto:olivier.raineteau@inserm.fr">Olivier Raineteau</a> or open an [issue](https://github.com/OlivierRaineteauSBRI/Project_CRsignal/issues).
