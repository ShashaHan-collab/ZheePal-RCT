# ZheePal-RCT

This repository contains the statistical analysis and data visualization code and the agentic system architecture associated with the research project:

> An agentic AI architecture drives population behavior change for cognitive and mental health


# Prerequisites
## Prerequisite software 
* Python (version 3.7 or higher)
* R (version 4.0 or higher)
## Prerequisite Python packages
* transformers
* torch
* pandas
* numpy
* scipy
* umap-learn
* scikit-learn
* datasets
* tqdm
* *(All other modules used, such as `itertools`, are part of the Python Standard Library.)*

– A list of Python dependencies for `System architecture/` can be found in the `System architecture/requirements.txt` file.

## Prerequisite R packages
* dplyr
* ggbeeswarm
* glue
* tibble
* ggplot2
* cowplot
* grid
* binom
* ggpattern


# Repository Contents
| Folder / File | Description |
|---|---|
| `Source data/` | All data required to reproduce the main figures listed below.|
| `Source plot/` | Plotting code for generating the figures in the Article. |
| `System architecture/` | Code architecture for the integrated multi‑agent system that executes the collaborative assessment and guidance logic. Detailed description is provided in the `System architecture/README.md` file. |


# Usage
## Data Visualization
Use the data in `Source data/` with the plotting code in `Source plot/` to regenerate Figures 2-5.

## System Architecture
The `System architecture/`  directory contains the code architecture for an integrated multi-agent system that executes the collaborative diagnostic guidance logic. The architecture is built around a state-based dialogue orchestrator that conducts the diagnosis and guidance process through a collaborative conversational context, supported by three specialized modules: a risk assessment agent, a personalization engine, and a dialogue-monitor agent (Extended Data Fig. 1 in Article). 

Researchers can reference this structure to understand the collaborative diagnostic guidance logic and to develop equivalent systems via the community-engaged codesign approach described in the Article.



