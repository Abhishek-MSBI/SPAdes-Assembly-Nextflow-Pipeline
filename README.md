# SPAdes-Assembly-Nextflow-Pipeline

## Project Overview

This pipeline provides an automated bacterial genome assembly workflow using SPAdes (St. Petersburg genome assembler) implemented in Nextflow. The pipeline is designed to streamline the process of assembling bacterial genomes from paired-end sequencing reads, making it easy to process multiple samples with consistent parameters and reproducible results.

SPAdes is a widely-used de novo genome assembler specifically designed for small genomes like bacteria and other microorganisms. This Nextflow implementation provides a scalable and reproducible framework for running SPAdes across multiple samples efficiently.

## Features

- **Multi-sample support**: Process multiple bacterial genome samples in parallel
- **Easy configuration**: Simple configuration files for customizing assembly parameters
- **Reproducible bioinformatics workflow**: Consistent results across different runs and environments
- **Automated output management**: Organized output structure with assembled contigs and assembly statistics
- **Scalable execution**: Leverages Nextflow's powerful execution engine for local or cluster computing
- **Quality reporting**: Generates assembly quality metrics and reports

## Installation

### Prerequisites

1. **Install Nextflow** (version 21.04.0 or later)
   ```bash
   curl -s https://get.nextflow.io | bash
   mv nextflow /usr/local/bin/
   ```

2. **Install Dependencies**
   - SPAdes assembler (version 3.15.0 or later)
   - Java 8 or later (required for Nextflow)
   - Docker or Singularity (optional, for containerized execution)

   To install SPAdes:
   ```bash
   # Using conda
   conda install -c bioconda spades
   
   # Or download from:
   # https://github.com/ablab/spades
   ```

### Clone Repository

```bash
git clone https://github.com/Abhishek-MSBI/SPAdes-Assembly-Nextflow-Pipeline.git
cd SPAdes-Assembly-Nextflow-Pipeline
```

## Usage

### Basic Execution

Run the pipeline with default parameters:

```bash
nextflow run main.nf --input samplesheet.csv --outdir results
```

### Advanced Options

Customize the pipeline execution:

```bash
nextflow run main.nf \
  --input samplesheet.csv \
  --outdir results \
  --kmer_sizes '21,33,55' \
  --careful true \
  --threads 8
```

### Using Configuration File

```bash
nextflow run main.nf -c nextflow.config
```

## Inputs

### 1. Sample Sheet (samplesheet.csv)

A CSV file containing sample information with the following format:

```csv
sample_id,read1,read2
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
sample3,/path/to/sample3_R1.fastq.gz,/path/to/sample3_R2.fastq.gz
```

**Column descriptions:**
- `sample_id`: Unique identifier for each sample
- `read1`: Full path to forward reads (R1) FASTQ file
- `read2`: Full path to reverse reads (R2) FASTQ file

### 2. Configuration File (nextflow.config)

Customize pipeline parameters:

```groovy
params {
    input = 'samplesheet.csv'
    outdir = 'results'
    kmer_sizes = '21,33,55,77'
    careful = true
    threads = 16
    memory = '32 GB'
}

process {
    executor = 'local'
    cpus = 8
    memory = '16 GB'
}
```

### 3. Main Workflow (main.nf)

The main Nextflow workflow file that orchestrates the assembly process. This file should be present in the repository and contains the pipeline logic.

## Output

The pipeline generates organized output in the specified output directory:

```
results/
├── assemblies/
│   ├── sample1/
│   │   ├── contigs.fasta          # Assembled contigs
│   │   ├── scaffolds.fasta        # Assembled scaffolds
│   │   ├── assembly_graph.fastg   # Assembly graph
│   │   └── spades.log             # SPAdes log file
│   ├── sample2/
│   └── sample3/
├── reports/
│   ├── assembly_stats.txt         # Assembly statistics summary
│   └── multiqc_report.html        # MultiQC report (if enabled)
└── pipeline_info/
    ├── execution_report.html      # Nextflow execution report
    └── timeline.html              # Execution timeline
```

### Key Output Files:

- **contigs.fasta**: Primary assembly output containing assembled contigs
- **scaffolds.fasta**: Scaffolded sequences (if applicable)
- **assembly_graph.fastg**: Graph representation of the assembly
- **spades.log**: Detailed log of the SPAdes assembly process
- **assembly_stats.txt**: Summary statistics including N50, total length, number of contigs, etc.

## Citation / Credits

### Citing This Pipeline

If you use this pipeline in your research, please cite:

```
SPAdes-Assembly-Nextflow-Pipeline
Author: Abhishek S R
URL: https://github.com/Abhishek-MSBI/SPAdes-Assembly-Nextflow-Pipeline
```

### Citing SPAdes

Please also cite the SPAdes assembler:

```
Bankevich A, Nurk S, Antipov D, et al. SPAdes: a new genome assembly algorithm 
and its applications to single-cell sequencing. J Comput Biol. 2012;19(5):455-477.
```

### Citing Nextflow

```
Di Tommaso P, Chatzou M, Floden EW, Barja PP, Palumbo E, Notredame C. 
Nextflow enables reproducible computational workflows. Nat Biotechnol. 2017;35(4):316-319.
```

### Author

**Abhishek S R**
- GitHub: [@Abhishek-MSBI](https://github.com/Abhishek-MSBI)

## License

License information will be added in a future release. Please contact the author for usage permissions.

## Support

For issues, questions, or contributions, please open an issue on the [GitHub repository](https://github.com/Abhishek-MSBI/SPAdes-Assembly-Nextflow-Pipeline/issues).

---

*Last updated: October 2025*
