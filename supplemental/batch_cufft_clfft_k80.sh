#!/bin/bash
#SBATCH -J gearshifftK80
#SBATCH --nodes=1  
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --time=6:00:00
#SBATCH --mem=62000M # gpu2
#SBATCH --partition=gpu2
#SBATCH --exclusive
#SBATCH --array 0-2
#SBATCH -o slurmgpu2_array-%A_%a.out
#SBATCH -e slurmgpu2_array-%A_%a.err

k=$SLURM_ARRAY_TASK_ID

CURDIR=/home/matwerne/cuda-workspace/gearshifft/
RESULTSZ=results/K80/cuda-7.5.18
RESULTSA=results/K80/cuda-8.0.44
RESULTSB=results/K80/clfft-2.12.2
FEXTENTS1D=/home/matwerne/sources/gearshifft_publication/scripts/extents_1D.conf
FEXTENTS2D=/home/matwerne/sources/gearshifft_publication/scripts/extents_2D.conf
FEXTENTS3D=/home/matwerne/sources/gearshifft_publication/scripts/extents_3D.conf
FEXTENTS=/home/matwerne/sources/gearshifft_publication/scripts/extents_all.conf
mkdir -p ${RESULTSZ}
mkdir -p ${RESULTSA}
mkdir -p ${RESULTSB}

# cuda 7.5.18
if [ $k -eq 0 ]; then
    module purge
    module load boost/1.60.0-gnu5.3-intelmpi5.1 cuda/7.5.18 gcc/5.3.0
    srun --gpufreq=2505:875 $CURDIR/release/gearshifft_cufft_75 -f $FEXTENTS -o $CURDIR/$RESULTSZ/cufft_gcc5.3.0_RHEL6.7.csv
fi
# default is cuda 8.0.44
if [ $k -eq 1 ]; then
    srun --gpufreq=2505:875 $CURDIR/release/gearshifft_cufft -f $FEXTENTS -o $CURDIR/$RESULTSA/cufft_gcc5.3.0_RHEL6.7.csv
fi
if [ $k -eq 2 ]; then
    srun --gpufreq=2505:875 $CURDIR/release/gearshifft_clfft -f $FEXTENTS -o $CURDIR/$RESULTSB/clfft_gcc5.3.0_RHEL6.7.csv
fi
module list
