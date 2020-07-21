FROM python:3.7

ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat \
    locales-all \
    fonts-noto* \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /mho
WORKDIR /mho
COPY requirements.txt /mho/
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
COPY ./static /tmp/mho-static
COPY ./static/font/paratype-pt-sans /usr/share/fonts/

ENTRYPOINT ["/mho/entrypoint.sh"]
