# Installing Machine Learning Libraries on NCAR HPC Systems

This repository contains convenience scripts for installing various popular machine learning libraries on NCAR HPC systems, including Derecho and Casper. Special attention will be paid towards ensuring compatibility with GPU hardware. These installs primarily utilize specific combinations of pre-built packages available via `conda` or `pip`. Currently supported packages are listed below:

* [TensorFlow v2.11-2.15](tensorflow)
* [PyTorch v1.13.1-2.2.0](pytorch)

All installations will produce an associated YAML file which describes the software environment as installed. This file can be shared with colleagues or archived alongside scientific results to support reproducibility efforts.

A future goal of this offering is to also offer pre-built virtual environments for all HPC users at NCAR, accessible via `conda activate ...`. More information about the availability of software this way will be released at a later date.

Contributions are welcome towards identifying any issues or improving performance capabilities of these installations. Please open an issue or submit a Pull Request to support these offerings or reach out to [cislhelp@ucar.edu](cislhelp@ucar.edu) for any other questions.
