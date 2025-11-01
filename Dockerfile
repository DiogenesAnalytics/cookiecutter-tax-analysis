FROM python:3.11-slim AS testing

# define the build arguments
ARG DCKRSRC

# Install only git, which cookiecutter or hooks might need
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    make \
 && rm -rf /var/lib/apt/lists/*

WORKDIR ${DCKRSRC}

COPY . .

RUN pip install -r tests/requirements.txt
