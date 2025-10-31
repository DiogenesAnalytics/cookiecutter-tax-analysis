FROM python:3.11-slim AS testing

# Install only git, which cookiecutter or hooks might need
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    make \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/cookiecutter-tax-analysis

COPY . .

RUN pip install -r tests/requirements.txt
