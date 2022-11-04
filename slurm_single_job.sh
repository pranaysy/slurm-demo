#!/bin/bash
#SBATCH --job-name=singlerun                        # Name this job
#SBATCH --output=slurm_%u_%x_%j_stdout.log          # Name of log for STDOUT
#SBATCH --error=slurm_%u_%x_%j_stderr.log           # Name of log for STDERR
#SBATCH --verbose                                   # Be verbose wherever possible
#SBATCH --ntasks=1                                  # One task only
#SBATCH --cpus-per-task=1                           # One 'thread'/CPU worker per task
#SBATCH --mincpus=1                                 # Request one CPU only
#SBATCH --mem-per-cpu=500M                          # Request 500MB RAM per CPU
#SBATCH --time=00:00:30                             # Request resources for 30sec
#SBATCH --mail-type=end,fail                        # Email on job completion / failure
#SBATCH --mail-user=                                # Enter your email here

# Set up environment
WORKDIR="/home/py01/slurmtest"

# Path to script
SCRIPT="$WORKDIR/script.py"

# Activate conda environment (or some other module that manages environment)
conda activate harold

echo "JOB $SLURM_JOB_ID STARTING"

i=1 # Argument to python script
srun --nodes=1 --ntasks=1 --cpus-per-task=1 --exclusive "python" $SCRIPT $i 

echo "JOB $SLURM_JOB_ID COMPLETED"
