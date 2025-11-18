# Python Flask App

This is a simple web application using [Python Flask](http://flask.pocoo.org/) and [MySQL](https://www.mysql.com/) database.
This is used in the demonstration of development of Ansible Playbooks.

## Docker commands
- docker build . -t python-flask
- docker run -p 8080:5000 python-flask:latest
> now you can access `localhost:8080`