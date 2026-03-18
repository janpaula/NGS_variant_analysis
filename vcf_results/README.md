# Variant Calling Results

This directory contains the variant calling results generated from the NGS pipeline.

## Files

**variants_filtered.vcf**

Filtered variant file generated after variant calling.

Variants were called using:

* BCFtools

Filtering criteria:

* Quality score (QUAL) > 20

## File format

The Variant Call Format (VCF) contains information about detected genetic variants, including:

* chromosome
* genomic position
* reference allele
* alternate allele
* quality score
* filtering status

## Usage

This file is used for:

* variant visualization
* quality score analysis
* genomic track visualization in R

Visualization was performed using:

* VariantAnnotation
* Gviz
* ggplot2
