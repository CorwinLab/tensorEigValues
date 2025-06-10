#!/bin/bash
#SBATCH --account=jamming
#SBATCH --job-name=N10Eigen
#SBATCH --output=/home/jhass2/jamming/JacobData/logs/N10Metropolis/matlab-job.out
#SBATCH --error=/home/jhass2/jamming/JacobData/logs/N10Metropolis/matlab-job.err 
#SBATCH --partition=computelong
#SBATCH --time=14-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64

matlab -nodisplay -nodesktop -nosplash -r "run('/home/jhass2/Code/tensorEigValues/metropolisEnsemble/testMetropolisRange.m'); exit;"
