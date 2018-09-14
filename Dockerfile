FROM alpine:3.8

RUN apk --no-cache add mtr python py-setuptools

WORKDIR /opt/mtr-web
COPY requirements.txt .

RUN \
  apk --no-cache add --virtual build-dependencies gcc g++ python-dev py2-pip && \
  pip install -r requirements.txt && \
  apk del build-dependencies

COPY . .

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "-k", "flask_sockets.worker", "mtr-web:app"]
