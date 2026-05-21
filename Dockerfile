# Container for running the Module 5-2 Jupyter notebook through Make
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# make is needed because the project workflow is defined in the Makefile.
RUN apt-get update \
    && apt-get install -y --no-install-recommends make \
    && rm -rf /var/lib/apt/lists/*

# Copy the whole project so this works both with normal filenames and with
# ChatGPT upload suffixes like Makefile(1) or Module 5-2 Notebook(4).ipynb.
COPY . .

# Install the libraries used by the notebook plus Jupyter execution tooling.
RUN python -m pip install --upgrade pip \
    && python -m pip install pandas matplotlib requests notebook nbconvert ipykernel

# Prefer a normal Makefile, but fall back to an uploaded variant such as Makefile(1).
CMD ["sh", "-c", "set -eu; if [ ! -f Makefile ]; then mf=$(find . -maxdepth 1 -type f -name 'Makefile*' | sort | head -n 1); if [ -z \"$mf\" ] || [ ! -f \"$mf\" ]; then echo 'No Makefile found' >&2; exit 1; fi; cp \"$mf\" Makefile; fi; make run USE_VENV=0"]
