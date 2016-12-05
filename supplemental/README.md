# Software versions

A documentation on how the libraries were build can be found in Versions.md .

# SLURM Job Scripts

These scripts are executed on a HPC cluster as SLURM job, see https://slurm.schedmd.com/ .

# Validation

gearshifft runtime impact is validated by a cuFFT standalone implementation. The source can be found in `cufft_standalone/`. Use `cmake` to generate the Makefile. The corresponding job script `batch_validate_cufft_k80.sh` was executed in the root directory of gearshifft.
