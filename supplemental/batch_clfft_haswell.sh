#!/bin/bash
#SBATCH -J gearshifftClFFT_CPU
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=168:00:00
#SBATCH --mem=62000M
#SBATCH --partition=haswell64
#SBATCH --exclusive
#SBATCH --array 3
#SBATCH -o slurmcpu_clfft-%A_%a.out
#SBATCH -e slurmcpu_clfft-%A_%a.err

k=$SLURM_ARRAY_TASK_ID

module list

RESULTS=results/haswell/clfft-2.12.2
mkdir -p ${RESULTS}

FEXTENTS1D=/home/matwerne/sources/gearshifft_publication/scripts/extents_1D.conf
FEXTENTS1DFFTW=/home/matwerne/sources/gearshifft_publication/scripts/extents_1D_fftw.conf
FEXTENTS2D=/home/matwerne/sources/gearshifft_publication/scripts/extents_2D.conf
FEXTENTS3D=/home/matwerne/sources/gearshifft_publication/scripts/extents_3D.conf
FEXTENTS=/home/matwerne/sources/gearshifft_publication/scripts/extents_all.conf

if [ $k -eq 0 ]; then
    ./release/gearshifft_clfft -f $FEXTENTS1D -d cpu -o ./$RESULTS/clfft_gcc5.3.0_RHEL6.7.1d.csv
elif [ $k -eq 1 ]; then
    ./release/gearshifft_clfft -f $FEXTENTS2D -d cpu -o ./$RESULTS/clfft_gcc5.3.0_RHEL6.7.2d.csv
elif [ $k -eq 2 ]; then
    ./release/gearshifft_clfft -f $FEXTENTS3D -d cpu -o ./$RESULTS/clfft_gcc5.3.0_RHEL6.7.3d.csv
elif [ $k -eq 3 ]; then
    ./release/gearshifft_clfft -f $FEXTENTS -d cpu -o ./$RESULTS/clfft_gcc5.3.0_RHEL6.7.csv
fi
