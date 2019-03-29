SHELL:=/bin/bash
HOMEDIR:=$(shell echo $$HOME)
UNAME:=$(shell uname)
export LOG_DIR:=logs
export LOG_DIR_ABS:=$(shell python -c 'import os; print(os.path.realpath("$(LOG_DIR)"))')

# ~~~~~ Setup Conda ~~~~~ #
# this sets the system PATH to ensure we are using in included 'conda' installation for all software
PATH:=$(CURDIR)/conda/bin:$(PATH)
unexport PYTHONPATH
unexport PYTHONHOME

# install versions of conda for Mac or Linux
ifeq ($(UNAME), Darwin)
CONDASH:=Miniconda2-4.5.4-MacOSX-x86_64.sh
endif

ifeq ($(UNAME), Linux)
CONDASH:=Miniconda2-4.5.4-Linux-x86_64.sh
endif

CONDAURL:=https://repo.continuum.io/miniconda/$(CONDASH)

# install conda
conda:
	@echo ">>> Setting up conda..."
	@wget "$(CONDAURL)" && \
	bash "$(CONDASH)" -b -p conda && \
	rm -f "$(CONDASH)"

# install the conda and python packages required
# NOTE: **MUST** install ncurses from conda-forge for RabbitMQ to work!!
conda-install:
	conda install -y -c anaconda -c bioconda \
	conda-forge::ncurses \
	django=1.9 \
	celery=3.1.23 \
	rabbitmq-server=3.7.13 \
	numpy=1.16.2 \
	scipy=1.2.1
# conda install -y conda-forge::ncurses && \

test:
	# conda search django
	# conda search -c anaconda -c bioconda celery
	# conda search -c anaconda -c bioconda rabbitmq-server
	conda list


# ~~~~~ Django ~~~~~ #

django-init:
	python manage.py makemigrations
	python manage.py migrate
	python manage.py createsuperuser

django-runserver:
	python manage.py runserver

# ~~~~~~ RabbitMQ ~~~~~~ #
export RABBITMQ_LOG_BASE:=$(LOG_DIR_ABS)
export RABBITMQ_LOGS:=rabbitmq.log
export RABBITMQ_PID_FILE:=$(RABBITMQ_LOG_BASE)/rabbitmq.pid
rabbitmq-start:
	rabbitmq-server
# rabbitmq-server -detached

rabbitmq-stop:
	rabbitmqctl stop
rabbitmq-check:
	-rabbitmqctl status


# ~~~~~~ Celery ~~~~~~ #
CELERY_PID_FILE:=$(LOG_DIR_ABS)/celery.pid
CELERY_LOGFILE:=$(LOG_DIR_ABS)/celery.log

celery-start:
	celery worker --app celery_try \
	--loglevel info \
	--pidfile "$(CELERY_PID_FILE)" \
	--logfile "$(CELERY_LOGFILE)" \

celery-stop:
	ps auxww | grep 'celery' | grep -v 'grep' | grep -v 'make celery-stop' | awk '{print $$2}' | xargs kill -9

celery-check:
	-ps auxww | grep 'celery' | grep -v 'grep' | grep -v 'make celery-check'
