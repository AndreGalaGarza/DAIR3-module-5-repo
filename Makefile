# Makefile for analyses/Module_5-2_Notebook.ipynb
# Run this from the base repository folder.

.ONESHELL:
SHELL := /bin/sh

NOTEBOOK := analyses/Module_5-2_Notebook.ipynb
NOTEBOOK_DIR := analyses
EXECUTED_NOTEBOOK := executed_Module_5-2_Notebook.ipynb
DATA_DIR := data
RESULTS_DIR := results

PYTHON ?= python3
VENV := .venv
USE_VENV ?= 1
PACKAGES := pandas matplotlib notebook nbconvert ipykernel

.PHONY: all setup run clean veryclean

all: run

setup:
	set -eu
	if [ "$(USE_VENV)" = "1" ]; then \
		$(PYTHON) -m venv "$(VENV)"; \
		"$(VENV)/bin/pip" install --upgrade pip; \
		"$(VENV)/bin/pip" install $(PACKAGES); \
	else \
		$(PYTHON) -m pip install --upgrade pip; \
		$(PYTHON) -m pip install $(PACKAGES); \
	fi

run: setup
	set -eu
	if [ ! -f "$(NOTEBOOK)" ]; then
		echo "Could not find $(NOTEBOOK). Make sure the notebook is named Module_5-2_Notebook.ipynb and is inside analyses/." >&2
		exit 1
	fi
	if [ ! -d "$(DATA_DIR)" ]; then
		echo "Could not find $(DATA_DIR)/. Add the required data files to the data folder before running the notebook." >&2
		exit 1
	fi
	mkdir -p "$(RESULTS_DIR)"
	repo_root="$$(pwd)"
	if [ "$(USE_VENV)" = "1" ]; then
		jupyter="$$repo_root/$(VENV)/bin/jupyter"
	else
		jupyter="$$(command -v jupyter)"
	fi
	cd "$(NOTEBOOK_DIR)"
	"$$jupyter" nbconvert \
		--to notebook \
		--execute "Module_5-2_Notebook.ipynb" \
		--output "$(EXECUTED_NOTEBOOK)"

clean:
	rm -f "$(NOTEBOOK_DIR)/$(EXECUTED_NOTEBOOK)"
	rm -rf "$(RESULTS_DIR)"

veryclean: clean
	rm -rf "$(VENV)"
