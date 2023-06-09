#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=cm
#SBATCH --time=10:00:00
#SBATCH --mem=10GB
#SBATCH --job-name=best_gg
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=rj931@nyu.edu
#SBATCH --output=slurm_%j.out



module purge

module load nextflow/23.04.1

# i have to run this twice since the files are being created and sent to the dir
# so now that they exist the pipeline can move on, how to fix this and make it run
# or check the directories again instead

nextflow run -resume pe_sle_pipeline.nf
nextflow run -resume pe_sle_pipeline.nf



find . -name *fastqc.zip > fastqc_files.txt

module load multiqc/1.9

multiqc -force --file-list fastqc_files.txt --filename 'multiqc_report.html'

#nextflow run -resume pe_sle_pipeline.nf

# here i want to out put the genomic regions
# specify the path and the glob pattern for the --reads
# specify the the out dir for this set of filtered outputs
# specify the location of the bg filtered output fq files and the same glob pattern in the reads

#nextflow run -resume pe_sle_pipeline.nf \
#--reads "/scratch/rj931/tf_sle_project/all_sle_data/461-IgG*cut*_{R1,R2}*.fastq.gz" \
#--outdir "bg_filt" \
#--filts "bg_filt/461-IgG*cut*_{R1,R2}*.fastq.gz" \



# this section is to run the make_homer.sh script part of the pipeline

sbatch make_homer.sh
