# Django-Celery-Example

This is a simple example about integrating Celery in Django website, it uses celery to run a long task and shows a progress bar about the progress of the task.

![image](https://raw.githubusercontent.com/sunshineatnoon/Django-Celery-Example/master/images/2.png)
![image](https://raw.githubusercontent.com/sunshineatnoon/Django-Celery-Example/master/images/3.png)
![image](https://raw.githubusercontent.com/sunshineatnoon/Django-Celery-Example/master/images/1.png)

[ forked from `Django-Celery-Example` [here](https://github.com/sunshineatnoon/Django-Celery-Example) ]

# Installation

Clone this repository

```
git clone https://github.com/stevekm/Django-Celery-Example.git
cd Django-Celery-Example
```

Install all dependencies in the current directory with `conda`

```
make conda install
```

Initialize the Django app

```
make django-init
```

# Usage:

Run each of these steps in separate terminal windows.

## Start RabbitMQ

```
make rabbitmq-start
```

## Start Celery

```
make celery-start
```

## Start Django server

```
make django-runserver
```

- Then visit [http://127.0.0.1:8000/index/](http://127.0.0.1:8000/index/) in Chrome or Firefox web browsers.

# Software

Tested on macOS 10.12.6
