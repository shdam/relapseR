module load anaconda2/4.4.0
module load mamba-org/mamba/0.24.0
module load python/3.12.0

conda config --add channels r
conda config --add channels bioconda

mamba create --name outrigger-env outrigger

source activate outrigger-env




git clone https://github.com/YeoLab/outrigger.git
cd outrigger
mamba env create --file environment.yml
mamba activate outrigger-env
mamba install outrigger