##
# Variables
##

SHELL           := /bin/bash
PROJECT_NAME     = template-python-project
PYTHON_VERSION   = 3.9.16
PYTHON_MAIN_FILE = __main__.py
VENV_NAME        = ${PROJECT_NAME}-${PYTHON_VERSION}

##
# tput Coloring
##

tput_yellow = $(shell tput setaf 3)
tput_end    = $(shell tput sgr0)

##
# Targets: Code Development in VSCode
##

macos-prepare:
	@echo -e "\n$(tput_yellow)Upgrading homebrew and installing prerequisites$(tput_end)"
	brew upgrade
	brew install --quiet pyenv pyenv-virtualenv

venv-create:
	@echo -e "\n$(tput_yellow)Installing python ${PYTHON_VERSION}$(tput_end)"
	pyenv install --skip-existing ${PYTHON_VERSION}
	@echo -e "\n$(tput_yellow)Creating python virtualenv (${VENV_NAME})$(tput_end)"
	pyenv virtualenv ${PYTHON_VERSION} --force ${VENV_NAME}
	$(MAKE) venv-install

venv-install:
	$(MAKE) docker-build
	@echo -e "\n$(tput_yellow)Upgrading pip3 and installing packages$(tput_end)"
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	python3 -m pip install --upgrade pip && \
	pip3 install -r container/requirements.txt
	$(MAKE) venv-ls

venv-empty:
	@echo "$(tput_yellow)Removing pip3 installed packages on ${VENV_NAME}$(tput_end)"
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	pip3 uninstall --yes --requirement <(pip3 freeze)
	$(MAKE) venv-ls

venv-ls:
	@echo -e "\n$(tput_yellow)Displaying pyenvs $(tput_end)"
	pyenv versions
	@echo -e "\n$(tput_yellow)Displaying detected pyenv-virtualenvs $(tput_end)"
	pyenv virtualenvs
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	echo -e "\n$(tput_yellow)Displaying list of installed pip3 packages$(tput_end)" && \
	pip3 list

venv-rm:
	@echo -e "\n$(tput_yellow)Removing ${VENV_NAME}$(tput_end)"
	pyenv virtualenv-delete --force ${VENV_NAME}

##
# Targets: Code Execution via Docker
##

docker-build:
	@echo -e "\n$(tput_yellow)Building local docker image($(PROJECT_NAME):latest)$(tput_end)"
	docker build --tag $(PROJECT_NAME):latest --file container/Dockerfile .

docker-run:
	@echo -e "\n$(tput_yellow)Running python project from inside docker container$(tput_end)"
	docker run \
		--rm \
		--interactive \
		--volume $(shell pwd)/source/:/source/ \
		--workdir /source/ \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
		--volume $(shell pwd)/source/:/source/ \
		$(PROJECT_NAME):latest \
		python3 $(PYTHON_MAIN_FILE)
