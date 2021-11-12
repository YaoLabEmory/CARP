# Introduction

### CircRNA identification by A-tailing RNase R and Pseudo-reference alignment (CARP)

Circular RNAs (circRNAs) are a large class of single-stranded, stable, functional RNAs in mammalian cells having a closed-loop structure. CircRNAs occur through the covalent joining of a downstream 3′ splice donor to an upstream 5′ splice acceptor via a previously underappreciated pre-mRNA splicing mechanism, known as "back-splicing".

CARP is an intergrated 21-module computational framework designed for circRNA analysis, including circRNA identification and quantification, DE analysis, circRNA full length construction and circRNA-miRNA-mRNA network analysis based on A-tailing RNase R treated/untreated RNA-seq data.

Detailed explanation for 21 module in CARP:

### CARP (CircRNA identification by A-tailing RNase R and Pseudo-reference alignment)

### Usage:  
### CARP \<Command\>  
        
   **RNAseq**:		RNA-seq data alignment
        
   **DEgene**:		Gene expression quantification and differential expression analysis
        
   **CIRCexplorer2**:	circRNA identification by CIRCexplorer2
        
   **CIRIquant**:		circRNA identification by CIRIquant
        
   **findcirc**:		circRNA identification by findcirc
        
   **MapSplice**:		circRNA identification by MapSplice
        
   **PseudoRef**:		Construct pseudo reference based on circRNA identified by CIRCexplorer2/CIRIquant/findcirc/MapSplice
        
   **Mapping**:		Reads align to circRNA pseudo reference
        
   **BSJreads**:		Identify back splice junction reads that align to pseudo reference and meet n-base match to junction flanking sequence
        
   **Remap**:		Remap all BSJreads to genome and transcriptome to identify linear RNA derived reads
        
   **ReadsCount**:		Reads count summary for each circRNA after false positive BSJreads filtering
        
   **Confidentcirc**:	Identify confident circRNA by comparing reads count for circRNA in A-tailing RNase R treated/untreated library
        
   **CircAS**:		Reconstruct circRNA full length based on A-tailing RNase R treated RNA-seq reads
        
   **CircIsoformSwitch**:	Identify circRNA internal structure change between case/control
        
   **DEcirc**:		DE analysis for circRNA between case/control after namolization
        
   **CircCluster**:		Analysis of circRNA cluster (circRNAs that share one back splicing junction site)
        
   **CircNetwork**:		Predict circRNA-miRNA interaction based on circRNA full length constructed by "CircAS"
        
   **CircRBP**:		Predict circRNA-RBP interaction based on published RBP CLIP-seq data
        
   **Sailor**:		Analysis of genome wide A-to-I editing
        
   **CircAtoI**:		Function of A-to-I editing in circRNA biogenesis
        
   **miRTarget**:		Analysis of global expression change of specific miRNA targets to determain its activity change
        
  
