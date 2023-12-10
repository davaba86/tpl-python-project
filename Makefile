##
# Variables
##

SHELL           := /bin/zsh
PROJECT_NAME     = template-project-name
PYTHON_VERSION   = 3.11
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
	@echo -e "\n$(tput_yellow)Upgrading pip3 and installing packages$(tput_end)"
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	python3 -m pip install --upgrade pip && \
	pip3 install -r source/requirements.txt
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
	@echo -e "\n$(tput_yellow)Displaying detected pyenv-virtualenvs $(tput_end)"
	pyenv virtualenvs
	@eval "$$(pyenv init -)" && \
	pyenv activate $(VENV_NAME) && \
	echo -e "\n$(tput_yellow)Displaying list of installed pip3 packages in $(VENV_NAME)$(tput_end)" && \
	pip3 list

.PHONY: venv-rm
venv-rm:
	@echo -e "\n$(tput_yellow)Removing ${VENV_NAME}$(tput_end)"
	pyenv virtualenv-delete --force ${VENV_NAME}
