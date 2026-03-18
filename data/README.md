# Sequencing Data

Raw sequencing reads are not included in this repository due to file size limitations.

The dataset can be downloaded from the NCBI Sequence Read Archive (SRA).

Accession number:

SRR1972877

Download using SRA Toolkit:

```
prefetch SRR1972877
fasterq-dump SRR1972877
```

After downloading, run the trimming step using fastp as described in the pipeline.
