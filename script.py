#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  2 17:32:43 2022

@author: py01
"""
# Built-in module for parsing command line arguments
from sys import argv

# Stuff rest of the script does
from time import sleep  # Do nothing
from os import getpid, getenv  # Identify processes and env variables
import psutil  # More process info / CPU number
from datetime import datetime  # Precise timings
from pathlib import Path  # IO path management

# This is the working directory, can be inherited using getenv/argv
basedir = Path("/home/py01/slurmtest/data")

# Print input argument, PID, CPU number and current time
print(
    f"Argument: {argv[1]} | PID: {getpid()} | CPU: {psutil.Process().cpu_num()}\t>>> Start: {datetime.now().time()} ->",
    end=" ",
)

# Do nothing for 5 sec
sleep(5)

# Write to a file for no reason
file = basedir / argv[1] / "dat"
file.write_text(str(file))

# Print current time, 5 sec should have elapsed
print(f"End: {datetime.now().time()}\t OK")

# Loop over environment variables of interest, fetch using getenv and print
strings = []
for var in [
    "SLURM_JOB_ID",
    "SLURM_JOB_NAME",
    "SLURM_PROCID",
    "SLURM_TASK_PID",
]:
    val = getenv(var)
    if not val:  # If variable not present, use empty string
        val = ""
    print(f"{var}: {val}", end="\t")

print("\n")

# Throw an example error visible in STDERR
if int(argv[1]) % 2 == 0:
    raise ValueError("Even argument encountered!")
