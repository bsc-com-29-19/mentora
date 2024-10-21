# python version
FROM python:3.12-slim 

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
# ENV APP_ENV=prod


# create the working directory
WORKDIR /app
COPY . /app


# install requirred packages
RUN pip install --no-cache-dir -r /app/requirements.txt

# Expose the port on which mentora will run
EXPOSE  8400 


RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
