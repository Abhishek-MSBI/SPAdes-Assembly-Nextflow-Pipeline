#!/usr/bin/env nextflow

params.samplesheet = 'samplesheet.csv'

// Declare base input channels globally
samples_ch = Channel
    .fromPath(params.samplesheet)
    .splitCsv(header:true)

reads_ch = samples_ch.map { row -> tuple(row.sample, file(row.fastq_1), file(row.fastq_2)) }

workflow {

    // Flatten raw reads for FastQC
    raw_reads_ch = reads_ch
        .flatMap { sample, fq1, fq2 -> [fq1, fq2] }

    // FastQC on raw reads
    fastqc_raw_out = fastqc_raw(raw_reads_ch)

    // Trim reads
    trimmed_reads_out = trim_reads(reads_ch)

    // Flatten trimmed reads for FastQC
    trimmed_reads_flat_ch = trimmed_reads_out
        .flatMap { sample, trimmed1, trimmed2 -> [trimmed1, trimmed2] }

    // FastQC on trimmed reads
    fastqc_trimmed_out = fastqc_trimmed(trimmed_reads_flat_ch)

    // SPAdes assembly
    assembly_out = spades_assembly(trimmed_reads_out)
    
    // Run QUAST for assembly evaluation
    quast_out = quast(assembly_out)

    // Merge FastQC reports from both rounds for MultiQC
    all_fastqc_reports_ch = fastqc_raw_out.mix(fastqc_trimmed_out)

    // Run MultiQC report
    multiqc(all_fastqc_reports_ch.collect())
}

process fastqc_raw {
    input:
    path fastq_file

    output:
    path "*_fastqc.*"

    script:
    """
    fastqc $fastq_file
    """
}

process fastqc_trimmed {
    input:
    path fastq_file

    output:
    path "*_fastqc.*"

    script:
    """
    fastqc $fastq_file
    """
}

process trim_reads {
    input:
    tuple val(sample), path(fq1), path(fq2)

    output:
    tuple val(sample), path("${sample}_trimmed_1.fastq"), path("${sample}_trimmed_2.fastq")

    script:
    """
    fastp --in1 $fq1 --in2 $fq2 --out1 ${sample}_trimmed_1.fastq --out2 ${sample}_trimmed_2.fastq --thread 4 --disable_length_filtering
    """
}
process spades_assembly {
    publishDir "results/assemblies/${sample}", mode: 'copy' //
    input:
    tuple val(sample), path(fq1), path(fq2)

    output:
    tuple val(sample), path("contigs.fasta")

    script:
    """
    spades.py -1 $fq1 -2 $fq2 -o ./spades_out
    cp spades_out/contigs.fasta ./contigs.fasta
    """
}
process quast {
    input:
    tuple val(sample), path(contigs)

    output:
    path "quast_report"

    script:
    """
    quast.py $contigs -o quast_report
    """
}

process multiqc {
    input:
    path fastqc_reports

    output:
    path "multiqc_report"

    script:
    """
    multiqc -o multiqc_report $fastqc_reports
    """
}
