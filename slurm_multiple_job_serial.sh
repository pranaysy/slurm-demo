#!/bin/bash
#SBATCH --job-name=multiplerun-serial               # Name this job
#SBATCH --output=slurm_%u_%x_%j_stdout.log          # Name of log for STDOUT
#SBATCH --error=slurm_%u_%x_%j_stderr.log           # Name of log for STDERR
#SBATCH --verbose                                   # Be verbose wherever possible
#SBATCH --ntasks=9                                  # 9 tasks in total
#SBATCH --cpus-per-task=1                           # One 'thread'/CPU worker per task
#SBATCH --mincpus=9                                 # Request 9 CPUs
#SBATCH --mem-per-cpu=1G                            # Request 1GB RAM per CPU
#SBATCH --time=00:01:00                             # Request resources for 30sec
#SBATCH --mail-type=end,fail                        # Email on job completion / failure
#SBATCH --mail-user=                                # Enter your email here

# Set up environment
WORKDIR="/home/py01/slurmtest"

# Path to script
SCRIPT="$WORKDIR/script.py"

# Activate conda environment (or some other module that manages environment)
conda activate harold

echo "JOB $SLURM_JOB_ID STARTING"

# Loop over range of arguments to script
for i in {1..9}
do
    echo "TASK $i STARTING"
    
    # Run task on node
    srun --nodes=1 --ntasks=1 --cpus-per-task=1 --exclusive "python" $SCRIPT $i
    
    echo "TASK $i COMPLETED"
done

echo "JOB $SLURM_JOB_ID COMPLETED"
