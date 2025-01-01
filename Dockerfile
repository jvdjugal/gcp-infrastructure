FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y curl

# Download and install Cloud SQL Proxy
RUN curl -o /cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -L
RUN chmod +x /cloud_sql_proxy

# Set the default command to run the Cloud SQL Proxy
CMD /cloud_sql_proxy -dir=/cloudsql -credential_file=/etc/gcp/credentials.json -instances=dspl-24-poc:us-central1:my-instance & npm start
