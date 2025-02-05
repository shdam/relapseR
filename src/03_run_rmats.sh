#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=dp_immunoth -A dp_immunoth
### Job name (comment out the next line to get the name of the script used as the job name)
##PBS -N rMATS_icope
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -o log/$PBS_JOBNAME.out
#PBS -e log/$PBS_JOBNAME.err
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=120gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 12 hours)
#PBS -l walltime=10:00:00
### Forward X11 connection (comment out if not needed)
##PBS -X
# -- Job array specification --
##PBS -t 1-10%10

# Go to the directory from where the job was submitted (initial directory is $HOME)
cd $PBS_O_WORKDIR
# Load all required modules for the job
module load gcc/7.2.0 intel/perflibs samtools/1.20 rmats-turbo/4.1.1

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes


/usr/bin/time -v bash /home/projects/dp_immunoth/people/s153398/relapseR/src/03_rmats_icope.sh

