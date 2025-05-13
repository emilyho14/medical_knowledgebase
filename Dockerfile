# Use a base image with a package manager
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install SWI-Prolog and curl (optional)
RUN apt-get update && \
    apt-get install -y swi-prolog curl && \
    apt-get clean

# Set working directory
WORKDIR /var/www/html/eeho2

# Copy project files into the container
COPY . .

# Expose port your Prolog server listens on (adjust if needed)
EXPOSE 5000

# Start the Prolog server
CMD ["swipl", "-q", "-g", "lab_server:start_server(5000)"]
