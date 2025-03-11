#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=dp_immunoth -A dp_immunoth
### Job name (comment out the next line to get the name of the script used as the job name)
##PBS -N outrigger_icope
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
#PBS -l walltime=48:00:00
### Forward X11 connection (comment out if not needed)
##PBS -X
# -- Job array specification --
#PBS -t 0-28%29
##PBS -t 0-92%30

# Go to the directory from where the job was submitted (initial directory is $HOME)
cd $PBS_O_WORKDIR
# Load all required modules for the job
module load anaconda2/4.4.0 mamba-org/mamba/0.24.0
__conda_setup="$('/services/tools/mamba-org/mamba/0.24.0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
. "/services/tools/mamba-org/mamba/0.24.0/etc/profile.d/conda.sh"
. "/services/tools/mamba-org/mamba/0.24.0/etc/profile.d/mamba.sh"
mamba activate outrigger-env


### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
INDICES=(6 9 13 18 20 21 25 28 31 37 38 42 43 47 48 49 51 52 54 55 56 57 65 67 75 77 81 84 93)
INDEX=${INDICES[$PBS_ARRAYID]}


/usr/bin/time -v bash /home/projects/dp_immunoth/people/s153398/relapseR/src/04_outrigger_icope.sh -i $INDEX -f


