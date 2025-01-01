FROM node:16

# Set working directory
WORKDIR /usr/src/app

# Install Cloud SQL Auth Proxy dependencies
RUN apt-get update && apt-get install -y curl

# Install Cloud SQL Auth Proxy
RUN curl -o /cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -L
RUN chmod +x /cloud_sql_proxy

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all files for the app
COPY . .

# Copy the key file (for Cloud SQL Auth Proxy)
COPY dspl-24-poc-b21ed68c39b3.json /etc/gcp/credentials.json

# Expose port for frontend app (using port 80)
EXPOSE 80

# Set environment variable for Cloud SQL credentials
ENV GOOGLE_APPLICATION_CREDENTIALS=/etc/gcp/credentials.json

# Start Cloud SQL Auth Proxy and then start the app
CMD /cloud_sql_proxy -dir=/cloudsql -credential_file=/etc/gcp/credentials.json & npm start
