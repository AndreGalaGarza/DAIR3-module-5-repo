# Makefile for Module 5-2 Notebook.ipynb
# The upload system may append suffixes like "(4)" to filenames. This Makefile
# does not rename files; it discovers the matching notebook at runtime.

.ONESHELL:
SHELL := /bin/sh

NOTEBOOK_BASE := Module 5-2 Notebook
EXECUTED_NOTEBOOK := executed_Module_5-2_Notebook.ipynb
PREPARED_NOTEBOOK := .prepared_Module_5-2_Notebook.ipynb

PYTHON ?= python3
VENV := .venv
USE_VENV ?= 1
PACKAGES := pandas matplotlib requests notebook nbconvert ipykernel

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
	notebook="$(NOTEBOOK_BASE).ipynb"
	if [ ! -f "$$notebook" ]; then
		notebook="$$(find . -maxdepth 1 -type f -name '$(NOTEBOOK_BASE)*.ipynb' | sort | head -n 1)"
	fi
	if [ -z "$$notebook" ] || [ ! -f "$$notebook" ]; then
		echo "Could not find $(NOTEBOOK_BASE).ipynb or an uploaded variant like $(NOTEBOOK_BASE)(4).ipynb" >&2
		exit 1
	fi
	echo "Using notebook: $$notebook"

	# Prepare a temporary execution copy. The provided notebook uses pd.read_csv,
	# so this adds the standard pandas alias only when that import is absent.
	$(PYTHON) -c 'import json, sys; from pathlib import Path; source_path = Path(sys.argv[1]); out_path = Path(sys.argv[2]); nb = json.loads(source_path.read_text(encoding="utf-8")); code = "\n".join("".join(cell.get("source", [])) for cell in nb.get("cells", []) if cell.get("cell_type") == "code"); needs_pd = "pd." in code and "import pandas as pd" not in code and "from pandas" not in code; nb.setdefault("cells", []).insert(0, {"cell_type": "code", "execution_count": None, "metadata": {}, "outputs": [], "source": ["import pandas as pd\n"]}) if needs_pd else None; out_path.write_text(json.dumps(nb, ensure_ascii=False, indent=1), encoding="utf-8")' "$$notebook" "$(PREPARED_NOTEBOOK)"

	if [ "$(USE_VENV)" = "1" ]; then
		jupyter="$(VENV)/bin/jupyter"
	else
		jupyter="jupyter"
	fi
	"$$jupyter" nbconvert \
		--to notebook \
		--execute "$(PREPARED_NOTEBOOK)" \
		--output "$(EXECUTED_NOTEBOOK)"

clean:
	rm -rf data
	rm -f "$(EXECUTED_NOTEBOOK)" "$(PREPARED_NOTEBOOK)"

veryclean: clean
	rm -rf "$(VENV)"
