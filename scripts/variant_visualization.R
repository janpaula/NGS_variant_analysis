# Carregar Pacotes
library(Gviz)
library(VariantAnnotation)
library(Biostrings)
library(ggplot2)

# Definir Paths
vcf_file <- "Bioinformática/TreinamentoAnaliseDNA/data/vcf_results/variants2_filtered.vcf"
ref_file <- "Bioinformática/TreinamentoAnaliseDNA/data/refs/AF086833.fasta"

# Carregar as referências
ref <- readDNAStringSet(ref_file)

seqname <- names(ref)
genome_length <- width(ref)
seqname
genome_length

# Carregar VCFs
vcf <- readVcf(vcf_file)
vcf

# Conferir posiçoes das variantes
pos <- start(rowRanges(vcf))

# Definir região para visualização
region_start <- 1
region_end <- genome_length

# Criar Eixo do Genoma
axisTrack <- GenomeAxisTrack()

# Permissão de nomes de cromossomos arbitrários
options(ucscChromosomeNames = FALSE)

# Track da sequência referência
refTrack <- SequenceTrack(ref)

# Criar track de variantes
variantTrack <- AnnotationTrack(
  start = pos,
  end = pos,
  chromosome = seqname,
  genome = "AF086833",
  name = "Variants",
  shape = "box"
)


# Verificar cabeçalho da referência
# Se tiver um arquivo GenBank (.gb) você pode extrair CDS.
gb <- readLines("Bioinformática/TreinamentoAnaliseDNA/data/genes.gb")
head(gb)

# Extrair CDS
cds_lines <- grep("CDS", gb, value=TRUE)

# Limpar coordenadas (Limpar palavras extras)
coords <- gsub("CDS", "", cds_lines)
coords <- gsub("\\(|\\)", "", coords)

# Remover complement() e join()
coords <- gsub("complement", "", coords)
coords <- gsub("join", "", coords)

# Pegar apenas primeiro intervalo
coords <- sapply(strsplit(coords, ","), `[`, 1)

# Limpar
coords_clean <- gsub("complement\\(|join\\(|\\)", "", coords)

# Separar início e fim
start <- as.numeric(sub("\\.\\..*", "", coords))
end <- as.numeric(sub(".*\\.\\.", "", coords))

head(start)
head(end)

# Remover linhas problemáticas
valid <- !is.na(start) & !is.na(end)
start <- start[valid]
end <- end[valid]

# Criar regiões genômicas
gr <- GRanges(
  seqnames = seqname,
  ranges = IRanges(start=start, end=end)
)


# Labels CDS
labels <- paste0("CDS_", seq_along(start))

# Criar o geneTrack
geneTrack <- GeneRegionTrack(
  cds,
  chromosome = "AF086833.2",
  genome = "Ebola virus 2014",
  name = "Genes",
  transcriptAnnotation = "gene",
  showId = TRUE,
  col = "darkblue",
  fill = "lightblue",
  stacking = "squish",
  cex = 0.8
)

# Criar track de variantes
snpTrack <- AnnotationTrack(
  start = start(rowRanges(vcf_roi)),
  end = end(rowRanges(vcf_roi)),
  chromosome = "AF086833.2",
  genome = "Ebola virus 2014",
  name = "Variants",
  shape = "box",
  fill = "red",
  col = "darkred",
  stacking = "dense"
)

# Criar eixo do genoma
genomeAxisTrack <- GenomeAxisTrack()

# Plot Final
plotTracks(
  list(genomeAxisTrack, geneTrack, snpTrack),
  from = 1,
  to = 19000,
  chromosome = "AF086833.2",
  sizes = c(1, 2, 1),
  main="Genomic Tracks Plot"
)

# Gráfico Manhattan das variantes com campo QUAL do VCF.
# Extrair QUAL
# Extrair dados variantes
vr <- rowRanges(vcf)
df <- data.frame(
  pos = start(vr),
  qual = qual(vcf)
)
# Se QUAL estiver faltando, tentar colunas de metadados
if (all(is.na(df$qual))) {
  df$qual <- mcols(vr)$QUAL
}

# Manhattan plot
ggplot(df, aes(x = pos, y = qual)) +
  geom_point(alpha = 0.6, color = "blue") +
  labs(title = "Manhattan plot of variants",
       x = "Position on AF086833.2",
       y = "Variant Quality (QUAL)") +
  theme_minimal()


# Adicionar cores por tipo SNP/INS/DEL se extrair os comprimentos REF/ALT como antes
ref <- as.character(ref(vcf))
alt <- sapply(alt(vcf), function(x) as.character(x[1]))
variant_type <- ifelse(nchar(ref) == nchar(alt), "SNP",
                       ifelse(nchar(ref) < nchar(alt), "INS", "DEL"))
df$variant_type <- variant_type

# Gráfico já colorido
ggplot(df, aes(x = pos, y = qual, color = variant_type)) +
  geom_point(alpha = 0.6) +
  labs(title = "Manhattan plot of variants by type",
       x = "Position on AF086833.2",
       y = "Variant Quality (QUAL)") +
  scale_color_manual(values = c(SNP = "blue", INS = "green", DEL = "red")) +
  theme_minimal()


# Definir cutoff de qualidade
qual_cutoff <- 50

# filtro para variantes que têm QUAL maior que cutoff
high_qual_filter <- qual(vcf) > qual_cutoff

# Subset do VCF apenas com variantes de alta qualidade
vcf_filtered <- vcf[high_qual_filter, ]

# Ver quantas variantes sobraram
length(rowRanges(vcf))
length(rowRanges(vcf_filtered))


# Filtro de variantes
vr_filtered <- rowRanges(vcf_filtered)
df_filtered <- data.frame(
  pos = start(vr_filtered),
  qual = qual(vcf_filtered)
)

# Gráfico das variantes com QUAL > 50
ggplot(df_filtered, aes(x = pos, y = qual)) +
  geom_point(color = "darkgreen", alpha = 0.6) +
  labs(title = paste("Variants with QUAL >", qual_cutoff),
       x = "Position",
       y = "Quality (QUAL)") +
  theme_minimal()
