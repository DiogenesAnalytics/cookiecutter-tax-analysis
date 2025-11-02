# {{cookiecutter.project_name}}
{{cookiecutter.description}}

## Project Organization

    ├── Makefile           <- Makefile for running Jupyter notebooks (see commands below).
    ├── README.md          <- The top-level README for anyone running these notebooks.
    ├── data
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets.
    │   └── raw            <- The original, immutable data dump.
    │
    ├── notebooks          <- Jupyter notebooks relevant for tax analysis.   
    |
    ├── references         <- References for generated reports.
    │
    ├── reports            <- Generated reports as HTML, PDF, LaTeX, etc.
    │
    ├── requirements.txt   <- The requirements file for reproducing the analysis environment.
    │
    └── src                <- Local Python source code used in notebooks.

## Make
Here we will document the different `make` commands defined in the `Makefile`.
All *commands* (excluding the `all` command which is simply executed by
running `make`) are executed by the following format: `make [COMMAND]`. To see
the *contents* of a command that will be executed upon invocation of the
command, simply run `make -n [COMMAND]`.

### Commands
+ `all`: (*aka*: `make`) alias for `jupyter` command
+ `jupyter`: launches the Jupyter notebook development Docker image
+ `pause`: pause PSECS (to pause between commands)
+ `address`: get Docker container address/port
+ `containers`: launch all Docker containers
+ `list-containers`: list all running containers
+ `stop-containers`: simply stops all running Docker containers
+ `restart-containers`: restart all containers
+ `clear-nb`: simply clears Jupyter notebook output
+ `clean`: combines all clearing commands into one

Click the link (should look similar to:
http://127.0.0.1:RANDOM_PORT/lab?token=LONG_ALPHANUMERIC_STRING) which will
`automatically` log you in and allow you to start running the *notebooks*.
