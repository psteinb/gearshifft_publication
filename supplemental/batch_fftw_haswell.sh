#!/bin/bash
#SBATCH -J gearshifftFFTW
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=168:00:00
#SBATCH --mem=62000M
#SBATCH --partition=haswell64
#SBATCH --exclusive
#SBATCH --array 0-5,7-9
#SBATCH -o slurmcpu_array-%A_%a.out
#SBATCH -e slurmcpu_array-%A_%a.err

k=$SLURM_ARRAY_TASK_ID

RESULTS=results/haswell/fftw3.3.5
mkdir -p ${RESULTS}

FEXTENTS1D=/home/matwerne/sources/gearshifft_publication/scripts/extents_1D.conf
FEXTENTS1DFFTW=/home/matwerne/sources/gearshifft_publication/scripts/extents_1D_fftw.conf # excluded a few very big ones
FEXTENTS2D=/home/matwerne/sources/gearshifft_publication/scripts/extents_2D.conf
FEXTENTS3D=/home/matwerne/sources/gearshifft_publication/scripts/extents_3D.conf
FEXTENTS=/home/matwerne/sources/gearshifft_publication/scripts/extents_all.conf

if [ $k -eq 0 ]; then
     ./release/gearshifft_fftw_estimate -f $FEXTENTS1D -o ./$RESULTS/fftw_estimate_gcc5.3.0_RHEL6.7.1d.csv
elif [ $k -eq 1 ]; then
     ./release/gearshifft_fftw_estimate -f $FEXTENTS2D -o ./$RESULTS/fftw_estimate_gcc5.3.0_RHEL6.7.2d.csv
elif [ $k -eq 2 ]; then
     ./release/gearshifft_fftw_estimate -f $FEXTENTS3D -o ./$RESULTS/fftw_estimate_gcc5.3.0_RHEL6.7.3d.csv
elif [ $k -eq 3 ]; then
     ./release/gearshifft_fftw_wisdom -f $FEXTENTS1D -o ./$RESULTS/fftw_wisdom_gcc5.3.0_RHEL6.7.1d.csv
elif [ $k -eq 4 ]; then
     ./release/gearshifft_fftw_wisdom -f $FEXTENTS2D -o ./$RESULTS/fftw_wisdom_gcc5.3.0_RHEL6.7.2d.csv
elif [ $k -eq 5 ]; then
     ./release/gearshifft_fftw_wisdom -f $FEXTENTS3D -o ./$RESULTS/fftw_wisdom_gcc5.3.0_RHEL6.7.3d.csv
elif [ $k -eq 6 ]; then
     ./release/gearshifft_fftw -f $FEXTENTS1D -o ./$RESULTS/fftw_gcc5.3.0_RHEL6.7.1d.csv # takes too long, >7d
elif [ $k -eq 7 ]; then
     ./release/gearshifft_fftw -f $FEXTENTS2D -o ./$RESULTS/fftw_gcc5.3.0_RHEL6.7.2d.csv
elif [ $k -eq 8 ]; then
     ./release/gearshifft_fftw -f $FEXTENTS3D -o ./$RESULTS/fftw_gcc5.3.0_RHEL6.7.3d.csv
elif [ $k -eq 9 ]; then
     ./release/gearshifft_fftw -f $FEXTENTS1DFFTW -o ./$RESULTS/fftw_gcc5.3.0_RHEL6.7.1d.csv
fi

module list
