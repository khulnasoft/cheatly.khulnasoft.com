# Use a Python-specific Alpine image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Install build tools, Git, and libraries required for ICU and Python dependencies
RUN apk add --no-cache --virtual build-deps \
      build-base \
      pkgconfig \
      icu-dev \
      py3-pip \
      git \
    && apk add --no-cache \
      libffi-dev \
      py3-icu \
      py3-jinja2 \
      py3-flask \
      bash \
      gawk

# Copy only requirements.txt first to leverage Docker caching
COPY requirements.txt .

# Upgrade pip, setuptools, wheel and install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Fetch additional data
RUN mkdir -p /root/.cheatly.khulnasoft.com/log/ \
    && python3 lib/fetch.py fetch-all

# Set entrypoint and command
ENTRYPOINT ["python3", "-u", "bin/srv.py"]
CMD []
