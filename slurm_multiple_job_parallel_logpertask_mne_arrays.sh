#!/bin/bash
#SBATCH --job-name=multiplerun-parallel-logpertask-mne-arrays   # Name this job
#SBATCH --output=slurm_%u_%x_%j_stdout.log          # Name of log for STDOUT
#SBATCH --error=slurm_%u_%x_%j_stderr.log           # Name of log for STDERR
#SBATCH --array=1-9                                 # Specify range of int for job array
#SBATCH --verbose                                   # Be verbose wherever possible
#SBATCH --ntasks=9                                  # 9 tasks in total
#SBATCH --cpus-per-task=1                           # One 'thread'/CPU worker per task
#SBATCH --mincpus=9                                 # Request 9 CPUs
#SBATCH --mem-per-cpu=1G                            # Request 1GB RAM per CPU
#SBATCH --time=00:01:00                             # Request resources for 1min
#SBATCH --mail-type=end,fail                        # Email on job completion / failure
#SBATCH --mail-user=                                # Enter your email here

# Set up environment
WORKDIR="/home/py01/slurmtest"

# Path to script
SCRIPT="$WORKDIR/mne_demo.py"

# Make folders for logging
LOGDIR="$WORKDIR/logs/${SLURM_JOB_NAME}_${SLURM_ARRAY_JOB_ID}"
mkdir -p "$LOGDIR/tasks"

# Activate conda environment (or some other module that manages environment)
conda activate mne1.0.3

echo "JOB $SLURM_JOB_ID STARTING"

# Loop over range of arguments to script
echo "TASK $SLURM_ARRAY_TASK_ID STARTING"

# Run task on node
srun --nodes=1 --ntasks=1 --cpus-per-task=1 \
    --output="$LOGDIR/tasks/slurm_%u_%x_%A_%a_%N_stdout_task_$SLURM_ARRAY_TASK_ID.log" \
    --error="$LOGDIR/tasks/slurm_%u_%x_%A_%a_%N_stderr_task_$SLURM_ARRAY_TASK_ID.log" \
    --exclusive "python" $SCRIPT $SLURM_ARRAY_TASK_ID

echo "TASK $SLURM_ARRAY_TASK_ID PUSHED TO BACKGROUND"

echo "JOB $SLURM_JOB_ID COMPLETED"


