#!/bin/bash
#SBATCH -J gearshifftK80_Verify
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --time=4:00:00
#SBATCH --mem=30000M # gpu2
#SBATCH --partition=gpu2
#SBATCH --exclusive
#SBATCH --array 0-1
#SBATCH -o slurmgpu2_array-%A_%a.out
#SBATCH -e slurmgpu2_array-%A_%a.err

k=$SLURM_ARRAY_TASK_ID

RESULTS=../results/K80/cuda-8.0.44

cd release

# gearshifft
if [ $k -eq 0 ]; then
    FCONFIG="../config/cufft_validate.conf"
    >$FCONFIG
    for r in `seq 1 250`; do
        # 1<<26
        echo 16777216 >> $FCONFIG
    done

    srun --gpufreq=2505:875 ./gearshifft_cufft -f ../config/cufft_validate.conf -r */float/*/Inplace_Real -o $RESULTS/validate_cufft_r2c_inplace.csv

    >$FCONFIG
    for r in `seq 1 250`; do
        echo 1024 >> $FCONFIG
    done

    srun --gpufreq=2505:875 ./gearshifft_cufft -f ../config/cufft_validate.conf -r */float/*/Inplace_Real -o $RESULTS/validate_cufft_r2c_inplace_small.csv
fi

# cufft standalone
if [ $k -eq 1 ]; then
    DCUFFT_STANDALONE="../validation/cufft_standalone"
    FCUFFT="$RESULTS/validate_cufft_standalone_r2c_inplace.csv"
    FCUFFT_SMALL="$RESULTS/validate_cufft_standalone_r2c_inplace_small.csv"
    >$FCUFFT
    >$FCUFFT_SMALL
    for r in `seq 1 250`; do
        srun --gpufreq=2505:875 $DCUFFT_STANDALONE/cufft_time_r2c 16777216 $((r-1)) >> $FCUFFT
    done
    for r in `seq 1 250`; do
        srun --gpufreq=2505:875 $DCUFFT_STANDALONE/cufft_time_r2c 1024 $((r-1)) >> $FCUFFT_SMALL
    done
fi
