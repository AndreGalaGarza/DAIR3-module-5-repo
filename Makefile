# Makefile for Module 5-2 Notebook.ipynb

NOTEBOOK := Module 5-2 Notebook.ipynb
UPLOADED_NOTEBOOK := Module 5-2 Notebook(2).ipynb
EXECUTED_NOTEBOOK := executed_Module_5-2_Notebook.ipynb

PYTHON := python3
VENV := .venv
PIP := $(VENV)/bin/pip
JUPYTER := $(VENV)/bin/jupyter

.PHONY: all rename setup run clean veryclean

all: run

rename:
	@if [ -f "$(UPLOADED_NOTEBOOK)" ] && [ ! -f "$(NOTEBOOK)" ]; then \
		mv "$(UPLOADED_NOTEBOOK)" "$(NOTEBOOK)"; \
		echo "Renamed $(UPLOADED_NOTEBOOK) to $(NOTEBOOK)"; \
	fi

setup:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install pandas matplotlib requests notebook nbconvert ipykernel

run: rename setup
	$(JUPYTER) nbconvert \
		--to notebook \
		--execute "$(NOTEBOOK)" \
		--output "$(EXECUTED_NOTEBOOK)"

clean:
	rm -rf data
	rm -f "$(EXECUTED_NOTEBOOK)"

veryclean: clean
	rm -rf $(VENV)
