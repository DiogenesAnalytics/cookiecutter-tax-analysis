# Cookiecutter Tax Analysis

_A reproducible and containerized project structure for performing, documenting, and reporting tax calculations with Jupyter notebooks._

---

## Overview

This cookiecutter template provides a standardized yet flexible structure for small- to medium-scale tax analysis projects.  
It builds on the [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/) layout but simplifies it for use in financial, accounting, or tax computation contexts.

The template supports:
- Reproducible environments via Docker (using the `jupyter/scipy-notebook` base image)
- Organized data directories (`raw`, `interim`, `processed`)
- Integrated reporting workflows (LaTeX, PDF, HTML)
- Optional Jupyter notebook automation via Makefile commands

---

## Requirements

To use this template, you’ll need:

- Python 3.8+
- [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/) >= 1.7.0
- [Docker](https://www.docker.com/) (recommended for running Jupyter notebooks)

You can install cookiecutter via pip or conda:

```bash
pip install cookiecutter
```

or

```bash
conda config --add channels conda-forge
conda install cookiecutter
```

---

## Usage

To generate a new tax analysis project, run:

```bash
cookiecutter https://github.com/<your-github-username>/cookiecutter-tax-analysis
```

You’ll be prompted for basic project information such as:

```
project_name [Tax Analysis]:
repo_name [tax_analysis]:
author_name [Your Name (optional)]:
description [A short description of the tax analysis project]:
```

After generation, navigate into the created directory:

```bash
cd tax_analysis
```

---

## Project Structure

The generated project will look like this:

```
├── data
│   ├── interim
│   ├── processed
│   └── raw
│
├── notebooks
│   └── template_report.ipynb
│
├── references
│   └── cited_report.bib
│
├── reports
│   └── templates
│       └── cited_report
│           ├── conf.json
│           └── index.tex.j2
│
├── requirements.txt
├── Makefile
├── Dockerfile
├── README.md
└── src
    ├── __init__.py
    ├── jupyter_report.py
    └── web_images.py
```

---

## Development Environment

The generated project includes a `Dockerfile` based on the `jupyter/scipy-notebook` image.  
You can launch the environment by running:

```bash
make
```

or equivalently:

```bash
make jupyter
```

This will start a Jupyter Lab session with the mounted project directory.  
You can view the automatically generated access URL by checking container logs.

---

## Included Makefile Commands

| Command | Description |
|----------|-------------|
| `make` / `make all` | Alias for `make jupyter` |
| `make jupyter` | Launch the Jupyter notebook Docker container |
| `make address` | Get the container address and port |
| `make containers` | Start all defined Docker containers |
| `make stop-containers` | Stop all running containers |
| `make restart-containers` | Restart containers |
| `make clear-nb` | Clear Jupyter notebook output |
| `make clean` | Run all cleaning commands |

---

## Notes

- The default Docker environment already includes `numpy`, `pandas`, `scipy`, `matplotlib`, `scikit-learn`, `seaborn`, and JupyterLab extensions.
- If your analysis requires machine learning or deep learning, you can install `tensorflow`, `torch`, or `keras` by adding them to `requirements.txt`.
- To pin versions for reproducibility, regenerate your `requirements.txt` using:
  ```bash
  pip freeze > requirements.txt
  ```

---

## Contributing

Contributions, bug reports, and feature suggestions are welcome!  
Feel free to open a pull request or issue on GitHub.

---

## License

This project is distributed under the MIT License.  
See the `LICENSE` file for details.

---

<p align="center"><small>
Based on the <a href="https://drivendata.github.io/cookiecutter-data-science/">Cookiecutter Data Science</a> project template.<br>
#cookiecutterdatascience #taxanalysis
</small></p>
