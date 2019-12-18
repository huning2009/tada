# Makefile for "Topology and data analysis" project
#
# Copyright (C) 2019 Simon Dobson
#
# This file is part of tada, Notes for a nbook on toplogy and data analysis.
#
# tada is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# tada is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with tada. If not, see <http://www.gnu.org/licenses/gpl.html>.

# ----- Sources -----

# Notebooks
NOTEBOOKS = \
	index.pynb \
	simplicial-topology.ipynb \
	quotient-groups.ipynb

SOURCES_EXTRA = \
	README.rst \
	LICENSE \
	HISTORY


# ----- Tools -----

# Base commands
PYTHON = python3
IPYTHON = ipython
JUPYTER = jupyter
PIP = pip
VIRTUALENV = python3 -m venv
ACTIVATE = . $(VENV)/bin/activate
TR = tr
CAT = cat
SED = sed
RM = rm -fr
CP = cp
CHDIR = cd
ZIP = zip -r
PANDOC = pandoc

# Root directory
ROOT = $(shell pwd)

# Requirements for running the book and for the 
VENV = venv3
REQUIREMENTS = requirements.txt
PY_REQUIREMENTS = $(shell $(CAT) $(REQUIREMENTS) | $(SED) 's/.*/"&"/g' | $(PASTE) -s -d, -)

# Constructed commands
RUN_SERVER = PYTHONPATH=. $(JUPYTER) notebook --port 1626
NON_REQUIREMENTS = $(SED) $(patsubst %, -e '/^%*/d', $(PY_NON_REQUIREMENTS))


# ----- Top-level targets -----

# Default prints a help message
help:
	@make usage

# Run the notebook server
live: env
	$(ACTIVATE)  && $(RUN_SERVER)

# Build a development venv from the known-good requirements in the repo
.PHONY: env
env: $(VENV)

$(VENV):
	$(VIRTUALENV) $(VENV)
	$(CP) $(REQUIREMENTS) $(VENV)/requirements.txt
	$(ACTIVATE) && $(CHDIR) $(VENV) && $(PIP) install -r requirements.txt

# Clean up everything, including the computational environment (which is expensive to rebuild)
clean: clean
	$(RM) $(VENV)


# ----- Usage -----

define HELP_MESSAGE
Editing:
   make live         run the notebook server

Maintenance:
   make env          create a known-good development virtual environment
   make newenv       update the development venv's requirements
   make clean        clean-up the build

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
