# include Makefile.in

# REPO := 

# #CODE_FILES := $(shell find . -type f -name '*.sh' -o -type f -name '.bash*' | sort)
# CODE_FILES := $(shell git ls-files | grep -E -e '\.sh$$' -e '\.bash[^/]*$$' -e '\.groovy$$' | sort)

# CONF_FILES := $(shell sed "s/\#.*//; /^[[:space:]]*$$/d" setup/files.txt)

# BASH_PROFILE_FILES := $(shell echo .bashrc .bash_profile .bash.d/*.sh)


ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif
SHELL := /bin/bash
.DEFAULT_GOAL := help

DOCKER_USERNAME ?= joelwembo
APPLICATION_NAME ?= prodxcloud-infrastructure
GIT_HASH ?= $(shell git log --format="%h" -n 1)
REPO := https://github.com/joelwembo/prodxcloud-infrastructure


CODE_FILES := $(shell git ls-files | grep -E -e '\.sh$$' -e '\.bash[^/]*$$' -e '\.groovy$$' | sort)

CONF_FILES := $(shell sed "s/\#.*//; /^[[:space:]]*$$/d" setup/files.txt)

BASH_PROFILE_FILES := $(shell echo .bashrc .bash_profile .bash.d/*.sh)


help:
	@ echo "Use one of the following targets:"
	@ tail -n +8 Makefile |\
	egrep "^[a-z]+[\ :]" |\
	tr -d : |\
	tr " " "/" |\
	sed "s/^/ - /g"
	@ echo "Read the Makefile for further details"


venv virtualenv:
	@ echo "Creating a new virtualenv..."
	@ rm -rf venv || true
	@ python3.11 -m venv venv
	@ echo "Done, now you need to activate it. Run:"
	@ echo "source venv/bin/activate"

activate:
	@ echo "Activating this python3.11 Virtual venv Env:"
	@ bash --rcfile "./venv/bin/activate"


requirements pip:
	@ if [ -z "${VIRTUAL_ENV}" ]; then \
		echo "Not inside a virtualenv."; \
		exit 1; \
	fi
	@ echo "Upgrading pip..."
	@ python3.11 -m pip install --upgrade pip
	@ echo "Updating pip packages:"
	@ pip install -r "requirements.txt"
	@ echo "Self installing this package in edit mode:"
	# @ pip install -e .
	@ echo "All pip libraries installed You are ready to go ;-)"


requirementsdev:
	@ if [ -z "${VIRTUAL_ENV}" ]; then \
		echo "Not inside a virtualenv."; \
		exit 1; \
	fi
	@ echo "Upgrading pip..."
	# @ python3.11 -m pip install --upgrade pip
	@ echo "Updating pip packages:"
	@ pip install -r "requirements_dev.txt"


cleanfull:
	@ echo "Cleaning old files..."
	@ rm -rf **/.pytest_cache
	@ rm -rf .tox
	@ rm -rf dist
	@ rm -rf build
	@ rm -rf **/__pycache__
	@ rm -rf *.egg-info
	@ rm -rf .coverage*
	@ rm -rf **/*.pyc
	@ rm -rf env
	@ rm -rf venv
	@ rm -rf local
	@ rm -rf .aws-sam
	@ echo "All done!"

clean:
	@ echo "Cleaning old files..."
	@ rm -rf **/.pytest_cache
	@ rm -rf .tox
	@ rm -rf dist
	@ rm -rf build
	@ rm -rf **/__pycache__
	@ rm -rf *.egg-info
	@ rm -rf .coverage*
	@ rm -rf **/*.pyc
	@ echo "All done!"


image-install:
	@ bash ./setup/installer.sh

aws-install:
	@ bash ./setup/aws_installer.sh

azure-install:
	@ bash ./setup/azure_installer.sh

python-install:
	@ bash ./setup/python_installer.sh

terraform-install:
	@ bash ./setup/terraform_installer.sh

jenkins-install:
	@ bash ./setup/install_jenkins_ubuntu.sh

kubernetes-install:
	@ bash ./setup/install_minikube_ubuntu.sh

	
nodejs-intall:
	@ bash ./setup/node_installer.sh


build:

	@ docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} .

push:
	@ docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}

docker-run:
	@ docker-compose down 
	@ docker-compose build --no-cache
	@ docker-compose up

release:
	@ docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}
	@ docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
	@ docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest


