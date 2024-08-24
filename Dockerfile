# Use an appropriate base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the contents of the three folders into the container
COPY coredns /app/coredns
COPY coredns-api/api.py /app/coredns-api/api.py
COPY coredns-api/requirements.txt /app/coredns-api/requirements.txt
COPY coredns-config /app/coredns-config

RUN pip install --no-cache-dir -r coredns-api/requirements.txt

# Expose ports if needed
EXPOSE 1053/udp
EXPOSE 5000

# Run both apps
CMD ["/bin/bash", "-c", "/app/coredns/coredns -dns.port=1053 -conf /app/coredns-config/coredns.conf & /usr/local/bin/python /app/coredns-api/api.py "]