#!/bin/bash
#SBATCH --account=jamming
#SBATCH --job-name=EigenValues
#SBATCH --output=/home/jhass2/jamming/JacobData/logs/EigenValues/%A.%a.out
#SBATCH --error=/home/jhass2/jamming/JacobData/logs/EigenValues/%A.%a.err
#SBATCH --partition=preempt
#SBATCH --ntasks=1
#SBATCH --array=0-9999
#SBATCH --time=0-06:00:00
#SBATCH --requeue

N=3
NUMSAMPLES=100
ENSEMBLE="ConstantVariance"
SEED=$(od -vAn -N4 -tu4 < /dev/urandom)
DIRECTORYNAME="/projects/jamming/shared/EigenValues/$ENSEMBLE/$N/$SLURM_ARRAY_TASK_ID"
mkdir -p $DIRECTORYNAME
matlab -nodisplay -nodesktop -nosplash -batch "largestEigenValue('$DIRECTORYNAME', '$SLURM_ARRAY_TASK_ID', '$SEED', '$N', '$NUMSAMPLES', '$ENSEMBLE'); exit"
