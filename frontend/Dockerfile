FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install flask

COPY . .
EXPOSE 80

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]