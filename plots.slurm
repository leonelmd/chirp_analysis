#!/bin/bash
#SBATCH --job-name=chirp_plots
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=job-chirp_analysis_%A.out
#SBATCH --error=job-chirp_analysis_%A.err
#SBATCH --mem-per-cpu=8G

julia src/plots.jl