##
# Variables
##

SHELL           := /bin/bash
PROJECT_NAME     = template-python-project
PYTHON_VERSION   = 3.9.16
PYTHON_MAIN_FILE = __main__.py
PYTHON_DIR       = source
VENV_NAME        = ${PROJECT_NAME}-${PYTHON_VERSION}

##
# tput Coloring
##

tput_yellow = $(shell tput setaf 3)
tput_end    = $(shell tput sgr0)

##
# Targets: Code Development in VSCode
##

.PHONY: macos-prepare
macos-prepare:
	@echo -e "\n$(tput_yellow)Upgrading homebrew and installing prerequisites$(tput_end)"
	brew upgrade
	brew install --quiet pyenv pyenv-virtualenv

.PHONY: venv-create
venv-create:
	@echo -e "\n$(tput_yellow)Installing python ${PYTHON_VERSION}$(tput_end)"
	pyenv install --skip-existing ${PYTHON_VERSION}
	@echo -e "\n$(tput_yellow)Creating python virtualenv (${VENV_NAME})$(tput_end)"
	pyenv virtualenv ${PYTHON_VERSION} --force ${VENV_NAME}
	$(MAKE) venv-install

.PHONY: venv-install
venv-install:
	$(MAKE) docker-build
	@echo -e "\n$(tput_yellow)Upgrading pip3 and installing packages$(tput_end)"
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	python3 -m pip install --upgrade pip && \
	pip3 install -r container/requirements.txt
	$(MAKE) venv-ls

.PHONY: venv-empty
venv-empty:
	@echo "$(tput_yellow)Removing pip3 installed packages on ${VENV_NAME}$(tput_end)"
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	pip3 uninstall --yes --requirement <(pip3 freeze)
	$(MAKE) venv-ls

.PHONY: venv-ls
venv-ls:
	@echo -e "\n$(tput_yellow)Displaying pyenvs $(tput_end)"
	pyenv versions
	@echo -e "\n$(tput_yellow)Displaying detected pyenv-virtualenvs $(tput_end)"
	pyenv virtualenvs
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	echo -e "\n$(tput_yellow)Displaying list of installed pip3 packages$(tput_end)" && \
	pip3 list

.PHONY: venv-rm
venv-rm:
	@echo -e "\n$(tput_yellow)Removing ${VENV_NAME}$(tput_end)"
	pyenv virtualenv-delete --force ${VENV_NAME}

##
# Targets: Code Execution via Docker
##

.PHONY: docker-build
docker-build:
	@echo -e "\n$(tput_yellow)Building local docker image($(PROJECT_NAME):latest)$(tput_end)"
	@docker build --tag $(PROJECT_NAME):latest --file container/Dockerfile .

.PHONY: docker-run
docker-run:
	@echo -e "\n$(tput_yellow)Running python project from inside docker container$(tput_end)"
	@docker run \
		--rm \
		--interactive \
		--volume $(shell pwd)/source/:/source/ \
		--workdir /source/ \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
		$(PROJECT_NAME):latest \
		python3 $(PYTHON_MAIN_FILE)

.PHONY: docker-exec
docker-exec:
	@echo -e "\n$(tput_yellow)Opening an interactive terminal with bash$(tput_end)"
	@docker run \
		--rm \
		--interactive \
		--tty \
		--volume $(shell pwd)/source/:/source/ \
		--workdir /source/ \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
		--entrypoint /bin/bash \
		$(PROJECT_NAME):latest \
