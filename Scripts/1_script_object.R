####### Data Processing and integration of datasets 

# libraries 
setwd("~/Script_article_amele")
set.seed(42)
library(Seurat)
library(SeuratObject)
library(SeuratDisk)
library(SCpubr)
library(slingshot)
library(CellChat)
library(Nebulosa)
library(data.table)
library(dplyr)
library(stringr)
library(tibble)
library(purrr)
library(ggplot2)
library(pheatmap)
set.seed(42)
options(Seurat.object.assay.version = "v5")

###################################################
# --------------  DIBELLA DATASET -----------------
###################################################
# load and pre-process the data 
di_bella_full <- readRDS("Data/di_bella_full.rds")
Idents(di_bella_full) <- "New_cellType"


# Subset by filtering excluded idents and downsampling 
dibellasubset <- subset(di_bella_full, 
                        idents = c("Immature neurons",
                                   "Doublet",
                                   "Endothelial cells",
                                   "Microglia",
                                   "Migrating neurons",
                                   "Pericytes",
                                   "Ependymocytes",
                                   "Red blood cells",
                                   "Low quality cells",
                                   "Interneurons",
                                   "SCPN",
                                   "CThPN",
                                   "DL CPN",
                                   "UL CPN",
                                   "Cycling glial cells",
                                   "Layer 4",
                                   "Layer 6b",
                                   "NP",
                                   "DL_CPN_2",
                                   "DL_CPN_1",
                                   "VLMC"),
                        invert = TRUE,
                        downsample = 1000)

# Downsampling by age 
Idents(dibellasubset) <- "biosample_id"
dibellasubset <- subset(dibellasubset, 
                        idents = c("P1",
                                   "P4",
                                   "P1_S1",
                                   "E18_S1",
                                   "E18_S3",
                                   "E13",
                                   "E14",
                                   "E15",
                                   "E17"))

# Removing columns 
cols_to_remove <- c(
  "species__ontology_label",
  "sex",
  "library_preparation_protocol__ontology_label",
  "library_preparation_protocol",
  "organ__ontology_label",
  "organ",
  "disease", 
  "donor_id",
  "n_hkgene",
  "RNA_snn_res_1",
  "RNA_snn_res_2", 
  "Doublet_intersect",
  "Gral_cellType",
  "species",
  "disease_ontology_label",
  "scrublet_doublet",
  "CC_Difference"
)

dibellasubset@meta.data[cols_to_remove] <- NULL
saveRDS(dibellasubset, file = "Data/data_processed/dibellasubsetfig3.rds")

rm(list = setdiff(ls(), c("dibellasubset")))


###################################################
# --------------  LOO DATASET ---------------------
###################################################

# load and pre-process the data 
Loo_E14 <- readRDS("Data/Loo_E14.rds")
Idents(Loo_E14) <- "loo_clusters"

LooE14sb <- subset(Loo_E14, idents = c("RG3 (cortical hem) [21-E]",
                                       "RG2 [14-E]",
                                       "RG1 [8-E]",
                                       "RG4 [10-E]",
                                       "LayerI [17-E]",
                                       "SVZ3 (proliferating) [15-E]",
                                       "SVZ2 (VZ-SVZ) [11-E]"))

Loo_P0 <- readRDS("Data/Loo_P0.rds")
Idents(Loo_P0) <- "loo_clusters"

LooP0sb <- subset(Loo_P0, idents = c("Oligodendrocytes [16-P]",
                                     "LayerI [19-P]",
                                     "Astrocytes (immature) 2 [13-P]",
                                     "Astrocytes (immature) 1 [10-P]",
                                     "SVZ1 (migrating) [2-P]",
                                     "SVZ2 (migrating) [8-P]"))

### Merge the two datasets and process the metadata

LooE14sb$merge <- paste(LooE14sb$loo_clusters)
LooP0sb$merge <- paste(LooP0sb$loo_clusters)
Idents(LooE14sb) <- "merge"
Idents(LooP0sb) <- "merge"
DefaultAssay(LooE14sb) <- "RNA"
DefaultAssay(LooP0sb) <- "RNA"
LooP0sb$merge <- paste("LooP0sb", LooP0sb$merge, sep = "_")
LooE14sb$merge <- paste("LooE14sb", LooE14sb$merge, sep = "_")
LooP0sb$Condition <- "LooP0sb"
LooE14sb$Condition <- "LooE14sb"

# Merge Objects 
All.combined <- merge(x = LooP0sb,
                      y = LooE14sb,
                      add.cell.ids = c("LooP0sb",
                                       "LooE14sb"),
                      project = "LooP0E14")
DefaultAssay(All.combined) <- "RNA"
All.combined.list <- SplitObject(All.combined, split.by = "Condition")

All.combined.list <- lapply(All.combined.list, function(x) {
  x <- NormalizeData(x)
  x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 1500)
})

features <- SelectIntegrationFeatures(object.list = All.combined.list, nfeatures = 4000)

All.combined.list <- lapply(All.combined.list, function(x) {
  x <- ScaleData(x, features = features, verbose = FALSE)
  x <- RunPCA(x, features = features, verbose = FALSE)
})

anchors <- FindIntegrationAnchors(object.list = All.combined.list, anchor.features = features, reduction = "rpca")
LooP0E14 <- IntegrateData(anchorset = anchors)


# Analysis 
DefaultAssay(LooP0E14) <- "integrated"
LooP0E14 <- ScaleData(LooP0E14, verbose = FALSE, model.use = "linear")
LooP0E14 <- RunPCA(LooP0E14, verbose = FALSE, npcs = 30)
LooP0E14 <- RunUMAP(LooP0E14, reduction = "pca", dims = 1:8)
saveRDS(LooP0E14, file = "Data/data_processed/LooP0E14.rds")

rm(list = setdiff(ls(), c("dibellasubset", "LooP0E14")))

###################################################
# --------------  MARCY DATASET -------------------
###################################################

#### Load and process the data 
same_umap_P2_P12_P22 <- readRDS("Data/same_umap_P2_P12_P22.rds")
Idents(same_umap_P2_P12_P22) <- "orig.ident"
marcysubP2b <- subset(same_umap_P2_P12_P22, idents = c("p2"))
Idents(marcysubP2b) <- "complete_simplified_clusters"
marcysubP2b <- subset(marcysubP2b, idents = c("P2_Ependymal cells", "P2_Neuroblasts"), invert = T)
saveRDS(marcysubP2b, file = "Data/data_processed/marcyfig3.rds")

rm(list = setdiff(ls(), c("dibellasubset", "LooP0E14", "marcysubP2b")))


###################################################
# --------------  MERGED ALL DATASET --------------
###################################################

# Set RNA as the default assay
DefaultAssay(LooP0E14)     <- "RNA"
DefaultAssay(dibellasubset) <- "RNA"
DefaultAssay(marcysubP2b)   <- "RNA"

# Assign dataset labels
LooP0E14$dataset      <- "Loo"
dibellasubset$dataset <- "dib"
marcysubP2b$dataset   <- "marcy"

# Function to add QC metrics
add_qc_features <- function(obj) {
  obj$log10GenesPerUMI <- log10(obj$nFeature_RNA) / log10(obj$nCount_RNA)
  obj$mitoRatio        <- PercentageFeatureSet(obj, pattern = "^mt-") / 100
  return(obj)
}

# Apply QC function
LooP0E14     <- add_qc_features(LooP0E14)
dibellasubset <- add_qc_features(dibellasubset)
marcysubP2b   <- add_qc_features(marcysubP2b)

# Add merge IDs and timepoint labels
dibellasubset$mergeID <- paste0("dib_", dibellasubset$New_cellType)
dibellasubset$mergeTP <- paste0("dib_", dibellasubset$orig_ident)

LooP0E14$mergeID <- paste0("Loo_", LooP0E14$loo_clusters)
LooP0E14$mergeTP <- paste0("Loo_", LooP0E14$orig.ident)

marcysubP2b$mergeID <- paste0("marcy_", marcysubP2b$complete_simplified_clusters)
marcysubP2b$mergeTP <- paste0("marcy_", marcysubP2b$orig.ident)

#########################################################
#------------------MERGE UNINTEGRATED--------------------
#########################################################

mergedALL2 <- merge(
  LooP0E14,
  y = c(dibellasubset, marcysubP2b),
  add.cell.ids = c("Loo", "dib", "marcy")
)

Idents(mergedALL2) <- "dataset"

# Normalize and compute PCA/UMAP
mergedALL2 <- NormalizeData(mergedALL2, assay = "RNA", verbose = FALSE)
mergedALL2 <- FindVariableFeatures(mergedALL2, assay = "RNA", verbose = FALSE)
mergedALL2 <- ScaleData(mergedALL2, assay = "RNA", verbose = FALSE)
mergedALL2 <- RunPCA(mergedALL2, assay = "RNA", verbose = FALSE)
mergedALL2 <- RunUMAP(
  mergedALL2,
  dims = 1:30,
  reduction = "pca",
  reduction.name = "umap.unintegrated",
  verbose = FALSE
)

# Clean up mergeID labels
replacements <- c(
  "\\[|\\]|\\(|\\)" = "",
  "Loo_Oligodendrocytes 16-P" = "Loo_Oligo",
  "Loo_Astrocytes immature 1 10-P" = "Loo_Astro_i1",
  "Loo_SVZ1 migrating 2-P" = "Loo_SVZ1_mig_P",
  "Loo_LayerI 19-P" = "Loo_C&Rc_P",
  "Loo_Astrocytes immature 2 13-P" = "Loo_Astro_i2",
  "Loo_RG1 8-E" = "Loo_RG1",
  "Loo_RG4 10-E" = "Loo_RG4",
  "Loo_SVZ1 migrating 4-E" = "Loo_SVZ1_mig_E",
  "Loo_SVZ3 proliferating 15-E" = "Loo_SVZ3_Pro_E",
  "Loo_SVZ2 VZ-SVZ 11-E" = "Loo_SVZ2_SVZ_E",
  "Loo_RG3 cortical hem 21-E" = "Loo_RG3",
  "Loo_RG2 14-E" = "Loo_RG2",
  "Loo_LayerI 17-E" = "Loo_C&Rc_E",
  "dib_Intermediate progenitors" = "dib_progenitors",
  "dib_Cajal Retzius cells" = "dib_C&Rc",
  "dib_Astrocytes" = "dib_Astro",
  "dib_Oligodendrocytes" = "dib_Oligo",
  "marcy_P2_Oligos" = "marcy_P2_Oligo",
  "marcy_P2_Astrocytes" = "marcy_P2_Astro"
)
mergedALL2$mergeID <- str_replace_all(mergedALL2$mergeID, replacements)

saveRDS(mergedALL2, "Data/data_processed/mergedALL_unintegrated.rds")

rm(list = setdiff(ls(), c("dibellasubset", "LooP0E14", "marcysubP2b", "add_qc_features")))

#########################################################
#------------------MERGE INTEGRATED----------------------
#########################################################

datasets <- list(
  Loo = subset(LooP0E14, downsample = 5000),
  dib = subset(dibellasubset, downsample = 5000),
  marcy = subset(marcysubP2b, downsample = 5000)
)

datasets <- lapply(datasets, add_qc_features)

for (name in names(datasets)) {
  datasets[[name]]$dataset <- name
  if (!"mergeID" %in% colnames(datasets[[name]]@meta.data)) {
    datasets[[name]]$mergeID <- paste0(name, "_", Idents(datasets[[name]]))
  }
  if (!"mergeTP" %in% colnames(datasets[[name]]@meta.data)) {
    datasets[[name]]$mergeTP <- paste0(name, "_", datasets[[name]]$orig.ident)
  }
}

All.combined <- merge(
  datasets$Loo,
  y = c(datasets$dib, datasets$marcy),
  add.cell.ids = names(datasets),
  project = "mergedALL"
)

DefaultAssay(All.combined) <- "RNA"
All.combined.list <- SplitObject(All.combined, split.by = "dataset")
All.combined.list <- lapply(All.combined.list, SCTransform, verbose = TRUE, vst.flavor = "v2")

features <- SelectIntegrationFeatures(All.combined.list, nfeatures = 3000)
All.combined.list <- PrepSCTIntegration(All.combined.list, anchor.features = features)
anchors  <- FindIntegrationAnchors(All.combined.list, normalization.method = "SCT", anchor.features = features)
mergedALL <- IntegrateData(anchors, normalization.method = "SCT")

mergedALL <- subset(mergedALL, subset = nFeature_RNA > 200 & nFeature_RNA < 6000)

DefaultAssay(mergedALL) <- "integrated"
mergedALL <- ScaleData(mergedALL, verbose = FALSE, model.use = "linear")
mergedALL <- RunPCA(mergedALL, npcs = 30, verbose = FALSE)
mergedALL <- FindNeighbors(mergedALL, reduction = "pca", dims = 1:20)
mergedALL <- FindClusters(mergedALL, resolution = 0.4)
Idents(mergedALL) <- "seurat_clusters"

mergedALL <- FindSubCluster(
  mergedALL, cluster = "7",
  graph.name = "integrated_snn",
  resolution = 0.2,
  subcluster.name = "subcluster_7"
)

cells_7 <- which(mergedALL$seurat_clusters == "7")
subclustering <- as.character(mergedALL$subcluster_7[cells_7])
new_clusters <- as.character(mergedALL$seurat_clusters)
new_clusters[cells_7[subclustering == "7_1"]] <- "14"
mergedALL$seurat_clusters <- factor(new_clusters)
Idents(mergedALL) <- mergedALL$seurat_clusters

columns_to_keep <- c(
  "orig.ident","nCount_RNA","orig_ident","S_Score","G2M_Score","biosample_id",
  "complete_simplified_clusters","nFeature_RNA","percent.mt","loo_clusters","merge",
  "Condition","dataset","mitoRatio","mergeID","mergeTP","seurat_clusters"
)
mergedALL@meta.data <- mergedALL@meta.data[, columns_to_keep, drop = FALSE]

mergedALL <- RunUMAP(
  mergedALL, reduction = "pca", dims = 1:8,
  n.neighbors = 60, min.dist = 0.3, verbose = FALSE
)

Idents(mergedALL) = "mergeID"
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "\\[|\\]", "")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "\\(|\\)", "")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_Oligodendrocytes 16-P", "Loo_Oligo")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_Astrocytes immature 1 10-P", "Loo_Astro_i1")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_SVZ1 migrating 2-P", "Loo_SVZ1_mig_P")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_LayerI 19-P","Loo_C&Rc_P")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_Astrocytes immature 2 13-P" , "Loo_Astro_i2")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_RG1 8-E" , "Loo_RG1")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_RG4 10-E" , "Loo_RG4")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_SVZ1 migrating 4-E" , "Loo_SVZ1_mig_E")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_SVZ3 proliferating 15-E" , "Loo_SVZ3_Pro_E")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_SVZ2 VZ-SVZ 11-E" , "Loo_SVZ2_SVZ_E")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_RG3 cortical hem 21-E", "Loo_RG3")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_RG2 14-E" , "Loo_RG2")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_LayerI 17-E", "Loo_C&Rc_E")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "dib_Intermediate progenitors", "dib_progenitors")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "dib_Cajal Retzius cells" ,"dib_C&Rc")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "dib_Astrocytes" , "dib_Astro")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "dib_Oligodendrocytes" , "dib_Oligo")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "_P2" , "")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "Loo_SVZ2 migrating 8-P" , "Loo_SVZ2 migrating")
mergedALL$mergeID <- str_replace_all(mergedALL$mergeID, "dib_Apical progenitors" , "dib_AP")
Idents(mergedALL) = "mergeID"

DefaultAssay(mergedALL) <- "RNA"
all_markers <- FindAllMarkers(mergedALL, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)

marker_panel <- tibble::tibble(
  Subtype = c("ImAstro", "Oligo", "qNSCs", "aNSCs", "NP", "CR", "RG", "Neuroblasts"),
  Markers = list(
    c("Gfap","Aldh1l1","S100b","Aqp4","Glul","Gja1","Slc1a2","Slc1a3","Fabp7"),
    c("Mbp","Plp1","Cntn1","Olig2","Olig1","Entpd3"),
    c("Hopx","Sox2","Thbs4","Lrp4","Hes5","Sdc4","Aqp4","Sox9","Agt","Id4","Id3"),
    c("Sox2","Egf","Mki67","Ppp1r14b","Tubb3","Lima1","Ascl1","Efhd2"),
    c("Ascl1","Neurog2","Dlx2","Dcx","Cenpf","Fabp7","Sox9","Pax6"),
    c("Reln","Ebf3","Lhx5","Lhx1","Nr2f2","Trp73","Samd3","Dcx","Ndnf"),
    c("Pax6","Hes1","Hes5","Sox2","Fabp7","Slc1a3","Notch1","Mki67","Vim"),
    c("Dcx","Tubb3","Stmn2","Btbd17","Neurog2")
  )
)

identify_subtype <- function(cluster_genes, panel) {
  matches <- sapply(panel$Markers, function(genes) length(intersect(cluster_genes, genes)))
  panel$Subtype[which.max(matches)]
}

cluster_subtype <- data.frame(Cluster = unique(all_markers$cluster), Subtype = NA)
for (cl in unique(all_markers$cluster)) {
  genes <- filter(all_markers, cluster == cl) %>% pull(gene)
  cluster_subtype[cluster_subtype$Cluster == cl, "Subtype"] <- identify_subtype(genes, marker_panel)
}

print(cluster_subtype)

mergedALL$new_ident <- recode(as.character(mergedALL$seurat_clusters),
                              "0"="Neuroblasts",
                              "1"="qNSCs",
                              "2"="aNSCs",
                              "3"="RG",
                              "4"="NP",
                              "5"="Oligo",
                              "6"="Neuroblasts",
                              "7"="ImAstro",
                              "8"="CR",
                              "9"="Oligo",
                              "10"="CR",
                              "11"="Oligo",
                              "12"="Oligo",
                              "14"="ImAstro"
)

Idents(mergedALL) <- "mergeID"
mergedALL$mergeID <- gsub("^(Loo_|dib_|marcy_)\\1", "\\1", mergedALL$mergeID)
mergedALL$mergeID <- gsub("\\[|\\]|\\(|\\)", "", mergedALL$mergeID)
mergedALL$mergeID <- factor(mergedALL$mergeID)
Idents(mergedALL) <- mergedALL$mergeID

Idents(mergedALL) <- "mergeID"
current_idents <- as.character(Idents(mergedALL))
merged_idents <- current_idents
merged_idents[merged_idents %in% c("Loo_Astro_i1", "Loo_Astro_i2")] <- "Loo_Astro"
merged_idents[merged_idents %in% c("Loo_RG1", "Loo_RG3", "Loo_RG4")] <- "Loo_RG"
merged_idents[merged_idents %in% c("Loo_SVZ2 migrating", "Loo_SVZ1_mig_P", "Loo_SVZ3_Pro_E", "Loo_SVZ2_SVZ_E")] <- "Loo_SVZ"
mergedALL$merged_idents <- merged_idents

saveRDS(mergedALL, "Data/data_processed/mergedALL.rds")

#########################################################
#------------------CAJAL-RETZIUS ANALYSIS----------------
#########################################################

DefaultAssay(mergedALL) <- "integrated"
Idents(mergedALL) <- "mergeID"
Cajal <- subset(mergedALL, idents = c("Loo_C&Rc_P", "Loo_C&Rc_E", "dib_C&Rc"))

Cajal <- FindNeighbors(Cajal, reduction = "pca", dims = 1:25, verbose = FALSE)
Cajal <- FindClusters(Cajal, resolution = 0.17, cluster.name = "pca_clusters")

Idents(Cajal) <- "mergeTP"
Cajal <- RenameIdents(Cajal,
                      "dib_E18_S1" = "dib_E18",
                      "dib_E18_S3" = "dib_E18", 
                      "dib_P1_S1"  = "dib_P1",
                      "Loo_e14.WT10" = "Loo_e14",
                      "Loo_e14.WT11" = "Loo_e14",
                      "Loo_e14.WT8.1" = "Loo_e14",
                      "Loo_e14.WT8.2" = "Loo_e14",
                      "Loo_e14.WT9.1" = "Loo_e14",
                      "Loo_e14.WT9.2" = "Loo_e14",
                      "Loo_p0.WT2" = "Loo_p0",
                      "Loo_p0.WT3" = "Loo_p0",
                      "Loo_p0.WT4" = "Loo_p0"
)
Cajal$mergeTP <- Idents(Cajal)

Cajal <- RunUMAP(Cajal, reduction = "pca", dims = 1:4, reduction.name = "umap.pca", verbose = FALSE, min.dist = 0.25, n.neighbors = 42)

SCpubr::do_DimPlot(Cajal, reduction = "umap.pca", group.by = c("seurat_clusters"), label.size = 4, label = TRUE, repel = TRUE, pt.size = 2)

umap.embeddings <- Embeddings(Cajal, reduction = "umap.pca")
slingshot.obj <- slingshot(umap.embeddings, clusterLabels = Cajal$pca_clusters, start.clus = 0)
pseudotime <- slingPseudotime(slingshot.obj)
Cajal$pseudotime <- pseudotime[,1]

saveRDS(Cajal, file = "Data/data_processed/Cajal_fig3.rds")

#########################################################
#------------------CELL CHAT OBJECT----------------------
#########################################################

DefaultAssay(mergedALL) <- "integrated"
mergedALL[["RNA"]] <- as(object = mergedALL[["RNA"]], Class = "Assay")

data.input <- GetAssayData(mergedALL, assay = "RNA", slot = "data")
meta <- mergedALL@meta.data

cell.use <- rownames(meta)[!is.na(meta$merged_idents) & meta$merged_idents != "x"]
common_cells <- intersect(colnames(data.input), cell.use)
data.input <- data.input[, common_cells]
meta <- meta[common_cells, ]

if (!"samples" %in% colnames(meta)) {
  meta$samples <- "sample1"
}

cellchat <- createCellChat(object = data.input, meta = meta, group.by = "merged_idents")
CellChatDB <- CellChatDB.mouse
cellchat@DB <- CellChatDB

cellchat <- subsetData(cellchat)
cellchat <- updateCellChat(cellchat)
cellchat <- identifyOverExpressedGenes(cellchat)
cellchat <- identifyOverExpressedInteractions(cellchat)
cellchat <- computeCommunProb(cellchat)
cellchat <- filterCommunication(cellchat, min.cells = 10)

df.net <- subsetCommunication(cellchat)
df.net <- subsetCommunication(cellchat, signaling = c("WNT", "BMP"))

cellchat <- computeCommunProbPathway(cellchat)
cellchat <- aggregateNet(cellchat)

saveRDS(cellchat, file = "Data/data_processed/cellchatfig3.rds")