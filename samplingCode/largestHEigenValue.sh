#!/bin/bash
#SBATCH --account=jamming
#SBATCH --job-name=HN6
#SBATCH --output=/home/jhass2/jamming/JacobData/logs/EigenValues/%A.%a.out
#SBATCH --error=/home/jhass2/jamming/JacobData/logs/EigenValues/%A.%a.err
#SBATCH --partition=preempt
#SBATCH --ntasks=1
#SBATCH --array=0-9999
#SBATCH --time=0-06:00:00
#SBATCH --requeue

N=6
NUMSAMPLES=100
ENSEMBLE="ConstantVariance"
SEED=$(od -vAn -N4 -tu4 < /dev/urandom)
DIRECTORYNAME="/projects/jamming/shared/HEigenValues/$ENSEMBLE/$N/$SLURM_ARRAY_TASK_ID"
mkdir -p $DIRECTORYNAME
matlab -nodisplay -nodesktop -nosplash -batch "largestHEigenValue('$DIRECTORYNAME', '$SLURM_ARRAY_TASK_ID', '$SEED', '$N', '$NUMSAMPLES', '$ENSEMBLE'); exit"
