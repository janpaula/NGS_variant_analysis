
bwa index $REF

echo "Reference indexed"

# -------------------------------
# 4. Alignment
# -------------------------------

bwa mem -t $THREADS $REF \
trimmed/R1_trimmed.fastq.gz \
trimmed/R2_trimmed.fastq.gz \
> aligned.sam

echo "Alignment completed"

# -------------------------------
# 5. Convert SAM → BAM
# -------------------------------

samtools view -bS aligned.sam > aligned.bam

# -------------------------------
# 6. Sort BAM
# -------------------------------

samtools sort aligned.bam -o aligned_sorted.bam

# -------------------------------
# 7. Index BAM
# -------------------------------

samtools index aligned_sorted.bam

echo "BAM processing completed"

# -------------------------------
# 8. Variant calling
# -------------------------------

mkdir -p vcf_results

bcftools mpileup -f $REF aligned_sorted.bam | \
bcftools call -mv -Ov \
-o vcf_results/variants.vcf

echo "Variant calling completed"

# -------------------------------
# 9. Filter variants
# -------------------------------

bcftools filter \
-i 'QUAL>20' \
vcf_results/variants.vcf \
> vcf_results/variants_filtered.vcf

echo "Variant filtering completed"

echo "Pipeline finished successfully"
