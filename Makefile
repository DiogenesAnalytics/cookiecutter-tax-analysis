.PHONY: all check-docker check-image-tests check-docker-image \
        check-workdir-tests check-deps-tests check-all build-tests \
        check-repo-safety check-git safe-repository print-config \
        lint tests pytest isort black flake8 mypy \
        install-act check-act run-act-tests shell clean

################################################################################
# GLOBALS
################################################################################

# Repository and Git info
CURRENTDIR := $(shell pwd)
SAFEGITDIR ?= $(CURRENTDIR)
REPO_NAME ?= $(shell basename -s .git `git config --get remote.origin.url`)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
GITRM := origin

# GitHub username extraction helper
get_github_user = $(shell \
    remote_url=$(1); \
    if echo $$remote_url | grep -q "git@github.com"; then \
	    dirname $$remote_url | sed 's/\:/ /g' | awk '{print $$2}' | \
	    cut -d/ -f1 | tr '[:upper:]' '[:lower:]'; \
    elif echo $$remote_url | grep -q "https://github.com"; then \
	    echo $$remote_url | sed 's/https:\/\/github.com\/\([^\/]*\)\/.*/\1/' | \
	    tr '[:upper:]' '[:lower:]'; \
    else \
        echo "Invalid remote URL: $$remote_url" && exit 1; \
    fi)

GITHUB_USER = $(call get_github_user,$(shell git config --get remote.origin.url))

# Docker-related vars
DCKRSRC = /usr/local/src/$(REPO_NAME)
DCKRTTY := $(if $(filter true,$(NOTTY)),-i,-it)
USE_VOL ?= true
USE_USR ?= true
TESTVOL = $(if $(filter true,$(USE_VOL)),-v ${CURRENTDIR}:${DCKRSRC},)
DCKRUSR = $(if $(filter true,$(USE_USR)),--user $(shell id -u):$(shell id -g),)
DCKRTST = docker run --rm ${DCKRUSR} ${TESTVOL} ${DCKRTTY}
DCKRTAG ?= $(GIT_BRANCH)
DCKR_PULL ?= true
DCKR_NOCACHE ?= false
DCKRIMG_BASE ?= ghcr.io/$(GITHUB_USER)/$(REPO_NAME):$(DCKRTAG)
DCKRIMG_TESTS ?= ${DCKRIMG_BASE}_testing

# Python test directories
PYTHON_TARGETS := tests

################################################################################
# DOCKER BUILD/PULL LOGIC
################################################################################

define DOCKER_PULL_OR_BUILD
	echo "➡️ Evaluating Docker image $1..." ; \
	if [ "$(DCKR_PULL)" = "true" ]; then \
	  echo "⬇️ Attempting to pull $1..." ; \
	  if docker pull $1 ; then \
	    echo "✅ Pulled $1 successfully." ; \
	  else \
	    echo "⚠️ Pull failed. Building Docker image $1..." ; \
	    docker build --build-arg DCKRSRC=${DCKRSRC} -t $1 . --load --target $2 $(if $(filter true,$(DCKR_NOCACHE)),--no-cache) ; \
	  fi ; \
	else \
	  echo "⚙️ DCKR_PULL=false, building Docker image $1..." ; \
	  docker build --build-arg DCKRSRC=${DCKRSRC} -t $1 . --load --target $2 $(if $(filter true,$(DCKR_NOCACHE)),--no-cache) ; \
	fi
endef

################################################################################
# CHECKS
################################################################################

check-docker:
	@ echo "Checking Docker..."
	@ if ! command -v docker >/dev/null 2>&1; then \
	  echo "❌ Docker not found. Install it first."; exit 1; fi
	@ if ! docker info >/dev/null 2>&1; then \
	  echo "❌ Docker daemon not running."; exit 1; fi
	@ echo "✅ Docker is installed and running."

check-image-tests: check-docker
	@ if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${DCKRIMG_TESTS}$$"; then \
	  echo "❌ Missing Docker image '${DCKRIMG_TESTS}'. Run 'make build-tests'."; exit 1; fi
	@ echo "✅ Test image '${DCKRIMG_TESTS}' found."

check-docker-image: check-docker check-image-tests

check-workdir-tests:
	@ echo "Checking container workdir..."
	@ container_workdir=$$(docker run --rm ${DCKRIMG_TESTS} pwd); \
	if [ "$$container_workdir" = "$(DCKRSRC)" ]; then \
	  echo "✅ Workdir matches $(DCKRSRC)."; \
	else \
	  echo "❌ Mismatch: $$container_workdir"; exit 1; fi

check-deps-tests: check-image-tests
	@ echo "Checking Python tooling inside test image..."
	@ ${DCKRTST} ${DCKRIMG_TESTS} sh -c "\
	  command -v pytest && command -v isort && command -v flake8 && \
	  command -v mypy && command -v black && echo '✅ All tools present.'"

check-all: check-docker-image check-workdir-tests check-deps-tests
	@ echo ""
	@ echo "🧩  All system checks passed successfully."

################################################################################
# DOCKER BUILD
################################################################################

build-tests:
	@ echo "🛠️ Building test Docker image..."
	@ $(call DOCKER_PULL_OR_BUILD,${DCKRIMG_TESTS},testing)

################################################################################
# REPO SAFETY / GIT
################################################################################

check-git:
	@ command -v git >/dev/null 2>&1 || { echo "❌ Git not installed."; exit 1; }

check-repo-safety: check-git
	@ git config --global --get-all safe.directory | grep -q "$(SAFEGITDIR)" \
	  && echo "✅ Repo marked safe." \
	  || echo "⚠️ Run 'make safe-repository' to mark it safe."

safe-repository: check-git
	@ echo "Marking repo safe: $(SAFEGITDIR)"
	@ git config --global --add safe.directory $(SAFEGITDIR)

print-config:
	@ echo "GitHub User:  $(GITHUB_USER)"
	@ echo "Repository:   $(REPO_NAME)"
	@ echo "Branch:       $(GIT_BRANCH)"
	@ echo "Docker Src:   $(DCKRSRC)"
	@ echo "Docker Image: $(DCKRIMG_TESTS)"

################################################################################
# LINTING / TESTING
################################################################################

lint: isort black flake8 mypy

tests: pytest lint

pytest:
	@echo ""
	@echo "🧪  Running tests with pytest..."
	@echo "───────────────────────────────────────────────"
	@echo "🧩  Container image: ${DCKRIMG_TESTS}"
	@echo "📁  Working directory: ${PWD}"
	@echo "───────────────────────────────────────────────"
	@ ${DCKRTST} ${DCKRIMG_TESTS} pytest
	@echo ""
	@echo "✅  Pytest run complete!"
	@echo ""

isort:
	@echo "📑 Running isort..."
	@${DCKRTST} ${DCKRIMG_TESTS} isort $(PYTHON_TARGETS)

black:
	@echo "🎨 Running black..."
	@${DCKRTST} ${DCKRIMG_TESTS} black --line-length 88 $(PYTHON_TARGETS)

flake8:
	@echo "🔍 Running flake8..."
	@${DCKRTST} ${DCKRIMG_TESTS} flake8 --config=tests/.flake8 $(PYTHON_TARGETS)

mypy:
	@echo "🔎 Running mypy..."
	@${DCKRTST} ${DCKRIMG_TESTS} mypy --strict --warn-unreachable --pretty \
	--show-column-numbers --show-error-context --ignore-missing-imports $(PYTHON_TARGETS)

################################################################################
# ACT / CI LOCAL TESTING
################################################################################

install-act:
	@ echo "Installing act..."
	@ curl --proto '=https' --tlsv1.2 -sSf \
	  "https://raw.githubusercontent.com/nektos/act/master/install.sh" | \
	  sudo bash -s -- -b ./bin && \
	sudo mv ./bin/act /usr/local/bin/

check-act:
	@ command -v act >/dev/null 2>&1 \
		&& echo "✅ act installed." \
		|| { echo "❌ act missing. Run 'make install-act'."; exit 1; }

run-act-tests: check-act
	@ echo "Running GitHub Actions locally..."
	act -j run-tests $(ARGS)

################################################################################
# UTILITIES
################################################################################

shell:
	@${DCKRTST} ${DCKRIMG_TESTS} bash || true
