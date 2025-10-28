# === Base image: Jupyter SciPy notebook (Python, NumPy, pandas, etc.) ===
FROM quay.io/jupyter/scipy-notebook:lab-4.1.5 AS jupyter

# === Install additional conda packages ===
RUN mamba install --yes \
    'jupyterlab-spellchecker=0.8.4' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# === Install Python packages from requirements.txt if non-empty ===
RUN if [ -s requirements.txt ]; then \
        pip install --no-cache-dir -r requirements.txt; \
    else \
        echo "Skipping pip install: requirements.txt is empty or missing."; \
    fi

# === Fix permissions again ===
RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# === Default command to start Jupyter Lab ===
CMD ["start-notebook.sh"]
