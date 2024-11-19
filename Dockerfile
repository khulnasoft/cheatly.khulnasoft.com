# Use a lightweight Alpine image
FROM alpine:3.14

# Set working directory
WORKDIR /app

# Install runtime dependencies
RUN apk add --update --no-cache \
    git \
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
    sed \
    bash \
    gawk

# Install build dependencies, build missing Python packages, then clean up
RUN apk add --no-cache --virtual build-deps \
      py3-pip g++ python3-dev libffi-dev \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir pygments \
    && apk del build-deps

# Copy application files
COPY . .

# Install Python dependencies
RUN apk add --no-cache --virtual build-deps py3-pip \
    && pip3 install --no-cache-dir -r requirements.txt \
    && apk del build-deps

# Fetch dependencies and prepopulate data
RUN mkdir -p /root/.cheatly.khulnasoft.com/log/ \
    && python3 lib/fetch.py fetch-all

# Expose a port if needed (e.g., Flask default port 5000)
EXPOSE 5000

# Define entry point and default command
ENTRYPOINT ["python3", "-u", "bin/srv.py"]
CMD []
