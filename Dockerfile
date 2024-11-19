# Use a Python-specific Alpine image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache \
    git \
    g++ \
    libffi-dev \
    py3-six \
    py3-pygments \
    py3-yaml \
    py3-gevent \
    libstdc++ \
    py3-colorama \
    py3-requests \
    py3-icu \
    py3-redis \
    py3-jinja2 \
    py3-flask \
    bash \
    gawk

# Copy only requirements.txt first for better caching
COPY requirements.txt .

# Install Python build dependencies and application dependencies
RUN apk add --no-cache --virtual build-deps py3-pip \
    && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
    && pip3 install --no-cache-dir -r requirements.txt \
    && apk del build-deps

# Copy application files
COPY . /app

# Fetch dependencies
RUN mkdir -p /root/.cheatly.khulnasoft.com/log/ \
    && python3 lib/fetch.py fetch-all

# Expose application port (optional)
EXPOSE 5000

# Define entrypoint and default command
ENTRYPOINT ["python3", "-u", "bin/srv.py"]
CMD []
