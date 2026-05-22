# Container for running analyses/Module_5-2_Notebook.ipynb through Make
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# make is needed because the project workflow is defined in the Makefile.
RUN apt-get update \
    && apt-get install -y --no-install-recommends make \
    && rm -rf /var/lib/apt/lists/*

# Copy the full repository, including analyses/, data/, and the Makefile.
COPY . .

# Install the libraries used by the notebook plus Jupyter execution tooling.
RUN python -m pip install --upgrade pip \
    && python -m pip install pandas matplotlib notebook nbconvert ipykernel

# Execute the notebook at analyses/Module_5-2_Notebook.ipynb.
CMD ["make", "run", "USE_VENV=0"]
