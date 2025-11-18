FROM python:3.8-slim-buster

WORKDIR /opt
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY src/app.py /opt/
ENV FLASK_APP=/opt/app.py
CMD ["flask", "run", "--host=0.0.0.0"]