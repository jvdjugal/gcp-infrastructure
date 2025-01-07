FROM python:3.9-slim

# Install git to fetch bcc from GitHub
RUN apt-get update && apt-get install -y git

WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . /app/

EXPOSE 5000
CMD ["python", "app.py"]
