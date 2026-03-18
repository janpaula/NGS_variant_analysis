library(ggplot2)

coverage <- read.table("Bioinformática/TreinamentoAnaliseDNA/data/coverage.txt")
colnames(coverage) <- c("chr","pos","depth")

ggplot(coverage, aes(x = pos, y = depth)) +
  geom_line() +
  theme_minimal() +
  labs(
    title = "Genome Coverage Plot",
    x = "Genomic Position",
    y = "Read Depth"
  )

ggsave("Bioinformática/TreinamentoAnaliseDNA/data/coverage_plot.png", width = 8, height = 4)
