# Figures

This directory contains the figures generated during the genomic variant analysis.

These visualizations summarize sequencing coverage, variant quality, and genomic context.

## Files

**coverage_plot.png**

Genome coverage plot showing sequencing depth across the reference genome.

Generated from BAM coverage data.

---

**manhattan_plot.png**

Variant quality distribution across genomic positions.

This Manhattan-style plot shows the QUAL scores of detected variants.

---

**genome_tracks.png**

Genome track visualization displaying:

* coding regions (CDS)
* detected variants
* genomic coordinates

Visualization generated using R packages such as Gviz.

---

**igv_variants.png**

Screenshot from IGV showing manual inspection of read alignments at variant positions.

## Tools used

Figures were generated using:

* R
* Gviz
* ggplot2
* IGV
