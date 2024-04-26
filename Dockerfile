FROM python:3.9-slim

WORKDIR /app

RUN apt-get update
RUN pip install --upgrade pip setuptools

ENV OPENBLAS_CORETYPE ARMV8
RUN echo using OPENBLAS_CORETYPE=$OPENBLAS_CORETYPE

COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN echo testing torch import
RUN python3 -c 'import torch'

ARG MODEL_NAME
COPY download_model.py .
RUN python3 ./download_model.py

COPY . .

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["uvicorn app:app --host 0.0.0.0 --port 8080"]
