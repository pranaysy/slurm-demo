#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This script takes an integer argument (as a string) and generates fake data using MNE.
Specifically, the script mimics a 'per subject-datafile' analysis worfklow and creates
a MNE Raw object, a plot of synthetic raw data as well as a log file in a nested folder.

@author: py01
"""
# Built-in module for parsing command line arguments
from sys import argv

# Stuff rest of the script does
import mne
import numpy as np
from pathlib import Path

# Set MNE's log level to DEBUG
mne.set_log_level(verbose="DEBUG")

# This is the working directory, can be inherited using getenv/argv
basedir = Path("/home/py01/slurmtest/data")

# We'll use the input argument *also* as for shifting the phase of sine wave
# Just for kicks
try:
    scalar = int(argv[1])  # Only do this if the argument is an integer
except:
    scalar = 0  # Else throw an error

# Create a new folder for storing outputs
datadir = basedir / argv[1] / "synthetic"
datadir.mkdir(exist_ok=True)

# Logging to file

# Option A: Just enough
mne.set_log_file(
    fname=str(datadir / f"{argv[1]}_mne_out.log"),
    output_format="%(asctime)s [%(process)d][%(levelname)s]: %(message)s",
)

# Option B: A bit more
# mne.set_log_file(
#     fname=str(datadir / f"{argv[1]}_mne_out.log"),
#     output_format="%(asctime)s [%(process)d][%(levelname)s]: %(message)s\t(%(module)s:L%(lineno)d)",
# )

# Option C: Definitely too much
# mne.set_log_file(
#     fname=str(datadir / f"{argv[1]}_mne_out.log"),
#     output_format="%(asctime)s [%(process)d][%(levelname)s]: %(message)s\t(%(pathname)s:L%(lineno)d)",
#)

# Use the 'matplotlib' backend for plotting raw data since headless/etc.
mne.viz.set_browser_backend("matplotlib")

# Create fake data
sampling_freq = 200  # in Hertz
times = np.linspace(0, 1, sampling_freq, endpoint=False)
sine = np.sin(20 * np.pi * times)
shifted_sine = np.sin(20 * np.pi * times - scalar * np.pi / 2)
cosine = np.cos(10 * np.pi * times)
data = np.array([sine, shifted_sine, cosine])
print(data.shape)

# Create Info object
info = mne.create_info(
    ch_names=["10 Hz sine", "10Hz shifted sine", "5 Hz cosine"],
    ch_types=["misc"] * 3,
    sfreq=sampling_freq,
)
# print(info)

# Create Raw object
simulated_raw = mne.io.RawArray(data, info)
print(simulated_raw)

# Save Raw object to disk
simulated_raw.save(str(datadir / f"{argv[1]}_data-raw.fif"), overwrite=True)

# Plot Raw object and save to disk
fig = simulated_raw.plot(show_scrollbars=False, show_scalebars=False)
fig.savefig(datadir / f"{argv[1]}_data_plot.png", dpi=150)
